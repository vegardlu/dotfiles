# 🏠 Vegard's dotfiles

My macOS setup for hobby development. One command takes a fresh Mac to a working machine with my shells, tools and apps.

![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon-black?logo=apple)
![fish](https://img.shields.io/badge/shell-fish-4AAE47)
![zsh](https://img.shields.io/badge/shell-zsh-F15A24)
![Homebrew](https://img.shields.io/badge/packages-Homebrew-FBB040?logo=homebrew&logoColor=white)

> [!NOTE]
> These are my personal settings. Fork the repo, read through it and remove what you don't need before running it yourself.

![](https://user-images.githubusercontent.com/2592489/95008199-0357ce80-0618-11eb-8d50-06513082baf0.gif)

## ✨ Highlights

- 🐟 **Fish and zsh with the same setup.** Both shells get the same PATH, environment and aliases. Fish is the default shell.
- ⚡ **Fast startup.** The environment files start no subprocesses, and prompts and completions load only in interactive shells.
- 🖥️ **Works in any terminal.** Ghostty, iTerm2 and Terminal.app all behave the same, and so do non-interactive shells such as scripts, IDEs and agents.
- 🍺 **A single Brewfile** for CLI tools, languages, Kubernetes and cloud CLIs, apps and fonts.
- 🔁 **Safe to re-run.** Bootstrap backs files up instead of overwriting them, and cleans up links it left behind earlier.

## 🚀 Quick start

On a fresh Mac, clone over HTTPS (no SSH key needed yet) and run the bootstrap:

```sh
git clone https://github.com/vegardlu/dotfiles.git ~/workspace/dotfiles
bash ~/workspace/dotfiles/bootstrap.sh
```

> [!TIP]
> The first `git` command on a fresh Mac asks to install the Xcode Command Line Tools. Accept the prompt, then run the clone again.

> [!IMPORTANT]
> Apps you installed by hand that are also in the Brewfile make `brew bundle` fail with "It seems there is already an App at …". Delete them first and let Homebrew reinstall them, or take them over afterwards with `brew install --cask --force <cask>`.

Bootstrap shows an interactive menu:

```
┌──────────────────────────────────────┐
│          dotfiles bootstrap           │
└──────────────────────────────────────┘

  Select tasks to run:

    1)  Create workspace directory
    2)  Create symlinks
    3)  Install Homebrew packages
    4)  Set Fish as default shell

    5)  Run all
    0)  Exit
```

| Task | What it does |
|---|---|
| **Create workspace directory** | Creates `~/workspace` |
| **Create symlinks** | Symlinks the configs into `~` and `~/.config`. Files already there are moved to `~/.dotfiles-backup/<timestamp>/`, never deleted |
| **Install Homebrew packages** | Installs Homebrew if it's missing, then everything in the [Brewfile](Brewfile) |
| **Set Fish as default shell** | Adds Homebrew's fish to `/etc/shells` and `chsh`es to it |

Once setup is done, typing **`dotfiles`** in any shell re-runs the bootstrap. Do that after pulling changes or adding packages.

### ✅ After the first run

1. **Open a new terminal** so the new shell and environment take effect.
2. **Pick the Nerd Font** in iTerm2 and Terminal.app: choose *JetBrainsMono Nerd Font* so `eza` icons and the Starship prompt render. Ghostty needs nothing.
3. **Sign in to GitHub:** `gh auth login`. Say yes when it offers to set up git credentials, so pushing over HTTPS works. It adds a credential helper to [`config/git/config`](config/git/config), which is worth committing.
4. **Docker:** start the VM with `colima-start`. `docker compose` and `docker buildx` are already wired up, because the Homebrew task points `~/.docker/config.json` at Homebrew's plugin directory.
5. **Xcode** (not in the Brewfile): install it from the App Store, open it once, then point the command-line tools at it with `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`. Until then `xcodebuild` fails with "requires Xcode, but active developer directory … is a command line tools instance". Sign in to your Apple ID under *Settings → Accounts* so automatic signing works.
6. **Android:** run `android-sdk`. It installs Google's command-line tools, platform-tools and the emulator into `~/Library/Android/sdk`, Android Studio's own location, so a new terminal then has `ANDROID_HOME` and the tools. Projects add their platforms and emulators on top. The new `android` CLI asks for no licence step; on Android Studio's first launch, point it at that SDK rather than letting it download a second one.

## 🐚 Shells

| Shell | Environment and PATH | Interactive setup |
|---|---|---|
| **fish** | top of [`config/fish/config.fish`](config/fish/config.fish) | rest of `config.fish` |
| **zsh** | [`config/shell/env.sh`](config/shell/env.sh), from `.zshenv` and `.zprofile` | [`config/zsh/.zshrc`](config/zsh/.zshrc) |
| **bash** | [`config/shell/env.sh`](config/shell/env.sh), from `.bash_profile` | aliases, in login shells only |

`env.sh` and the top of `config.fish` mirror each other, so a change to one also needs making in the other.

### PATH

Every shell ends up with the same order:

1. `~/.local/bin` (Claude Code, pipx)
2. `~/workspace/dotfiles/bin`
3. Homebrew: `/opt/homebrew/bin`, `/opt/homebrew/sbin`
4. System directories
5. `~/go/bin`, JetBrains Toolbox scripts, Postgres.app's `psql` and friends, Android SDK tools

Directories that don't exist are skipped. Only login shells (new terminal tabs) move entries to the front. Nested shells and scripts only add what's missing, so an activated venv or `nvm use` stays in front. Zsh reads `env.sh` twice on purpose: macOS's `/etc/zprofile` runs `path_helper` after `.zshenv`, which moves `/usr/bin` back in front of Homebrew, so `.zprofile` puts the order right again.

### Environment

| Variable | Value |
|---|---|
| `JAVA_HOME` | Temurin 25 (switch with `jdk <version>`) |
| `ANDROID_HOME` | `~/Library/Android/sdk`, once `android-sdk` has installed it |
| `DOCKER_HOST`, `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` | Colima's socket, once Colima has been set up (for Testcontainers) |
| `DOTFILES`, `WORKSPACE` | `~/workspace/dotfiles`, `~/workspace` |
| `EDITOR`, `LANG` | `vim`, `en_US.UTF-8`, unless already set |

### Zsh extras

Zsh gets a few touches to feel closer to fish: prefix history search on ↑/↓, case-insensitive menu completion, syntax highlighting, shared history across tabs, and Homebrew's completions (brew, gh, kubectl, …).

## ⌨️ Aliases, functions and commands

Available in fish and zsh. The aliases (`e`, `dotfiles`) live in [`config/shell/aliases`](config/shell/aliases), which bash reads too.

| Command | What it does |
|---|---|
| `e` | Pretty file listing (`eza` with icons and git status) |
| `dotfiles` | Re-run the bootstrap |
| `jdk <version>` | Point `JAVA_HOME` at another installed JDK for this shell; `jdk` alone lists them |
| `z <dir>` | Jump to a frequently used directory ([zoxide](https://github.com/ajeetdsouza/zoxide)) |

Scripts in [`bin/`](bin) are on PATH everywhere:

| Script | What it does |
|---|---|
| `android-sdk` | Install the Android SDK's command-line tools, platform-tools and emulator into `~/Library/Android/sdk`, checksum-verified; any packages passed go in too |
| `colima-start` | Start Colima with Apple Silicon defaults (`vz`, `virtiofs`; override with `COLIMA_CPU` / `COLIMA_MEMORY`) |
| `flyway-clean` | Flyway clean of the local Postgres.app database, behind a confirmation prompt (override with `DATABASE_JDBC_URL` / `DATABASE_USERNAME`) |

## 🍺 What gets installed

All from the [Brewfile](Brewfile):

| Group | Highlights |
|---|---|
| **Core** | git, gh, vim, jq, yq, fzf, ripgrep, fd, bat, eza |
| **Shell** | fish, starship, zoxide, zsh-syntax-highlighting |
| **Languages** | Node, Python, Go, Kotlin, Ruby, Lua, Java (Temurin) |
| **Development** | Maven, Gradle, mvnd, Flyway, GoReleaser, golangci-lint, ShellCheck, Colima + Docker |
| **AI tools** | Claude, Codex, Copilot CLI, opencode, Antigravity |
| **Kubernetes / cloud** | kubectl, kubectx, helm, k9s, stern, kubeseal, AWS CLI, gcloud, cloudflared |
| **Media** | ffmpeg, ImageMagick, vips, exiftool |
| **Apps** | Ghostty, iTerm2, VS Code, Android Studio, Postgres.app, Chrome, Firefox, Discord, Spotify |
| **Fonts** | JetBrains Mono, JetBrains Mono Nerd Font |

## 📁 Repo layout

```
dotfiles/
├── bootstrap.sh            # Interactive setup menu
├── brew-install.sh         # Installs Homebrew, runs brew bundle
├── Brewfile                # Everything Homebrew installs
├── .vimrc
├── bin/                    # Scripts, on PATH
└── config/
    ├── shell/              # → ~/.config/shell, shared by all shells
    │   ├── env.sh          #   environment and PATH (zsh, bash)
    │   └── aliases         #   aliases (fish, zsh, bash)
    ├── fish/
    │   ├── config.fish     # environment, PATH and interactive setup
    │   ├── completions/    # completions for bin/ scripts
    │   └── functions/      # autoloaded functions (jdk, fish_greeting)
    ├── zsh/                # .zshenv, .zprofile, .zshrc
    ├── bash/.bash_profile
    ├── git/                # → ~/.config/git: config and global ignore
    └── starship.toml       # prompt
```

## 🛠️ Making it yours

| To add… | Edit |
|---|---|
| A Homebrew package | [`Brewfile`](Brewfile), then `dotfiles` → *Install Homebrew packages* |
| An alias | [`config/shell/aliases`](config/shell/aliases). Keep the `alias name='command'` form so all three shells can read it |
| An env var or PATH entry | [`config/shell/env.sh`](config/shell/env.sh) **and** the top of [`config/fish/config.fish`](config/fish/config.fish) |
| A script | an executable in `bin/`, optionally with completions in `config/fish/completions/` |
| A fish function | `config/fish/functions/<name>.fish`. It autoloads on first use, so it costs nothing at startup |
| Machine-only interactive settings | `~/.config/fish/local.fish` or `~/.zshrc.local`. They're read if present and kept out of the repo, but only by interactive shells, so put environment that scripts and IDEs need in `env.sh` |

## 🩺 Troubleshooting

- **A command resolves to the wrong binary.** Check `type -a <cmd>` (fish) or `whence -a <cmd>` (zsh) against the [PATH order](#path) above.
- **New zsh completions don't show up.** Zsh rebuilds its completion cache once a day. Run `rm ~/.zcompdump` and open a new tab.
- **Zsh warns about "insecure directories".** Some of Homebrew's directories are group-writable. Run `compaudit | xargs chmod g-w`.
- **Something disappeared after bootstrap.** Look in `~/.dotfiles-backup/`. That includes any old `~/.gitconfig`, which would otherwise override [`config/git/config`](config/git/config).
- **`git status` in this repo shows changes you didn't make.** The configs are symlinks into the repo, so whatever writes to them edits the repo. That covers installers appending to `~/.zprofile` or `config.fish`, `git config --global` and `gh auth` writing to `config/git/config`, and fish's `funcsave` writing to `config/fish/functions/`. Commit what's worth keeping (gh's credential helper is), move PATH lines into `env.sh` / `config.fish`, and discard the rest.
