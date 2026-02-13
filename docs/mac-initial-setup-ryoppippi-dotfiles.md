# Mac 初期セットアップ ＋ ryoppippi さん dotfiles 導入手順書

**対象**: MacBook M3 Pro（Apple Silicon / aarch64-darwin）  
**ユーザー名**: `asktt1770`（ホーム: `/Users/asktt1770`）

---

## 前提

- Mac を初期化し、セットアップアシスタントで **ユーザー名 `asktt1770`** でログインできる状態になっていること。
- GitHub で ryoppippi さんの [dotfiles](https://github.com/ryoppippi/dotfiles) を **フォーク** し、自分のリポジトリ（**https://github.com/asktt1770/dotfiles**）を用意していること。フォークと asktt1770 用の書き換えは `docs/fork-and-customize-asktt1770.md` を参照。

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

- [ ] Xcode Command Line Tools インストール
- [ ] Determinate Nix インストール
- [ ] 自分の dotfiles フォークを `~/ghq/github.com/asktt1770/dotfiles` に clone
- [ ] `flake.nix`: username / darwinHomedir / linuxHomedir / dotfilesDir を自分用に変更
- [ ] `nix/modules/lib/helpers/user.nix`: githubId を自分の ID に変更
- [ ] `sudo nix run nix-darwin -- switch --flake .#asktt1770` 実行
- [ ] `exec fish` で fish に切り替え
