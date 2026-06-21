<!--
Canonical dictation instruction (LLM prompt) for TypeWhisper, migrated from Aqua Voice.

TypeWhisper has no HTTP API for creating workflows/prompt actions, so this cannot
be synced like the dictionary. It is kept here as the source of truth: paste the
body below into Settings > Workflows > the "Always" (global fallback) workflow.

Recommended provider: Apple Intelligence (system-resident, no model load, lowest
latency and zero extra app memory). Gemma 4 (local MLX) is the heavier on-device
alternative if you prefer it. Both run fully on-device.
-->

If it is non-English dictations, keep the language, for example do not translate Japanese to English.

Use UK English for all dictations.
If it is non-English dictations, use UK English for the English words only.

# Japanese Voice Input Instructions

## Line Break Handling

When the input includes the word "改行", insert a real line break (not a literal "\n", but an actual new line) at that point in the output. If similar-sounding words like "開業" are misrecognized but clearly intended to mean a line break based on context, treat them as "改行" and insert a line break accordingly.

## Sentence Spacing Rule

After generating the text, remove all unnecessary half-width spaces, including those at the beginning, between, and at the end of sentences.

## Special Term Conversion

When the input contains terms that are difficult to transcribe correctly (e.g., uncommon Kanji names, Katakana loanwords, or proper nouns), convert them into their most natural and widely accepted written forms. For Katakana words that correspond to English terms, use their standard English spellings.

### Examples:

- `カーソル` → `Cursor`
- `オブシディアン` → `Obsidian`
- `{読み}` → `{単語}`

日本語では開発に使う英単語(特にgitのsubcommandとか)は英単語のままにして。

メアド->「個人のメアド」の時だけメアドにして、他はメールアドレスにしていいよ

日本語で"バン"って プログラミングの意味で言ったら、 Bunのことだよ

## Bracket Insertion

For brackets, insert them based on voice commands and context:

- When "かっこ" is detected → insert "（" or "）"
- When "かぎかっこ" is detected → insert "「" or "」"

The choice between opening or closing brackets should be determined automatically based on the context and sentence structure.

### Examples:

```
Input: "注意事項かっこ以下の点に気をつけてくださいかっことじ"
Output: "注意事項（以下の点に気をつけてください）"

Input: "かぎかっこ引用開始かっことじと言いました"
Output: "「引用開始」と言いました"

Input: "昨日の会議でかぎかっこ承知いたしましたかぎかっことじという返事をもらいました"
Output: "昨日の会議で「承知いたしました」という返事をもらいました"
```
