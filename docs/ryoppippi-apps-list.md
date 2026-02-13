# ryoppippi さんの dotfiles で管理しているアプリケーション一覧

移行の参考用。実際の定義は `nix/modules/darwin/system.nix` / `nix/modules/darwin/packages.nix` / `nix/modules/home/packages.nix` 等を参照。

---

## 1. Homebrew Casks（nix-darwin の homebrew.casks）

| アプリ                   | 用途イメージ                    |
| --------------------- | ------------------------- |
| arto (arto-app/tap)   | -                         |
| 1password             | パスワード管理                   |
| alfred                | ランチャー                     |
| aqua-voice            | 音声                        |
| arc                   | ブラウザ                      |
| blackhole-16ch        | オーディオ                     |
| blu-ray-player-pro    | メディア                      |
| claude                | Claude Desktop            |
| cloudflare-warp       | VPN                       |
| google-drive          | クラウドストレージ                 |
| imageoptim            | 画像最適化                     |
| karabiner-elements    | キーボードカスタマイズ               |
| ollama-app            | ローカル LLM                  |
| openvpn-connect       | VPN                       |
| orbstack              | Docker 代替                 |
| sdformatter           | SD カード                    |
| secretive             | SSH 鍵管理                   |
| steam                 | ゲーム                       |
| thebrowsercompany-dia | ブラウザ関連                    |
| **mas**               | App Store アプリ用 CLI（brews） |

---

## 2. brew-nix（Nix でビルドした Cask 相当）

`nix/modules/darwin/packages.nix` の `pkgs.brewCasks`:

| アプリ                | 用途イメージ        |
| ------------------ | ------------- |
| alt-tab            | アプリ切り替え       |
| appcleaner         | アンインストール      |
| beekeeper-studio   | DB クライアント     |
| bluesnooze         | Bluetooth     |
| chatgpt            | ChatGPT アプリ   |
| cursor             | Cursor エディタ   |
| deskpad            | -             |
| figma              | デザイン          |
| glance-chamburr    | -             |
| homerow            | キーボード         |
| istherenet         | ネット確認         |
| kap                | 画面録画          |
| maestral           | Dropbox 代替    |
| marta              | ファイラ          |
| obs                | 配信            |
| postman            | API 開発        |
| processing         | クリエイティブコーディング |
| qlvideo            | Quick Look 動画 |
| quitter            | -             |
| raycast            | ランチャー         |
| shottr             | スクリーンショット     |
| signal             | メッセンジャー       |
| stats              | システムモニタ       |
| suspicious-package | pkg インストーラ    |
| vlc                | メディア          |
| yaak               | -             |
| zed                | エディタ          |
| zoom               | ビデオ会議         |

---

## 3. macOS 用 Nix パッケージ（darwin/packages.nix）

| パッケージ | 用途 |
|------------|------|
| ghostty-bin | ターミナル |
| chafa | ターミナル画像 |
| blueutil | Bluetooth CLI |
| bluetooth-connector | Bluetooth |
| switchaudio-osx | オーディオ切替 |
| terminal-notifier | 通知 |
| mas | App Store CLI |
| audio-priority-bar | オーディオ |
| google-chrome | ブラウザ |
| cyberduck | FTP/SFTP |
| keycastr | キー表示 |
| monitorcontrol | モニタ輝度 |
| obsidian | ノート |

---

## 4. Mac App Store（masApps）

- Accelerate, Actions, AdGuard for Safari, Amphetamine, Blackmagic Disk Speed Test  
- Command X, Consent-O-Matic, CotEditor, DevCleaner, Document Generator  
- Final Cut Pro, FocusRecorder, Gifski, Hex Fiend, Hush, iHosts  
- Keepa, Keynote, Kindle, LadioCast, LanguageTranslator, Leftovers  
- LINE, Messenger, Microsoft Excel/Word/Remote Desktop  
- NamingTranslator, Pages, Refined GitHub, Screegle, Seashore, Shareful  
- Slack, Spark, Speedtest, Squirrel, TabifyIndents, TestFlight  
- The Unarchiver, uBlacklist for Safari, Userscripts, Velja, WhatsApp, Xcode  

（必要に応じて [ryoppippi/dotfiles - nix/modules/darwin/system.nix](https://github.com/ryoppippi/dotfiles) で ID を確認）

---

## 5. Home Manager 共通パッケージ（home/packages.nix）

**CLI・開発基盤**

- curl, htop, fish, tmux  
- bit, git, git-now, git-wt, git-lfs, ghq, lazygit  
- ripgrep, fd, fzf, zoxide, bat, eza, wezterm  
- jq, dust, delta, vivid, trash-cli  
- devenv, nodejs_24, bun, deno, pnpm, uv  
- fixjson, sheep, roots  
- audacity, vscode  
- discord, telegram-desktop（Darwin / x86_64 Linux のみ）

**AI ツール（ai-tools.nix）**

- cursor-agent, opencode, copilot-cli, coderabbit-cli  

**その他プログラム**

- Neovim, Bat, Direnv, Git, GH, jj, Lazygit, Claude Code, Codex, Amp, Cursor CLI, Ghostty, Pip などは各 `programs.*` モジュールで有効化・設定。

---

## 6. システム・macOS 設定（darwin system.defaults）

- Dock: 自動非表示、タイルサイズ 45、最近使った項目なし、genie、下  
- Finder: 拡張子表示、隠しファイル表示、パスバー・ステータスバー、リストビュー  
- グローバル: ダークモード、キーリピート 2、トラックパッド 1.3、自動変換・置換オフ  
- スクリーンショット: ~/Pictures/Screenshots, PNG  
- トラックパッド: タップでクリックオフ、2本指右クリック、Force Touch 等  

---

*最終更新: リポジトリ clone 時点の nix 定義より*
