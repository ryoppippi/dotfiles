# ryoppippi さん環境と同じにするための外部リポジトリ一覧

**結論**: **フォークは不要**です。本家（ryoppippi さん）のリポジトリを **clone してそのまま利用**できます。  
プラグイン名やパスを「ryoppippi」のままにしておけば、clone した先のパスに置くだけで同じ環境が再現できます。

---

## ディレクトリのイメージ（ghq の配置）

Mac のユーザー名を `asktt1770` とする場合の例です（ホームが `/Users/asktt1770`）。

| 種類 | 配置先の例 | 中身 |
|------|------------|------|
| **フォークしたリポジトリ（自分のもの）** | `/Users/asktt1770/ghq/github.com/asktt1770/` | 例: `dotfiles` → `/Users/asktt1770/ghq/github.com/asktt1770/dotfiles` |
| **clone した本家リポジトリ（ryoppippi さんのもの）** | `/Users/asktt1770/ghq/github.com/ryoppippi/` | 例: `nvim-in-the-loop`, `ccusage` など |

dotfiles は **フォーク** なので `~/ghq/github.com/asktt1770/dotfiles` にあり、その中で「パス指定されている clone 先」はすべて **`~/ghq/github.com/ryoppippi/<リポジトリ名>`** です（`~` はその Mac のホーム、例: `/Users/asktt1770`）。

※ ユーザー名が `keisukeasaka` の場合は、上記の `asktt1770` を `keisukeasaka` に読み替えてください（`/Users/keisukeasaka/ghq/github.com/asktt1770/` と `/Users/keisukeasaka/ghq/github.com/ryoppippi/`）。

---

## フォークするか・そのまま使うか

| 方針 | やること | 向いている人 |
|------|----------|--------------|
| **そのまま使う（推奨）** | 本家を `ghq get` し、dotfiles 内のプラグイン名・パスは **ryoppippi のまま** にする。 | ryoppippi さんの環境と同じにしたいだけの場合。 |
| **フォークして使う** | 各リポジトリを自分用にフォークし、dotfiles 内のパス・プラグイン名を **asktt1770** に変更する。 | 自分で改変・公開したい場合。 |

