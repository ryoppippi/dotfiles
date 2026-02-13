# ryoppippi さん dotfiles のフォーク手順（asktt1770 用）

GitHub アカウント: **https://github.com/asktt1770**

現状やること: **GitHub でフォーク** → **PC名・ユーザー名（ryoppippi）を asktt1770 用に書き換え** → **upstream を登録して本家の更新を取り込めるようにする**。  
Mac 初期化後は、このフォークをクローンして `nix run .#switch` すればよい。

---

## 手順 1: GitHub でフォークする

1. ブラウザで **https://github.com/ryoppippi/dotfiles** を開く。
2. 右上の **Fork** をクリック。
3. 「Create a fork」で、Owner が **asktt1770**、Repository name が **dotfiles** のままであることを確認して **Create fork** をクリック。
4. フォークができると **https://github.com/asktt1770/dotfiles** が作成される。

---

## 手順 2: フォークを手元にクローンする（今の Mac で）

書き換えを行うため、いま使っている Mac でフォークをクローンする。

```bash
cd ~
mkdir -p ghq/github.com/asktt1770
git clone https://github.com/asktt1770/dotfiles.git ghq/github.com/asktt1770/dotfiles
cd ghq/github.com/asktt1770/dotfiles
```

---

## 手順 3: 本家を upstream として登録する（本家の更新を取り込むため）

```bash
git remote add upstream https://github.com/ryoppippi/dotfiles.git
```

確認:

```bash
git remote -v
# origin    https://github.com/asktt1770/dotfiles.git (fetch)
# origin    https://github.com/asktt1770/dotfiles.git (push)
# upstream  https://github.com/ryoppippi/dotfiles.git (fetch)
# upstream  https://github.com/ryoppippi/dotfiles.git (push)
```

---

## 手順 4: asktt1770 用に書き換える

「PC名・ユーザー名」に当たる **ryoppippi** および **ユーザー名・ホーム・dotfiles のパス** を、次のとおり **asktt1770** 用に変更する。

### 4.1 `flake.nix`

| 箇所     | 変更前                                                                   | 変更後                                                                   |
| ------ | --------------------------------------------------------------------- | --------------------------------------------------------------------- |
| 125行付近 | `username = "ryoppippi";`                                             | `username = "asktt1770";`                                             |
| 126行付近 | `darwinHomedir = "/Users/${username}";`                               | そのまま（username を変えれば自動で `/Users/asktt1770` になる）                        |
| 127行付近 | `linuxHomedir = "/home/${username}";`                                 | そのまま                                                                  |
| 204行付近 | `dotfilesDir = "${linuxHomedir}/ghq/github.com/ryoppippi/dotfiles";`  | `dotfilesDir = "${linuxHomedir}/ghq/github.com/asktt1770/dotfiles";`  |
| 323行付近 | `"''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"`   | `"''${DOTFILES_DIR:=${homedir}/ghq/github.com/asktt1770/dotfiles}"`   |
| 483行付近 | `dotfilesDir = "${darwinHomedir}/ghq/github.com/ryoppippi/dotfiles";` | `dotfilesDir = "${darwinHomedir}/ghq/github.com/asktt1770/dotfiles";` |

※ **description**（2行付近の `"ryoppippi's home-manager configuration"`）や **cachix** の URL は、そのままでよい（cachix は ryoppippi さんのキャッシュを利用するため変更不要）。  
※ **inputs** 内の `github:ryoppippi/claude-code-overlay` などは、外部パッケージの参照なので変更しない。

### 4.2 `nix/modules/lib/helpers/user.nix`

| 変更前                     | 変更後                            |
| ----------------------- | ------------------------------ |
| `githubId = "1560508";` | 自分の GitHub **ユーザー ID（数字）** に変更 |

**GitHub ユーザー ID の調べ方（一例）**  
ブラウザで `https://api.github.com/users/asktt1770` を開くと JSON の `"id": 12345678` のように数字が表示される。その数字を `"12345678"` の形で入れる。

### 4.3 dotfilesDir のデフォルト値を含むモジュール（すべて `ryoppippi` → `asktt1770`）

flake から `dotfilesDir` を渡しているため、**flake.nix を直していれば多くの場合は上書きされる**が、デフォルト値も揃えておくと安全。次のファイルで `github.com/ryoppippi/dotfiles` を **`github.com/asktt1770/dotfiles`** に置き換える。

| ファイル | 置き換え |
|----------|----------|
| `nix/modules/darwin/default.nix` | `ryoppippi/dotfiles` → `asktt1770/dotfiles` |
| `nix/modules/darwin/dotfiles.nix` | 同上 |
| `nix/modules/home/default.nix` | 同上 |
| `nix/modules/home/dotfiles.nix` | 同上 |
| `nix/modules/home/programs/claude-code/default.nix` | 同上 |
| `nix/modules/home/programs/codex.nix` | 同上 |
| `nix/modules/linux/default.nix` | 同上 |
| `nix/modules/linux/dotfiles.nix` | 同上 |
| `nix/modules/linux/services/kanata.nix` | 同上 |

**変更しないもの**

- `nix/modules/home/programs/fish/default.nix` の `owner = "ryoppippi"`  
  → これは **bdf.fish** プラグインの GitHub リポジトリのオーナー名なので、そのままにする。
- `nix/overlays/claude-code.nix` の ryoppippi の URL  
  → 外部 overlay の参照のため変更しない。

---

## 手順 5: 変更をコミットしてフォークに push する

```bash
git add -A
git status   # 変更ファイルを確認
git commit -m "Customize for asktt1770: username, homedir, dotfilesDir, githubId"
git push origin main
```

※ デフォルトブランチが `master` の場合は `git push origin master` にする。

---

## このあと（Mac 初期化後）

1. Mac を初期化し、ユーザー名 **asktt1770** で作成。
2. Nix をインストールしたあと、**自分のフォーク** をクローンする:
   ```bash
   mkdir -p /Users/asktt1770/ghq/github.com/asktt1770
   git clone https://github.com/asktt1770/dotfiles.git /Users/asktt1770/ghq/github.com/asktt1770/dotfiles
   cd /Users/asktt1770/ghq/github.com/asktt1770/dotfiles
   ```
3. 手順 3 と同様に upstream を追加（本家の更新を取り込むため）:
   ```bash
   git remote add upstream https://github.com/ryoppippi/dotfiles.git
   ```
4. `docs/mac-initial-setup-ryoppippi-dotfiles.md` の「5. nix-darwin で設定を適用する」以降に従い、`sudo nix run nix-darwin -- switch --flake .#asktt1770` を実行。

---

## ryoppippi さんが更新したときに自分のフォークを更新する

```bash
cd /Users/asktt1770/ghq/github.com/asktt1770/dotfiles
git fetch upstream
git merge upstream/main
```

衝突したら、**username / darwinHomedir / dotfilesDir / githubId** は **asktt1770 用の値** を残して解決し、その後:

```bash
git push origin main
```

詳細は `docs/migration-to-ryoppippi-checklist.md` の「フォークを ryoppippi さんの更新と同期する方法」を参照。
