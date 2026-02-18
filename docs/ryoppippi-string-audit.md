# 「ryoppippi」文字列の監査メモ（asktt1770 用）

`grep -r "ryoppippi"` でヒットした箇所を、「要変更」「変更不要」「任意」に分類したメモ。  
フォーク後に自分用に揃える際の参照用。

**実施状況**: 要変更・任意の書き換えは実施済み（一部は事前に変更済みだった）。  
**「ryoppippi さん環境と同じにしたい」場合**: nvim-in-the-loop / ccusage / leetcode は **ryoppippi のまま** 利用する想定で、`nvim/lua/plugin/ai-keymap.lua`・`nix/modules/home/programs/claude-code/settings.json`・`nvim/lua/plugin/leetcode.lua` を ryoppippi 参照に揃えている。必要な clone 一覧は `docs/ryoppippi-external-repos.md` を参照。

---

## 要変更（自分の環境で動かすために必須）

| ファイル | 内容 | 推奨対応 |
|----------|------|----------|
| **.github/workflows/update-node-packages.yaml** | `darwinConfigurations.ryoppippi.system` | `darwinConfigurations.asktt1770.system` に変更（CI が正しい flake 出力をビルドするため） |
| **.github/workflows/nix-diff.yaml** | `homeConfigurations.ryoppippi` / `ryoppippi-aarch64` | `asktt1770` / `asktt1770-aarch64` に変更 |
| **.github/workflows/nix-build.yaml** | 同上 | 同上 |
| **fish/functions/dotfiles-pull.fish** | `github.com/ryoppippi/dotfiles` | `github.com/asktt1770/dotfiles` に変更（`dotfiles-pull` で自分のリポジトリを pull するため） |
| **bash/.bashrc** | `/Users/ryoppippi/.lmstudio/bin` | `$HOME/.lmstudio/bin` または `/Users/asktt1770/.lmstudio/bin` に変更（LM Studio の PATH） |

※ flake.nix の `username = "asktt1770"` により、ビルドされるのは `darwinConfigurations.asktt1770` と `homeConfigurations.asktt1770` / `asktt1770-aarch64` です。CI だけ ryoppippi のままなので要修正。

---

## 変更不要（外部参照・他人のリポジトリのまま使う）

| ファイル | 内容 | 理由 |
|----------|------|------|
| **flake.nix** | `description`、`ryoppippi.cachix.org`、`inputs` の `claude-code-overlay` / `gh-nippou` / `fish-na` | 説明文・キャッシュ・外部パッケージの参照。そのままでよい。 |
| **nix/cachix.nix** | 同上 | 同上 |
| **nix/modules/home/programs/fish/default.nix** | `owner = "ryoppippi"`（bdf.fish 等） | プラグインの GitHub オーナー。取得元なので変更しない。 |
| **nix/overlays/claude-code.nix** | コメント内の ryoppippi URL | ドキュメント用。変更不要。 |
| **nvim/** の各種 `.lua` | `ryoppippi/xxx` のプラグイン名・パス | Neovim プラグインの取得元。そのまま使うなら変更不要。 |
| **nvim/template/** | `github>ryoppippi/renovate-config` 等 | Renovate の extends。本家の設定を参照するならそのまま。 |
| **.github/actions/setup-nix/action.yaml** | Cachix の名前表示「ryoppippi」 | 表示名のみ。キャッシュは ryoppippi のものを利用するのでそのままでよい。 |
| **flake.lock** | `"owner": "ryoppippi"` | 外部 input の lock。`nix flake update` で更新される。手でいじらない。 |

---

## 任意（好み・運用に応じて）

| ファイル | 内容 | 備考 |
|----------|------|------|
| **claude/CLAUDE.md** | `My name is ryoppippi` | 自分用メモなら `asktt1770` などに変更するとよい。 |
| **nix/modules/home/programs/claude-code/settings.json** | `ryoppippi/ccusage` のパス | ccusage を自分で clone して使うなら自分のパスに。使わないならそのままでもよい（コマンドが無ければ失敗するだけ）。 |
| **nvim/lua/plugin/leetcode.lua** | `~/ghq/github.com/ryoppippi/leetcode/code/` | 自分用の leetcode リポジトリを用意するならパスを変更。 |
| **nvim/lua/plugin/ai-keymap.lua** | `ryoppippi/nvim-in-the-loop` と `~/ghq/.../ryoppippi/nvim-in-the-loop` | プラグインを本家のまま使うなら変更不要。フォークして使うならパス変更。 |
| **README.md** | clone 先・`.#ryoppippi` の説明 | 自分用リポジトリとして README を書き換えるなら、clone 先と `.#asktt1770` に合わせるとよい。 |

---

## ドキュメント（説明文・手順のため変更不要）

`docs/*.md` 内の「ryoppippi さん」「ryoppippi のリポジトリ」などは、手順や説明として正しいためそのままでよい。  
（本家の名前で参照しているだけなので、フォーク側で書き換える必要はない。）

---

## 4.3 について

`nix/modules` 内の `dotfilesDir` デフォルト値は、すでに `asktt1770` に揃っている場合は **追加の書き換えは不要**。  
未対応のモジュールがある場合のみ、`ghq/github.com/ryoppippi/dotfiles` → `ghq/github.com/asktt1770/dotfiles` に揃える。
