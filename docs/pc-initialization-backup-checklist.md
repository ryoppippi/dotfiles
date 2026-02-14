# PC 初期化前 確認・バックアップ チェックリスト

PC を初期化する前に、**アプリケーションごとの設定・アカウント情報の確認とバックアップ**を一つずつ進めるためのチェックリストです。  
現状は **Homebrew でインストールしているアプリが中心**で、**一部は手動インストール**という前提で項目を並べています。

---

## 使い方

- 各項目を **上から順に** 進め、完了したら `[ ]` を `[x]` に変更してください。
- 「一覧を書き出す」「表を埋める」など **自分で中身を書く欄** は、このファイルを編集して追記してください。
- 初期化**後**の手順は `docs/mac-initial-setup-ryoppippi-dotfiles.md` を参照してください。

---

## フェーズ 1: 全体の準備

- [x] **バックアップの保存先を決める**  
  （外付けディスク、クラウド、別 PC など。容量の目安もメモしておく）
- [ ] **初期化後のセットアップ手順を確認する**  
  - [ ] `docs/mac-initial-setup-ryoppippi-dotfiles.md` を一読した
  - [x] フォーク済み dotfiles の書き換えは `docs/fork-and-customize-asktt1770.md` のとおり済んでいる
- [ ] **重要なパスをメモする**  
  - ホーム: `/Users/<自分のユーザー名>`
  - 設定がよくある場所: `~/Library/Application Support/`, `~/.config/`, `~/.local/`
  ```bash
  
  ```

---

## フェーズ 2: アプリケーション一覧の洗い出し

初期化後に「何を入れ直すか」を把握するため、**今入っているアプリを一覧にします**。

### 2.1 Homebrew でインストールしているアプリ

次のコマンドで一覧を出し、必要ならこの下に貼るか、別ファイルに保存してください。

```bash
brew list --formula    # フォーミュラ（CLI 等）
aom             dav1d           giflib          jpeg-turbo      libgit2         libsoxr         libvpx          m4              openssl@3       readline        theora          yt-dlp
aribb24         fd              glib            jpeg-xl         libidn2         libssh          libx11          mbedtls         opus            rubberband      tree            zeromq
autoconf        ffmpeg          gmp             lame            libmicrohttpd   libssh2         libxau          mpdecimal       p11-kit         sdl2            unbound         zimg
bat             flac            gnutls          leptonica       libnghttp2      libtasn1        libxcb          mpg123          pango           snappy          webp            zsh
brotli          fontconfig      graphite2       libarchive      libogg          libtiff         libxdmcp        ncurses         pcre2           speex           wget            zstd
ca-certificates freetype        harfbuzz        libass          libpng          libunibreak     libxext         nettle          pixman          sqlite          x264
cairo           frei0r          highway         libb2           librist         libunistring    libxrender      oniguruma       pkgconf         srt             x265
certifi         fribidi         htop            libbluray       libsamplerate   libvidstab      little-cms2     opencore-amr    pyenv           starship        xorgproto
cjson           fzf             icu4c@77        libdeflate      libsndfile      libvmaf         lz4             openexr         python@3.13     svt-av1         xvid
coreutils       gettext         imath           libevent        libsodium       libvorbis       lzo             openjpeg        rav1e           tesseract       xz

brew list --cask       # キャスク（GUI アプリ）
alt-tab                 biscuit                 clipy                   forklift                moonlight               slack                   wezterm@nightly
antigravity             brave-browser           cursor                  google-drive            obsidian                visual-studio-code
appcleaner              claude                  docker-desktop          karabiner-elements      onyx                    vrew
arc                     claude-code             figma                   meld                    raycast                 warp
```

**メモ欄（必要ならここに書き足す）:**

- フォーミュラで特にバックアップしたいもの:
- キャスクで特に設定・アカウントがあるもの:

### 2.2 手動でインストールしているアプリ

インストーラ（.dmg / .pkg）や App Store 以外から入れたアプリをリストアップします。

| # | アプリ名 | インストール元・メモ | 確認済 |
|---|----------|----------------------|--------|
| 1 | （例）〇〇 | 公式サイト dmg | [ ] |
| 2 | | | [ ] |
| 3 | | | [ ] |

（行を増やして追記してください）

### 2.3 Mac App Store（mas）で入れたアプリ（任意）

```bash
mas list   # 入っていれば一覧表示
```

- [x] 一覧を保存した（スクショや `mas list > mas-list.txt` など）
- [x] 再インストールに必要なアプリ名・ID をメモした

---

## フェーズ 3: アプリごとの確認・バックアップ

**アプリ単位**で、次を確認・実行します。  
表の「アプリ名」は 2.1 / 2.2 で洗い出したものから選び、1行ずつ処理してください。

### 3.1 確認する内容の説明

| 項目 | 内容 |
|------|------|
| **設定** | 設定ファイル・フォルダの場所。バックアップするならパスを書く。 |
| **アカウント** | ログインしているか、再ログインに必要な情報（2FA など）をメモする。 |
| **バックアップ** | 設定のコピー先、エクスポート手順、クラウド同期の有無。 |
| **再入手** | 初期化後、`brew install` / 手動 dmg / App Store / dotfiles（Nix）のどれで入れるか。 |

