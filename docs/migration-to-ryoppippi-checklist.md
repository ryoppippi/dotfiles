# ryoppippi さん dotfiles 移行チェックリスト（Mac 初期化後）

## 結論: Apple ID やアカウント設定は適用されない

- **Apple ID・iCloud**: Nix の設定には一切含まれていません。初期セットアップで自分でサインインした Apple ID がそのまま使われます。
- **Mac のログインユーザー**: 自分で作成したユーザー（例: keisukeasaka）のままです。Nix は「そのユーザー向けに設定を適用する」だけです。
- **適用されるのは**: Dock・Finder・キーボード・トラックパッドなどの**見た目・挙動**、**シェル（fish）**、**入れるパッケージ**、**dotfiles のシンボリックリンク**だけです。

---

## 必ず「自分の情報」に書き換える箇所

ryoppippi さんのリポジトリを **fork して自分用に使う**前提で、以下を自分のものに変更しないと、ホームディレクトリや Git のメールが別人向けになります。

| 箇所                | ファイル                                                           | 現在の値例                                                                       | やること                                                              |
| ----------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| ユーザー名・ホーム         | `flake.nix`                                                    | `username = "ryoppippi"`<br>`darwinHomedir = "/Users/ryoppippi"`            | 自分の Mac のユーザー名とホームに変更（例: `keisukeasaka`, `/Users/keisukeasaka`）   |
| dotfiles のパス      | `flake.nix` 内の `dotfilesDir` 参照<br>各モジュールの `dotfilesDir` デフォルト | `ghq/github.com/ryoppippi/dotfiles`                                         | 自分の dotfiles リポジトリのパスに（例: `ghq/github.com/keisukeasaka/dotfiles`） |
| Git 用 ID・メール      | `nix/modules/lib/helpers/user.nix`                             | `githubId = "1560508"`<br>メールは `githubId+username@users.noreply.github.com` | 自分の GitHub ユーザー ID に変更。Git の `user.name` は別モジュールで設定されている場合は自分の名前に |
| darwin の hostname | `flake.nix`                                                    | `hostname = username`（なので ryoppippi のまま）                                    | 自分の username に変えていれば、hostname もその名前になる                            |

上記を直せば、**自分のアカウント・自分の Mac ユーザー**のまま、ryoppippi さんの「設定の内容」だけが適用されます。アプリや Apple ID が上書きされることはありません。

---

## 変更不要だが「他人の設定」であるもの

- **fish のプラグイン**: `owner = "ryoppippi"` の GitHub リポジトリ（bdf.fish など）を参照しています。これはプラグインの取得元なので、そのままで問題ありません。
- **Cachix**: `ryoppippi.cachix.org` はビルドキャッシュ用。使うとビルドが速くなります。自分の Cachix に変えたい場合だけ変更すればよいです。

---

## Mac を初期化してからやる場合の流れ（イメージ）

1. Mac を初期化（必要ならバックアップを取ってから）。
2. セットアップアシスタントで **自分の Apple ID** でサインインし、**自分のユーザー名**（例: keisukeasaka）でユーザーを作成。
3. 自分の dotfiles 用リポジトリを用意（ryoppippi のリポジトリを fork、または clone して自分用に書き換え）。
4. 上記チェックリストに従い、`username` / `darwinHomedir` / `dotfilesDir` / `githubId` を自分の情報に変更。
5. Determinate Nix をインストール後、`nix run .#switch` で適用。

この流れなら、**アプリやアカウント設定が ryoppippi さんごと適用されてしまうことはありません**。自分の PC・自分のアカウントに、設定スタイルだけが乗る形になります。

---

## フォークを ryoppippi さんの更新と同期する方法

**結論**: 自分で更新する必要はありません。Git の **upstream（上流）** として ryoppippi さんのリポジトリを登録し、**fetch → merge** すれば、更新分を自分のフォークに取り込めます。衝突した箇所だけ「自分の情報」を残すように解決すればよいです。

### 1. 初回だけ: upstream を登録する

自分のフォークを clone したディレクトリで:

```bash
git remote add upstream https://github.com/ryoppippi/dotfiles.git
```

- `origin` = 自分の GitHub のフォーク（push 先）
- `upstream` = ryoppippi さんの本家（取り込み元）

確認:

```bash
git remote -v
# origin    https://github.com/keisukeasaka/dotfiles.git (fetch)
# origin    https://github.com/keisukeasaka/dotfiles.git (push)
# upstream  https://github.com/ryoppippi/dotfiles.git (fetch)
# upstream  https://github.com/ryoppippi/dotfiles.git (push)
```

### 2. 更新を取り込みたいときの手順（毎回）

本家の最新を取って、いまのブランチにマージします。

```bash
# 本家の最新を取得（ローカルにはまだマージしない）
git fetch upstream

# いまのブランチ（例: main）に本家の main を取り込む
git merge upstream/main
```

- **衝突がなければ**: そのまま完了。`git push origin main` で自分のフォークにも反映できます。
- **衝突した場合**: 下記「衝突の扱い」へ。

### 3. 衝突が起きたとき（自分の情報を残す）

自分用に書き換えている箇所は、upstream も同じファイルを変更していると **コンフリクト** になります。  
そのときは **「自分の値」を残す** ように解決すれば、ryoppippi さんの他の変更だけ取り込めます。

| ファイル | 衝突しやすい箇所 | 解決のコツ |
|----------|------------------|------------|
| `flake.nix` | `username`, `darwinHomedir`, `linuxHomedir` | 自分のユーザー名・ホームのままにする |
| 各モジュールの `dotfilesDir` | `ghq/github.com/ryoppippi/dotfiles` | 自分のリポジトリパス（例: `keisukeasaka/dotfiles`）のままにする |
| `nix/modules/lib/helpers/user.nix` | `githubId = "1560508"` | 自分の GitHub ID のままにする |

手順の流れ:

1. `git merge upstream/main` で「Conflict」と出る
2. `git status` でどのファイルが衝突しているか確認
3. 該当ファイルを開き、`<<<<<<<`, `=======`, `>>>>>>>` で囲まれた部分を編集して、**自分の値** だけ残す（または必要なら upstream の変更を取りつつ、username / homedir / githubId / dotfilesDir だけ自分の値に戻す）
4. 保存後、`git add <ファイル>` → `git commit` でマージ完了
5. `git push origin main` でフォークに反映

### 4. 運用のコツ

- **「本家の更新を取り込みたい」ときだけ** `git fetch upstream` → `git merge upstream/main` を実行すればよいです。日常の変更は `origin`（自分のフォーク）に対して commit / push で問題ありません。
- 自分用の変更は **できるだけ少ないファイル・少ない行** にまとめておくと、毎回のマージで衝突が少なく、解決も楽になります。
- 本家のデフォルトブランチが `main` 以外（例: `master`）の場合は、`upstream/main` の代わりに `upstream/master` のようにブランチ名を合わせてください。
