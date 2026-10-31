#!/usr/bin/env nix
#! nix shell --inputs-from . nixpkgs#nushell --command nu

def script-dir []: nothing -> string {
    $env.CURRENT_FILE | path dirname
}

def is-list-or-table [value]: nothing -> bool {
    ($value | describe) =~ '^(list|table)'
}

def clean-term [value: string]: nothing -> string {
    $value
    | str trim
    | str replace --all --regex '\s+' ' '
}

def term-key [value: string]: nothing -> string {
    clean-term $value
    | str lowercase
}

def correction-key [value: string]: nothing -> string {
    $value | str trim | str lowercase
}

def parse-dictionary [data, source: string]: nothing -> record {
    if ($data | describe) !~ '^record' or (($data | columns | sort) != ['corrections' 'terms']) {
        error make {msg: $"($source): expected only the terms and corrections fields"}
    }

    let terms = $data.terms
    let corrections = $data.corrections
    if not (is-list-or-table $terms) or not ($terms | all {|term| ($term | describe) == 'string'}) {
        error make {msg: $"($source): terms must be an array of strings"}
    }
    if ($terms | length) > 500 or ($terms | any {|term| (clean-term $term | is-empty) or (clean-term $term) != $term or ($term | str length --chars) > 64}) {
        error make {msg: $"($source): terms must be non-empty, normalised strings of at most 64 characters; Hex allows 500"}
    }
    let term_keys = $terms | each {|term| term-key $term}
    if ($term_keys | group-by | columns | length) != ($term_keys | length) {
        error make {msg: $"($source): terms must be unique ignoring case and whitespace"}
    }

    if not (is-list-or-table $corrections) {
        error make {msg: $"($source): corrections must be an array of correction records"}
    }
    for correction in $corrections {
        if ($correction | describe) !~ '^record' or (($correction | columns | sort) != ['caseSensitive' 'original' 'replacement']) {
            error make {msg: $"($source): each correction must contain original, replacement, and caseSensitive"}
        }
        if ($correction.original | describe) != 'string' or ($correction.replacement | describe) != 'string' or ($correction.caseSensitive | describe) != 'bool' {
            error make {msg: $"($source): correction fields have invalid types"}
        }
        if ($correction.original | str trim | is-empty) or ($correction.replacement | str trim | is-empty) {
            error make {msg: $"($source): correction phrases and replacements must be non-empty"}
        }
        if $correction.caseSensitive {
            error make {msg: $"($source): case-sensitive corrections cannot be represented by Hex"}
        }
    }
    let correction_keys = $corrections | each {|correction| correction-key $correction.original}
    if ($correction_keys | group-by | columns | length) != ($correction_keys | length) {
        error make {msg: $"($source): correction originals must be unique ignoring case"}
    }

    {terms: $terms, corrections: $corrections}
}

def locate-hex []: nothing -> any {
    let override = $env.HEX_BIN? | default ''
    if ($override | is-not-empty) {
        if ($override | path exists) {
            return ($override | path expand)
        }
        let from_path = which $override | where type == 'external' | get --optional 0.path
        return $from_path
    }

    let from_path = which hex | where type == 'external' | get --optional 0.path
    if $from_path != null {
        return $from_path
    }

    let app_cli = '/Applications/Hex.app/Contents/MacOS/hex'
    if ($app_cli | path exists) { $app_cli } else { null }
}

def run-hex [binary: string, args: list<string>]: nothing -> record {
    do { run-external $binary ...$args } | complete
}

def decode-reply [result: record, operation: string]: nothing -> record {
    if $result.exit_code != 0 {
        error make {msg: $"hex-dict-sync: Hex failed to ($operation) (exit ($result.exit_code))"}
    }
    let reply = try {
        $result.stdout | from json
    } catch {
        error make {msg: $"hex-dict-sync: Hex returned invalid JSON for ($operation)"}
    }
    if ($reply | describe) !~ '^record' or $reply.version? != 4 {
        error make {msg: $"hex-dict-sync: Hex returned an unexpected response for ($operation)"}
    }
    $reply
}

def require-status [reply: record, status: string, operation: string]: nothing -> record {
    if $reply.status? != $status {
        error make {msg: $"hex-dict-sync: Hex returned an unexpected response for ($operation)"}
    }
    $reply
}

