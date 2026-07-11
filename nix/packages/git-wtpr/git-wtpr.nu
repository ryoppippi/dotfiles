# git-wtpr — open a GitHub pull request in a git-wt worktree
#
# Usage:
#   git wtpr <number|url> [git-wt flags...]
#   git-wtpr --init <bash|zsh|fish>
#   git-wtpr --help

def usage [] {
	"
git-wtpr — open a GitHub pull request in a git-wt worktree

Usage:
  git wtpr <number|url> [git-wt flags...]
  git-wtpr --init <bash|zsh|fish>
  git-wtpr -h | --help

Examples:
  git wtpr 25
  git wtpr https://github.com/owner/repo/pull/3984

With shell integration (git-wtpr --init fish|bash|zsh), the default is
to cd into the worktree — same as git wt. Pass --nocd only when you
want the path printed without changing directory.

Resolves the PR with gh, fetches refs/pull/<n>/head, then creates or
switches to a worktree via git-wt using the PR head branch name.

Protected head branch names (main, master) become pr-<number> so the
default branch is never used as a worktree name.

Status messages go to stderr; the worktree path is printed last on
stdout (for shell integration / --nocd).
" | str trim
}

def is-pr-selector [arg: string] {
	($arg =~ '^\d+$') or ($arg =~ '/pull/\d+([/?#].*)?$')
}

def repo-from-pr-url [url: string] {
	# https://host/owner/repo/pull/N → owner/repo
	let matches = ($url | parse --regex '^https?://[^/]+/(?P<repo>[^/]+/[^/]+)/pull/')
	$matches | get --optional 0 | get --optional repo
}

def ref-exists [ref: string] {
	let result = (^git show-ref --verify --quiet $ref | complete)
	$result.exit_code == 0
}

def resolve-remote [] {
	let origin = (^git remote get-url origin | complete)
	if $origin.exit_code == 0 {
		return 'origin'
	}

	let remotes = (^git remote | complete)
	if $remotes.exit_code != 0 {
		error make {msg: 'no git remotes configured'}
	}

	let names = ($remotes.stdout | lines | where {|r| $r | is-not-empty})
	if ($names | is-empty) {
		error make {msg: 'no git remotes configured'}
	}
	$names | first
}

def print-init [shell: string] {
	match $shell {
		'fish' => { print (init-fish) }
		'bash' => { print (init-bash) }
		'zsh' => { print ((init-bash) | str replace 'shell hook for bash' 'shell hook for zsh') }
		_ => {
			print --stderr 'git-wtpr: --init requires bash, zsh, or fish'
			exit 2
		}
	}
}

# --wrapped: pass through git-wt flags like --nocd without nu flag parsing
def --wrapped main [...args: string] {
	if ($args | is-empty) {
		print --stderr (usage)
		exit 2
	}

	let first = ($args | first)

	if $first in ['-h', '--help'] {
		print (usage)
		return
	}

	if $first == '--init' {
		print-init ($args | get --optional 1 | default '')
		return
	}

	mut pr = null
	mut wt_args = []
	for arg in $args {
		if $pr == null and (is-pr-selector $arg) {
			$pr = $arg
		} else {
			$wt_args = ($wt_args | append $arg)
		}
	}

	if $pr == null {
		print --stderr 'git-wtpr: missing PR number or URL'
		print --stderr (usage)
		exit 2
	}

	let in_repo = (^git rev-parse --git-dir | complete)
	if $in_repo.exit_code != 0 {
		error make {msg: 'not inside a git repository'}
	}

	let pr_result = (^gh pr view $pr --json number,headRefName,title,url | complete)
	if $pr_result.exit_code != 0 {
		error make {msg: $"failed to resolve PR: ($pr)"}
	}
	let info = ($pr_result.stdout | from json)

	let pr_repo = (repo-from-pr-url $info.url)
	if $pr_repo == null {
		error make {msg: $"could not parse repository from PR url: ($info.url)"}
	}

	let current_result = (^gh repo view --json nameWithOwner -q .nameWithOwner | complete)
	if $current_result.exit_code != 0 {
		error make {msg: 'could not determine current GitHub repository (is gh authenticated?)'}
	}
	let current_repo = ($current_result.stdout | str trim)

	if $pr_repo != $current_repo {
		error make {msg: $"PR is for ($pr_repo), but current repo is ($current_repo)"}
	}

	mut branch = $info.headRefName
	if $branch in ['main', 'master'] {
		$branch = $"pr-($info.number)"
	}

	let remote = (resolve-remote)

	print --stderr $"git-wtpr: PR #($info.number) — ($info.title)"
	print --stderr $"git-wtpr: branch ($branch) — head ($info.headRefName)"
	print --stderr $"git-wtpr: fetching ($remote) pull/($info.number)/head"

	# Inherit stdio so fetch progress stays on stderr
	^git fetch $remote $"pull/($info.number)/head"
	if $env.LAST_EXIT_CODE != 0 {
		error make {msg: $"failed to fetch pull/($info.number)/head from ($remote)"}
	}

	# Prefer an existing local or remote-tracking branch (git-wt sets up
	# tracking). Only pass FETCH_HEAD when the name is unknown to git —
	# e.g. fork PRs whose head branch is not on origin.
	let has_local = (ref-exists $"refs/heads/($branch)")
	let has_remote = (ref-exists $"refs/remotes/($remote)/($branch)")

	let git_wt_args = if $has_local or $has_remote {
		$wt_args | append $branch
	} else {
		$wt_args | append $branch | append 'FETCH_HEAD'
	}

	# Inherit stdio so git-wt's path lands on stdout (shell integration).
	^git-wt ...$git_wt_args
	exit $env.LAST_EXIT_CODE
}

# --- shell integration (same contract as git-wt --init) ---

def script-dir [] {
	$env.CURRENT_FILE | path dirname
}

def init-fish [] {
	open ((script-dir) | path join init.fish)
}

def init-bash [] {
	open ((script-dir) | path join init.bash)
}
