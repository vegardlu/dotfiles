#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Colors
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

# ─── Helpers ──────────────────────────────────────────────

info()    { printf "${CYAN}▸ %s${NC}\n" "$1"; }
success() { printf "${GREEN}✔ %s${NC}\n" "$1"; }
warn()    { printf "${YELLOW}⚠ %s${NC}\n" "$1"; }
fail()    { printf "${RED}✖ %s${NC}\n" "$1"; }

header() {
    echo ""
    printf "${BOLD}${CYAN}"
    echo "┌──────────────────────────────────────┐"
    echo "│          dotfiles bootstrap           │"
    echo "└──────────────────────────────────────┘"
    printf "${NC}"
    echo ""
}

# ─── Tasks ────────────────────────────────────────────────
#
# run_task calls these inside an `if`, which switches off `set -e` for them,
# so every step that can fail has to check for it explicitly.

task_workspace() {
    info "Creating workspace directory"
    mkdir -pv "${HOME}/workspace"
    success "Workspace ready"
}

# Move a real file or directory out of the way, keeping it under ~/.dotfiles-backup
backup() {
    local target="$1"
    [ -e "$target" ] && [ ! -L "$target" ] || return 0
    mkdir -p "$BACKUP_DIR" && mv "$target" "$BACKUP_DIR/" || return 1
    warn "Moved existing $target to $BACKUP_DIR/"
}

task_symlinks() {
    info "Creating symlinks"
    mkdir -pv "${HOME}/.config/fish" || return 1

    # The shell config finds the repo through $DOTFILES, which defaults to here
    if [ "$DOTFILES" != "$HOME/workspace/dotfiles" ]; then
        warn "Repo is at $DOTFILES, not ~/workspace/dotfiles — the shells won't find bin/ or the dotfiles alias."
        warn "Move it there, or link it: ln -s \"$DOTFILES\" ~/workspace/dotfiles"
    fi

    local links=(
        "$DOTFILES/.vimrc:$HOME/.vimrc"
        "$DOTFILES/config/bash/.bash_profile:$HOME/.bash_profile"
        "$DOTFILES/config/zsh/.zshenv:$HOME/.zshenv"
        "$DOTFILES/config/zsh/.zprofile:$HOME/.zprofile"
        "$DOTFILES/config/zsh/.zshrc:$HOME/.zshrc"
        "$DOTFILES/config/shell:$HOME/.config/shell"
        "$DOTFILES/config/fish/config.fish:$HOME/.config/fish/config.fish"
        "$DOTFILES/config/fish/completions:$HOME/.config/fish/completions"
        "$DOTFILES/config/fish/functions:$HOME/.config/fish/functions"
        "$DOTFILES/config/git:$HOME/.config/git"
        "$DOTFILES/config/starship.toml:$HOME/.config/starship.toml"
    )

    local failed=0
    for entry in "${links[@]}"; do
        src="${entry%%:*}"
        dst="${entry##*:}"
        if [ ! -e "$src" ]; then
            warn "Skipping $(basename "$src") — source not found"
        elif ! backup "$dst"; then
            fail "Couldn't move $dst out of the way — left it alone"
            failed=1
        elif ! ln -snvf "$src" "$dst"; then
            failed=1
        fi
    done

    # Links left behind by files since removed from the repo
    for link in "$HOME"/.* "$HOME"/.config/* "$HOME"/.config/fish/*; do
        if [ -L "$link" ] && [ ! -e "$link" ] && [[ "$(readlink "$link")" == "$DOTFILES"/* ]]; then
            rm -v "$link"
        fi
    done

    # ~/.gitconfig wins over ~/.config/git/config, so it would hide the repo's
    if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
        backup "$HOME/.gitconfig" || failed=1
    fi

    [ "$failed" -eq 0 ] || return 1
    success "Symlinks created"
}

task_homebrew() {
    if [[ "$OSTYPE" != darwin* ]]; then
        warn "Skipping Homebrew — macOS not detected"
        return
    fi
    info "Installing Homebrew packages (this may take a while)"
    bash "$DOTFILES/brew-install.sh" || return 1
    success "Homebrew packages installed"
}

task_fish_default() {
    local fish_path
    fish_path="$(command -v fish || true)"
    # Homebrew may have been installed earlier in this run, so not on PATH yet
    if [ -z "$fish_path" ] && [ -x /opt/homebrew/bin/fish ]; then
        fish_path=/opt/homebrew/bin/fish
    fi

    if [ -z "$fish_path" ]; then
        fail "Fish shell not found — install it first (e.g. brew install fish)"
        return 1
    fi

    if [ "$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')" = "$fish_path" ]; then
        success "Fish is already the default shell"
        return
    fi

    if ! grep -qxF "$fish_path" /etc/shells; then
        info "Adding $fish_path to /etc/shells (requires sudo)"
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null || return 1
    fi

    info "Setting Fish as default shell"
    chsh -s "$fish_path" || return 1
    success "Default shell set to Fish"
}

# ─── Menu ─────────────────────────────────────────────────

TASKS=(
    "Create workspace directory"
    "Create symlinks"
    "Install Homebrew packages"
    "Set Fish as default shell"
)

TASK_FNS=(
    task_workspace
    task_symlinks
    task_homebrew
    task_fish_default
)

show_menu() {
    printf "${BOLD}  Select tasks to run:${NC}\n\n"

    for i in "${!TASKS[@]}"; do
        local n=$((i + 1))
        printf "    ${BOLD}%d)${NC}  %s\n" "$n" "${TASKS[$i]}"
    done

    local all=$((${#TASKS[@]} + 1))
    printf "\n    ${BOLD}%d)${NC}  ${GREEN}Run all${NC}\n" "$all"
    printf "    ${BOLD}0)${NC}  ${DIM}Exit${NC}\n"
    echo ""
}

run_task() {
    local idx=$1
    echo ""
    printf "${BOLD}── %s ────────────────────────${NC}\n" "${TASKS[$idx]}"
    if ${TASK_FNS[$idx]}; then
        echo ""
    else
        fail "Task failed"
        echo ""
    fi
}

# ─── Main ─────────────────────────────────────────────────

main() {
    cd "$DOTFILES"
    header
    show_menu

    local total=${#TASKS[@]}
    local all_option=$((total + 1))

    printf "  ${BOLD}Enter choice(s)${NC} ${DIM}(e.g. 1 2 3, or %d for all)${NC}: " "$all_option"
    read -r choices

    if [ -z "$choices" ]; then
        warn "No selection made"
        exit 0
    fi

    for choice in $choices; do
        if [ "$choice" = "0" ]; then
            info "Bye!"
            exit 0
        elif [ "$choice" = "$all_option" ]; then
            for i in "${!TASKS[@]}"; do
                run_task "$i"
            done
            break
        elif [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -le "$total" ]; then
            run_task $((choice - 1))
        else
            warn "Invalid option: $choice"
        fi
    done

    echo ""
    success "Done!"
}

main "$@"