def main [--strict, --dry-run, ...args: string]: nothing -> nothing {
    if ($args | length) > 1 {
        error make {msg: 'usage: hex/dict-sync.nu [--strict] [--dry-run] [dictionary.json]'}
    }
    let file = if ($args | is-empty) {
        (script-dir) | path join dictionary.json
    } else {
        $args.0 | path expand
    }
    let raw = try { open $file } catch {
        error make {msg: $"hex-dict-sync: cannot read JSON from ($file)"}
    }
    let dictionary = parse-dictionary $raw $file
    let managed_replacements = $dictionary.corrections | each {|correction|
        {matched_phrase: $correction.original, output: $correction.replacement}
    }

    let binary = locate-hex
    if $binary == null {
        if $strict { error make {msg: 'hex-dict-sync: Hex CLI is unavailable'} }
        if $dry_run {
            print $"hex-dict-sync: dry run; ($dictionary.terms | length) terms, ($dictionary.corrections | length) corrections; Hex unavailable"
        }
        print --stderr 'hex-dict-sync: Hex CLI is unavailable; skipping'
        return
    }

    let vocabulary_result = try { run-hex $binary ['vocabulary' 'list' '--json'] } catch { null }
    if $vocabulary_result == null or $vocabulary_result.exit_code == 3 {
        if $strict { error make {msg: 'hex-dict-sync: Hex is not running'} }
        if $dry_run {
            print $"hex-dict-sync: dry run; ($dictionary.terms | length) terms, ($dictionary.corrections | length) corrections; Hex not running"
        }
        print --stderr 'hex-dict-sync: Hex is not running; skipping'
        return
    }
    let vocabulary = (require-status
        (decode-reply $vocabulary_result 'list vocabulary')
        'vocabulary'
        'list vocabulary'
    )
    if not (is-list-or-table $vocabulary.entries) or not ($vocabulary.entries | all {|entry| ($entry.term? | describe) == 'string'}) {
        error make {msg: 'hex-dict-sync: Hex returned an invalid vocabulary list'}
    }
    let existing_terms = $vocabulary.entries | each {|entry| term-key $entry.term}
    if (($existing_terms | group-by | columns | length) != ($existing_terms | length)) or ($existing_terms | length) > 500 {
        error make {msg: 'hex-dict-sync: Hex vocabulary is invalid or exceeds its 500-term limit'}
    }
    let terms_to_add = $dictionary.terms | where {|term|
        let key = term-key $term
        not ($existing_terms | any {|existing| $existing == $key})
    }
    if (($existing_terms | length) + ($terms_to_add | length)) > 500 {
        error make {msg: 'hex-dict-sync: adding these terms would exceed Hex’s 500-term limit'}
    }

    let settings_result = run-hex $binary ['settings' 'get' 'dictation_processing.default_mode' '--json']
    let settings_reply = (require-status
        (decode-reply $settings_result 'read Global mode')
        'settings'
        'read Global mode'
    )
    let mode_setting = $settings_reply.settings | where {|setting| $setting.key == 'dictation_processing.default_mode'} | get --optional 0
    if $mode_setting == null or $mode_setting.kind != 'json' or not $mode_setting.writable or ($mode_setting.value | describe) !~ '^record' {
        error make {msg: 'hex-dict-sync: Hex returned an invalid Global mode'}
    }
    let mode = $mode_setting.value
    let existing_replacements = $mode.replacements? | default []
    if not (is-list-or-table $existing_replacements) or not ($existing_replacements | all {|rule| ($rule.matched_phrase? | describe) == 'string' and ($rule.output? | describe) == 'string'}) {
        error make {msg: 'hex-dict-sync: Global replacements are invalid'}
    }

    # Hex UI-authored rules must survive a sync from the managed dictionary.
    let updated_replacements = $existing_replacements | each {|rule|
        let key = correction-key $rule.matched_phrase
        let managed = $managed_replacements | where {|replacement| (correction-key $replacement.matched_phrase) == $key} | get --optional 0
        if $managed == null { $rule } else { $managed }
    }
    let existing_replacement_keys = $existing_replacements | each {|rule| correction-key $rule.matched_phrase}
    let new_replacements = $managed_replacements | where {|replacement|
        let key = correction-key $replacement.matched_phrase
        not ($existing_replacement_keys | any {|existing| $existing == $key})
    }
    let merged_replacements = $updated_replacements | append $new_replacements
    let corrections_to_change = $managed_replacements | where {|replacement|
        let key = correction-key $replacement.matched_phrase
        let matching = $existing_replacements | where {|rule| (correction-key $rule.matched_phrase) == $key}
        ($matching | is-empty) or ($matching | any {|rule| $rule != $replacement})
    } | length
    let settings_changed = $merged_replacements != $existing_replacements

    if $dry_run {
        print $"hex-dict-sync: dry run; ($terms_to_add | length) terms to add, ($corrections_to_change) Global replacements to change"
        return
    }

    let added = $terms_to_add | each {|term|
        let result = run-hex $binary ['vocabulary' 'add' $term '--json']
        let reply = require-status (decode-reply $result 'add vocabulary term') 'done' 'add vocabulary term'
        if ($reply.changed? | describe) != 'bool' {
            error make {msg: 'hex-dict-sync: Hex returned an invalid vocabulary update'}
        }
        $reply.changed
    } | where {|changed| $changed} | length

    if $settings_changed {
        let updated_mode = $mode | upsert replacements $merged_replacements
        let json = $updated_mode | to json --raw
        let result = run-hex $binary ['settings' 'set' 'dictation_processing.default_mode' $json '--json']
        let reply = (require-status
            (decode-reply $result 'save Global mode')
            'done'
            'save Global mode'
        )
        if ($reply.changed? | describe) != 'bool' {
            error make {msg: 'hex-dict-sync: Hex returned an invalid Global mode update'}
        }
    }

    print $"hex-dict-sync: added ($added) terms, changed ($corrections_to_change) Global replacements"
}
