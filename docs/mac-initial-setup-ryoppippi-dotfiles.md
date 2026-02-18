# Mac 初期セットアップ ＋ ryoppippi さん dotfiles 導入手順書

**対象**: MacBook M3 Pro（Apple Silicon / aarch64-darwin）  
**ユーザー名**: `asktt1770`（ホーム: `/Users/asktt1770`）

---

## このドキュメントの位置づけ

- **PC 初期化前**: バックアップとアプリ一覧の洗い出しは `docs/pc-initialization-backup-checklist.md` に従う。
- **PC 初期化後**: 本ドキュメントの手順で、Nix と dotfiles に則って **環境の構築・各種アプリのインストール・アプリ／システムの設定** を一括で行う。
- 本手順の「5. nix-darwin で設定を適用する」により、**アプリのインストール**（Homebrew Casks、Nix パッケージ、Mac App Store）と **macOS／アプリの設定**（Dock、Finder、キーボード、シェル等）が dotfiles の定義どおりに適用される。詳細な一覧は `docs/ryoppippi-apps-list.md` を参照。

---

## 前提

- Mac を初期化し、セットアップアシスタントで **ユーザー名 `asktt1770`** でログインできる状態になっていること。初期化の実行手順やセットアップアシスタントでの操作は、必要に応じて「0. PC 初期化（必要な場合）」を参照。
- GitHub で ryoppippi さんの [dotfiles](https://github.com/ryoppippi/dotfiles) を **フォーク** し、自分のリポジトリ（**https://github.com/asktt1770/dotfiles**）を用意していること。フォークと asktt1770 用の書き換えは `docs/fork-and-customize-asktt1770.md` を参照。

---

## 0. PC 初期化（必要な場合）

Mac をクリーンな状態からセットアップする場合のみ行う。

1. **初期化前**: `docs/pc-initialization-backup-checklist.md` に従い、バックアップとアプリ一覧の確認を行う。
2. **初期化の実行**: システム設定 → 一般 → 転送またはリセット → 「すべてのコンテンツと設定を消去」など、利用する方法で Mac を初期化する。
3. **セットアップアシスタント**: 言語・地域・Apple ID・ユーザー作成などに従い、**ユーザー名を `asktt1770`**（または自分のユーザー名）にしてログインできる状態にする。Apple ID や iCloud は Nix では管理されないため、ここで自分でサインインする。
4. 続いて本ドキュメントの「1. Xcode Command Line Tools」から進める。

---

## 1. Xcode Command Line Tools を入れる（未導入の場合）

ターミナルで:

```bash
xcode-select --install
```

表示に従ってインストールし、完了まで待つ。

---

## 2. Determinate Nix をインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

指示に従い、完了したら **ターミナルを一度閉じて開き直す**（または `exec $SHELL`）。

---

## 3. dotfiles リポジトリを clone する

フォークした **自分の** dotfiles リポジトリ（asktt1770/dotfiles）を、次のパスに clone する。

```bash
mkdir -p /Users/asktt1770/ghq/github.com/asktt1770
git clone https://github.com/asktt1770/dotfiles.git /Users/asktt1770/ghq/github.com/asktt1770/dotfiles
cd /Users/asktt1770/ghq/github.com/asktt1770/dotfiles
```

---

## 4. 自分用に書き換える

以下のファイルを編集し、**username / homedir / dotfilesDir / GitHub ID** を自分のものにする。

### 4.1 `flake.nix`

**変更箇所:**

| 行付近 | 変更前の例 | 変更後 |
|--------|------------|--------|
| `username` | `username = "ryoppippi";` | `username = "asktt1770";` |
| `darwinHomedir` | `darwinHomedir = "/Users/ryoppippi";` | `darwinHomedir = "/Users/asktt1770";` |
| `linuxHomedir` | `linuxHomedir = "/home/ryoppippi";` | `linuxHomedir = "/home/asktt1770";` |
| darwin の `dotfilesDir` | `dotfilesDir = "${darwinHomedir}/ghq/github.com/ryoppippi/dotfiles";` | `dotfilesDir = "${darwinHomedir}/ghq/github.com/asktt1770/dotfiles";` |

**Linux 用の dotfilesDir**（flake.nix 内の `mkLinuxHomeConfig` 付近）も  
`ghq/github.com/asktt1770/dotfiles` に変更する。

**nvim-restore 用の DOTFILES_DIR** も `ghq/github.com/asktt1770/dotfiles` に変更する。

※ フォーク時に `docs/fork-and-customize-asktt1770.md` の手順で既に書き換え済みなら、この 4.1 は不要。

### 4.2 `nix/modules/lib/helpers/user.nix`

| 変更前の例 | 変更後 |
|------------|--------|
| `githubId = "1560508";` | 自分の GitHub のユーザー ID（数字）に変更。取得: GitHub → プロフィール → 設定 → 左メニュー「開発者向け」など、または API で確認。 |

※ メールは `githubId+username@users.noreply.github.com` で生成されるため、`username` を `asktt1770` にしていれば、このファイルは `githubId` だけ直せばよい。

### 4.3 その他 `dotfilesDir` のデフォルト値（任意）

モジュール内のデフォルトで `ryoppippi/dotfiles` と書いてある場合は、flake から `dotfilesDir` を渡しているため、**flake.nix を直していれば上書きされる**。  
flake から渡していないモジュールだけ、必要に応じて次のように変更する。

- `nix/modules/home/dotfiles.nix`
- `nix/modules/home/programs/codex.nix`
- `nix/modules/home/programs/claude-code/default.nix`
- `nix/modules/darwin/dotfiles.nix`
- `nix/modules/linux/default.nix` / `dotfiles.nix` など

いずれも `ghq/github.com/ryoppippi/dotfiles` → `ghq/github.com/asktt1770/dotfiles` に揃える。フォーク時に `docs/fork-and-customize-asktt1770.md` で書き換え済みなら不要。

---

## 5. nix-darwin で設定を適用する

**初回のみ**、nix-darwin がまだシステムにないため、次を実行する:

```bash
cd /Users/asktt1770/ghq/github.com/asktt1770/dotfiles
sudo nix run nix-darwin -- switch --flake .#asktt1770
```

- ビルドに時間がかかることがある。
- 途中でパスワードや確認を求められたら従う。
- ログインシェルが **fish** に変更される。

**2回目以降**は、設定変更後に次のどちらかでよい:

```bash
nix run .#switch
```

### 5.1 適用で入るもの・設定されるもの（ryoppippi さん dotfiles に則った環境）

`nix run .#switch` により、以下が **自動でインストール・設定** されます。

| 種別 | 内容 |
|------|------|
| **アプリのインストール** | Homebrew Casks（1Password、Arc、Cursor、Karabiner-Elements、Raycast 等）、brew-nix の Cask、Nix パッケージ（Ghostty、Obsidian、Chrome 等）、Mac App Store アプリ（mas）。一覧は `docs/ryoppippi-apps-list.md` を参照。 |
| **macOS のシステム設定** | Dock（自動非表示・サイズ等）、Finder（拡張子表示・隠しファイル・リストビュー等）、キーボード・トラックパッド、スクリーンショット保存先、ダークモードなど（`nix/modules/darwin/system.nix` の `defaults`）。 |
| **シェル・開発環境** | ログインシェルが fish に変更され、fish 設定・Neovim・Git・CLI ツール（ghq、lazygit、fzf 等）が Home Manager でインストール・設定される。 |

※ **Apple ID・iCloud・各アプリへのログイン** は Nix に含まれないため、適用後に手動でサインインする。詳しくは「8. 手動で行う設定」を参照。

---

## 6. シェルを fish に切り替える

```bash
exec fish
```

これで ryoppippi さんベースの dotfiles が有効な状態になる。

---

## 7. 今後の更新（本家の変更を取り込む）

本家（ryoppippi さん）の更新をフォークに取り込む手順は、  
`docs/migration-to-ryoppippi-checklist.md` の「フォークを ryoppippi さんの更新と同期する方法」を参照する。

- `git remote add upstream https://github.com/ryoppippi/dotfiles.git`（初回のみ）
- `git fetch upstream && git merge upstream/main`
- 衝突したら、username / homedir / dotfilesDir / githubId は **自分の値** を残して解決する。

---

## 8. 手動で行う設定（Nix で管理されないもの）

dotfiles の適用後も、次は **自分で行う** 必要があります。

| 項目 | 内容 |
|------|------|
| **Apple ID・iCloud** | セットアップアシスタントまたは「システム設定」でサインイン。Nix の設定には含まれない。 |
| **アプリへのログイン** | 1Password、ブラウザ、Slack、GitHub（Web）など、各アプリでアカウントにサインインする。 |
| **SSH 鍵・Git 認証** | `~/.ssh/` の秘密鍵は Nix で配布しない。初期化前にバックアップした鍵を戻すか、新規作成して GitHub 等に登録する。 |
| **その他** | パスワードマネージャのマスターパスワード、2FA の再設定、クラウドストレージの同期設定など。 |

詳細は `docs/migration-to-ryoppippi-checklist.md` の「結論: Apple ID やアカウント設定は適用されない」および `docs/pc-initialization-backup-checklist.md` のフェーズ 3〜4 を参照。

---

## トラブル時

- **「command not found: nix」**  
  Nix の PATH が通っていない。ターミナルを開き直すか、`~/.nix-profile/etc/profile.d/nix.sh` を source する。

- **ビルドエラー**  
  `nix run .#build` でビルドだけ試し、エラーメッセージを確認する。  
  flake の `username` / `darwinHomedir` / `dotfilesDir` の typo や、存在しないパスになっていないか確認する。

- **ログインシェルを fish にしたくない**  
  `nix/modules/darwin/system.nix` の `activationScripts.postActivation` 内の `chsh -s ... fish` をコメントアウトまたは削除する。その場合、手動で `exec fish` しないと fish は使われない。

---

## チェックリスト（実施時に使う）

**PC 初期化を行う場合**

- [ ] 初期化前に `docs/pc-initialization-backup-checklist.md` でバックアップ・アプリ一覧を確認した
- [ ] Mac を初期化し、セットアップアシスタントでユーザー名 `asktt1770` でログインできる状態にした

**dotfiles の導入**

- [ ] Xcode Command Line Tools インストール
- [ ] Determinate Nix インストール
- [ ] 自分の dotfiles フォークを `~/ghq/github.com/asktt1770/dotfiles` に clone
- [ ] `flake.nix`: username / darwinHomedir / linuxHomedir / dotfilesDir を自分用に変更
- [ ] `nix/modules/lib/helpers/user.nix`: githubId を自分の ID に変更
- [ ] `sudo nix run nix-darwin -- switch --flake .#asktt1770` 実行
- [ ] `exec fish` で fish に切り替え

**適用後の確認・手動設定**

- [ ] アプリがインストールされていることを確認（必要なら `docs/ryoppippi-apps-list.md` と照合）
- [ ] macOS の Dock・Finder・キーボード等の設定が意図どおりか確認
- [ ] Apple ID・iCloud および各アプリへのログインを手動で行った
- [ ] SSH 鍵・Git 認証を復元または再設定した

---

## 参照ドキュメント

| ドキュメント | 内容 |
|--------------|------|
| `docs/pc-initialization-backup-checklist.md` | 初期化前のバックアップ・アプリ一覧の洗い出し |
| `docs/fork-and-customize-asktt1770.md` | フォークと username / dotfilesDir / githubId の書き換え |
| `docs/ryoppippi-apps-list.md` | dotfiles で管理しているアプリ・パッケージ一覧 |
| `docs/migration-to-ryoppippi-checklist.md` | 移行時の注意点とフォークの同期方法 |
