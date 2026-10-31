# Hex Dictionary

`dictionary.json` is the managed source for Hex's vocabulary and Global text
corrections. It contains `terms` (strings) and `corrections` records with
`original`, `replacement`, and `caseSensitive: false`.

Run `./hex/dict-sync.nu` with Hex open to apply it. `--dry-run` reports counts
without changing Hex; `--strict` fails if Hex is unavailable or not running.
Set `HEX_BIN` when the Hex CLI is outside `PATH` and the standard app location.
Git hooks run the sync after a commit and skip it when Hex is not running.

Sync is additive: it adds missing terms, updates Global corrections with the
same original phrase ignoring case, and preserves other Hex rules. Removing an
item from this file does not delete it from Hex. Hex applies vocabulary decoder
bias only with supported models; the current Cohere transcription model does
not use that bias, while Global corrections still run on its transcripts.