**そのまま利用できる理由**  
- [nvim-in-the-loop](https://github.com/ryoppippi/nvim-in-the-loop) も [ccusage](https://github.com/ryoppippi/ccusage) も **公開リポジトリ**で、clone するだけで利用可能。  
- Neovim の設定では `dir = "~/ghq/github.com/ryoppippi/..."` のように **ローカルパス** を参照しているため、そのパスに本家を clone すれば動作する。  
- フォークは「自分で変更を加えたい」「自分アカウントで管理したい」場合にのみ必要。

---

## 必ず clone が必要なリポジトリ（パスで直接参照されているもの）

dotfiles 内で **絶対パス／ghq パス** が指定されているため、該当パスに clone しないと機能しません。

| リポジトリ | 用途 | clone 先の目安 | 参照しているファイル |
|------------|------|----------------|----------------------|
| [ryoppippi/nvim-in-the-loop](https://github.com/ryoppippi/nvim-in-the-loop) | Neovim の AI キーマップ解析プラグイン（Human-in-the-loop） | `~/ghq/github.com/ryoppippi/nvim-in-the-loop` | `nvim/lua/plugin/ai-keymap.lua`（`dir`） |
| [ryoppippi/ccusage](https://github.com/ryoppippi/ccusage) | Claude Code / Codex の利用量・コスト分析 CLI。ステータスライン用 | `~/ghq/github.com/ryoppippi/ccusage` | `nix/modules/home/programs/claude-code/settings.json`（statusLine の command） |

**手順例**（ghq 利用時）:

```bash
ghq get github.com/ryoppippi/nvim-in-the-loop
ghq get github.com/ryoppippi/ccusage
```

---

## 使う場合だけ clone すればよいリポジトリ

機能を使う場合のみ、指定パスに clone します。使わない場合は clone 不要（該当機能が無効になるだけです）。

| リポジトリ | 用途 | clone 先の目安 | 参照しているファイル |
|------------|------|----------------|----------------------|
| [ryoppippi/leetcode](https://github.com/ryoppippi/leetcode)（※） | LeetCode 用 Neovim プラグインの解答保存先 | `~/ghq/github.com/ryoppippi/leetcode`（`code/` が保存先） | `nvim/lua/plugin/leetcode.lua`（`storage.home`） |

※ リポジトリが非公開の場合は、自分用の leetcode 用ディレクトリを同じパスに用意するか、`leetcode.lua` の `storage.home` を自分のパスに変更してください。

---

## Neovim の dev プラグイン（`~/ghq/github.com/ryoppippi/` 下）

`nvim/lua/config/pack.lua` で `dev.path = "~/ghq/github.com/ryoppippi/"` が指定されています。  
次のプラグインは、Lazy.nvim の dev としてこのパス配下を参照します。**同じ環境にしたい場合は、ここに clone されている必要があります。**

| プラグイン名（Lazy での指定） | 想定 clone 先 |
|-------------------------------|----------------|
| ryoppippi/svelte_inspector.vim | `~/ghq/github.com/ryoppippi/svelte_inspector.vim` |
| ryoppippi/my-personal-snippets | `~/ghq/github.com/ryoppippi/my-personal-snippets` |
| ryoppippi/bun-to-deno | `~/ghq/github.com/ryoppippi/bun-to-deno` |
| ryoppippi/vim-ray-so | `~/ghq/github.com/ryoppippi/vim-ray-so` |
| ryoppippi/nvim-reset | `~/ghq/github.com/ryoppippi/nvim-reset` |
| ryoppippi/nvim-pnpm-catalog-lens | `~/ghq/github.com/ryoppippi/nvim-pnpm-catalog-lens` |
| ryoppippi/denippet-autoimport-vscode | `~/ghq/github.com/ryoppippi/denippet-autoimport-vscode` |
| ryoppippi/bad-apple.vim | `~/ghq/github.com/ryoppippi/bad-apple.vim` |

その他、`ryoppippi-*` という名前のプラグイン（ryoppippi-term.nvim, ryoppippi-snippets-list など）も、Lazy が GitHub から取得するか、dev.path の下に clone される想定です。  
**一括で用意する例**:

```bash
ghq get github.com/ryoppippi/svelte_inspector.vim
ghq get github.com/ryoppippi/my-personal-snippets
ghq get github.com/ryoppippi/bun-to-deno
ghq get github.com/ryoppippi/vim-ray-so
ghq get github.com/ryoppippi/nvim-reset
ghq get github.com/ryoppippi/nvim-pnpm-catalog-lens
ghq get github.com/ryoppippi/denippet-autoimport-vscode
ghq get github.com/ryoppippi/bad-apple.vim
```

※ 上記のうち非公開リポジトリがある場合は、そのプラグインはスキップするか、代替設定にしてください。

---

## Nix が自動で取得するため clone 不要のもの

`flake.nix` の `inputs` で参照されているリポジトリは、**Nix のビルド時に自動で fetch されます**。手元で `ghq get` する必要はありません。

| リポジトリ | 用途 |
|------------|------|
| ryoppippi/claude-code-overlay | Claude Code 用 Nix overlay |
| ryoppippi/gh-nippou | 日報用 CLI（Nix でインストール） |
| ryoppippi/fish-na | Fish 用プラグイン（Nix で参照） |

---

## 参照のみで clone 不要のもの

次のものは「設定の参照先」や「テンプレート」であり、**実行時にそのリポジトリの実体がローカルにある必要はありません**。

| 内容 | 参照箇所 |
|------|----------|
| ryoppippi/renovate-config | `nvim/template/json/base-renovate*.json`（Renovate の extends） |
| ryoppippi の Cachix | `flake.nix` / `nix/cachix.nix`（ビルドキャッシュ） |
| Fish プラグインの owner | `nix/modules/home/programs/fish/default.nix`（bdf.fish 等の取得元） |

---

## チェックリスト（ryoppippi さん環境と同じにしたい場合）

- [ ] `nvim-in-the-loop` を `~/ghq/github.com/ryoppippi/nvim-in-the-loop` に clone した
- [ ] `ccusage` を `~/ghq/github.com/ryoppippi/ccusage` に clone した
- [ ] （LeetCode を使う場合）`leetcode` を clone するか、保存先を自分のパスに変更した
- [ ] （Neovim の dev プラグインをすべて使う場合）上記「Neovim の dev プラグイン」一覧を `~/ghq/github.com/ryoppippi/` に clone した
- [ ] dotfiles 内の **プラグイン名・パスは ryoppippi のまま** にしている（本ドキュメント作成時点で ai-keymap.lua, claude-code/settings.json, leetcode.lua は ryoppippi 参照に揃えてあります）

---

## 参照ドキュメント

| ドキュメント | 内容 |
|--------------|------|
| `docs/ryoppippi-string-audit.md` | 「ryoppippi」文字列の要変更・変更不要・任意の分類 |
| `docs/mac-initial-setup-ryoppippi-dotfiles.md` | Mac 初期セットアップと dotfiles 導入手順 |
