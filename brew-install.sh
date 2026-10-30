#!/usr/bin/env bash
# Install Homebrew if it's missing, then everything in the Brewfile.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
    if [ ! -x /opt/homebrew/bin/brew ]; then
        echo "Homebrew not installed. Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    # A fresh install isn't on PATH yet
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update

# One failed package shouldn't skip the setup below; report it at the end.
bundle_status=0
brew bundle --file="$DOTFILES/Brewfile" || bundle_status=$?

# docker compose and docker buildx are Docker CLI plugins; Homebrew installs
# them where the CLI only looks if ~/.docker/config.json says so.
plugins="$(brew --prefix)/lib/docker/cli-plugins"
config="$HOME/.docker/config.json"
mkdir -p "$HOME/.docker"
[ -s "$config" ] || echo '{}' > "$config"
if updated="$(jq --arg dir "$plugins" \
    '.cliPluginsExtraDirs = ((.cliPluginsExtraDirs // []) + [$dir] | unique)' "$config")"; then
    printf '%s\n' "$updated" > "$config"
else
    echo "Couldn't update $config — add \"cliPluginsExtraDirs\": [\"$plugins\"] by hand" >&2
fi

if [ "$bundle_status" -ne 0 ]; then
    cat >&2 <<'MSG'

brew bundle couldn't install everything — see its output above. The usual
cause is an app already in /Applications that Homebrew didn't install
("It seems there is already an App at …"). Delete that app, or let Homebrew
take it over with `brew install --cask --force <cask>`, then run this again.
MSG
    exit "$bundle_status"
fi
