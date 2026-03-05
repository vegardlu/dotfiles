# 🏠 Vegard's dotfiles

Nice! You want to give these dotfiles a try! You may want to first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Your mileage may vary. 🚀

![](https://user-images.githubusercontent.com/2592489/95008199-0357ce80-0618-11eb-8d50-06513082baf0.gif)

## What's inside

- **Fish shell** as the primary shell, with [Starship](https://starship.rs) prompt, custom aliases, and completions
- **Homebrew** package management with a curated [Brewfile](Brewfile) — dev tools, Kubernetes/cloud CLIs, casks, fonts, and multiple Java (Temurin) versions
- **CLI commands** in `bin/` — handy scripts available system-wide
- Config for **Bash**, **Zsh**, **Vim**, and **Starship** (all symlinked into place)

## Installation

Clone this repo to `~/workspace/dotfiles` and run the bootstrap:

```sh
git clone git@github.com:vegardlu/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
bash bootstrap.sh
```

The bootstrap presents an interactive menu — pick what you need:

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

Running all tasks will create `~/workspace`, symlink config files, install everything in the Brewfile, and set Fish as your default shell.

## The `dotfiles` command

After setup, you can re-run the bootstrap anytime by simply typing:

```sh
dotfiles
```

This is a Fish alias that runs `bash ~/workspace/dotfiles/bootstrap.sh`. Use it whenever you pull new changes or want to re-link config files and install new packages.

## CLI commands

Scripts in `bin/` are added to your `$PATH` automatically. They're available as regular commands from any directory.

| Command | Description |
|---|---|
| `nais-postgres-proxy` | Interactive wrapper around `nais postgres proxy` — prompts for team, port, reason, and database name with sensible defaults. Supports auto-discovery of databases via kubectl and non-interactive flag mode. Run `nais-postgres-proxy --help` for details. |
| `cloudutil` | Jasypt encryption utility for Spring Boot secrets |
| `flyway-clean` | Safe Flyway database clean with confirmation prompt |

## Shell aliases

Defined in [`config/fish/alias.fish`](config/fish/alias.fish):

| Alias | What it does |
|---|---|
| `e` | Pretty file listing (`eza` with icons and git status) |
| `dotfiles` | Re-run the bootstrap script |
| `mvnit` | `mvn clean install` with integration tests |
| `mvnp` | `mvn clean install` with packaging |
| `mvnitp` | `mvn clean install` with packaging + integration tests |
| `java11` / `java17` / `java21` / `java25` | Switch active Java version |
| `dcd` | Shortcut for docker compose with a shared dev compose file |

## Repo structure

```
dotfiles/
├── bootstrap.sh              # Entry point — interactive setup menu
├── brew-install.sh            # Installs Homebrew + runs brew bundle
├── Brewfile                   # All Homebrew packages, casks, and fonts
├── .vimrc                     # Vim config
├── bin/                       # CLI commands (added to $PATH)
│   ├── nais-postgres-proxy
│   ├── cloudutil
│   └── flyway-clean
└── config/
    ├── fish/
    │   ├── config.fish        # Main Fish config (sources the files below)
    │   ├── alias.fish         # Shell aliases
    │   ├── export.fish        # Exported env vars (Java homes, workspace)
    │   ├── local.fish         # Machine-local env vars (not committed)
    │   └── completions/       # Fish completions for CLI commands
    ├── bash/.bash_profile
    ├── zsh/.zshenv, .zshrc
    └── starship.toml          # Starship prompt config
```

## Adding your own stuff

- **New CLI command** → add an executable script to `bin/`, optionally with Fish completions in `config/fish/completions/`
- **New Homebrew package** → add to the matching section in `Brewfile`, then run `dotfiles` and pick "Install Homebrew packages"
- **New alias** → add to `config/fish/alias.fish`
- **Machine-specific env vars** → add to `config/fish/local.fish`
