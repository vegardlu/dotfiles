# Copilot Instructions

## Architecture

This is a macOS dotfiles repo expected to live at `~/workspace/dotfiles`. It manages shell configuration, Homebrew packages, and CLI utilities.

**Bootstrap flow:** `bootstrap.sh` is the entry point — an interactive menu that creates `~/workspace`, symlinks config files into `$HOME`, runs `brew-install.sh` (which installs Homebrew if needed then runs `brew bundle` on `Brewfile`), and optionally sets Fish as the default shell.

**Shell config (Fish is primary):** `config/fish/config.fish` sources three files in order:
1. `alias.fish` — shell aliases (Maven shortcuts, Java version switching, Docker Compose)
2. `local.fish` — machine-local environment variables (database connection, Azure config) — not meant to be generic
3. `export.fish` — exported env vars (workspace path, Java homes)

Config files are symlinked into `~/.config/fish/` by `bootstrap.sh`. The `bin/` directory is added to `$PATH` in `config.fish`.

**CLI scripts in `bin/`:** Standalone commands available system-wide. Each script is a single-purpose executable. Fish completions for these scripts go in `config/fish/completions/<script-name>.fish`.

## Conventions

### Adding a new CLI command
1. Create an executable script in `bin/` (use `#!/bin/sh` with `set -e` for simple scripts, `#!/usr/bin/env bash` with `set -euo pipefail` for anything using bash features)
2. If the command needs a new tool, add it to `Brewfile` under the appropriate section
3. Add Fish completions in `config/fish/completions/<command>.fish` if the command accepts subcommands or arguments

### Brewfile organization
Entries are grouped by section comments: Taps, Core tools, Shell, Development, Kubernetes / Cloud, Utilities, Casks, Fonts, Java (Temurin). Add new entries to the matching section.

### Adding a new shell alias
Add to `config/fish/alias.fish` with a section comment grouping related aliases.

### Adding environment variables
- Machine-specific / secret values → `config/fish/local.fish`
- General exports → `config/fish/export.fish`

### Symlinks
When adding new config files that need to live in `$HOME` or `~/.config/`, add the symlink mapping to the `links` array in `bootstrap.sh`'s `task_symlinks` function.