### 3.2 設定がよくある場所（macOS）

- `~/Library/Application Support/<アプリ名>/`
- `~/Library/Preferences/`（.plist）
- `~/.config/<アプリ名>/`
- `~/.<アプリ名>/`（例: `~/.ssh/`, `~/.zshrc`）
- アプリ内の「設定のエクスポート」「クラウドに保存」機能

### 3.3 アプリ別チェックリスト（テンプレート）

以下をコピーしてアプリごとに埋め、完了したら `[ ]` を `[x]` にしてください。  
アプリが多ければ、**重要度の高いものから**並べるとよいです。

---

#### アプリ 1: ________________（アプリ名）

- [ ] **設定の場所を確認した**  
  パス: 
- [ ] **アカウント・ログイン情報を確認した**  
  メモ（2FA など）:
- [ ] **設定をバックアップした**  
  方法・保存先:
- [ ] **再入手方法をメモした**  
  （例: `brew install --cask xxx` / 手動 dmg / App Store / dotfiles で入る）

---

#### アプリ 2: ________________（アプリ名）

- [ ] **設定の場所を確認した**  
  パス:
- [ ] **アカウント・ログイン情報を確認した**  
  メモ:
- [ ] **設定をバックアップした**  
  方法・保存先:
- [ ] **再入手方法をメモした**

---

#### アプリ 3: ________________（アプリ名）

- [ ] **設定の場所を確認した**  
  パス:
- [ ] **アカウント・ログイン情報を確認した**  
  メモ:
- [ ] **設定をバックアップした**  
  方法・保存先:
- [ ] **再入手方法をメモした**

---

（必要なだけ「アプリ N」をコピーして追加してください）

### 3.4 よくあるアプリの例（参考）

| アプリ種別 | 設定の例 | アカウント・バックアップの例 |
|------------|----------|------------------------------|
| ブラウザ | プロフィールフォルダ、拡張機能 | ログイン状態、ブックマーク・パスワードのエクスポート／同期 |
| エディタ（VS Code / Cursor 等） | `~/.config/Code/` 等、settings.json | 設定のエクスポート、拡張機能一覧 |
| ターミナル・シェル | `~/.config/fish/`, `~/.zshrc` 等 | dotfiles に含めていればリポジトリがバックアップ |
| Git・SSH | `~/.ssh/`, `~/.gitconfig` | 秘密鍵のバックアップ、Git 認証情報 |
| パスワードマネージャ | アプリ内の「バックアップ」「エクスポート」 | マスターパスワード・2FA の再設定手順 |
| メール・カレンダー | アプリのアカウント設定 | アカウント追加手順、IMAP/CalDAV の情報 |

---

## フェーズ 4: データ・アカウントの確認

アプリ以外の **データ** と **アカウント** を確認します。

- [ ] **書類・デスクトップ・ダウンロード**  
  - [ ] 必要なファイルをバックアップ先にコピーした
  - [ ] iCloud 等に同期している場合は、同期完了を確認した
- [ ] **ブラウザ**  
  - [ ] ブックマークのエクスポートまたは同期確認
  - [ ] 重要なログイン情報（再ログイン手順）をメモした
- [ ] **SSH・Git**  
  - [ ] `~/.ssh/` の秘密鍵を安全な場所にバックアップした
  - [ ] Git の credential / 認証方法（HTTPS トークン or SSH）を把握している
- [ ] **メール・カレンダー・連絡先**  
  - [ ] クラウド同期の有無を確認した
  - [ ] 再設定に必要な情報（IMAP/CalDAV、アカウント名）をメモした
- [ ] **その他**  
  - [ ] ライセンス・サブスクの再アクティベート手順を確認した
  - [ ] 2FA のリカバリコード等を安全な場所に保管した

---

## フェーズ 5: 最終確認

- [ ] **バックアップの検証**  
  - [ ] バックアップ先から一部ファイルを開いて、中身が読めることを確認した
- [ ] **初期化後の手順を再確認**  
  - [ ] `docs/mac-initial-setup-ryoppippi-dotfiles.md` の流れを把握した
  - [ ] dotfiles を clone するパス（`~/ghq/github.com/asktt1770/dotfiles`）と、Nix 適用コマンドをメモした
- [ ] **初期化の実行**  
  - [ ] 上記がすべて完了してから、Mac の初期化（消去）を実行する

---

## 参照ドキュメント

| ドキュメント | 内容 |
|--------------|------|
| `docs/fork-and-customize-asktt1770.md` | フォークと username / dotfilesDir / githubId の書き換え |
| `docs/mac-initial-setup-ryoppippi-dotfiles.md` | 初期化後の Mac に Nix と dotfiles を入れる手順 |
| `docs/migration-to-ryoppippi-checklist.md` | 移行時の注意点とフォークの同期方法 |
| `docs/ryoppippi-apps-list.md` | 本家 dotfiles で管理しているアプリ一覧（参考） |

---

*このチェックリストは、PC 初期化前に自分用に編集して利用してください。*
