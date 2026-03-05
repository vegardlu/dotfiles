#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

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

task_workspace() {
    info "Creating workspace directory"
    mkdir -pv "${HOME}/workspace"
    success "Workspace ready"
}

task_symlinks() {
    info "Creating symlinks"
    mkdir -pv "${HOME}/.config"
    mkdir -pv "${HOME}/.config/fish"

    local links=(
        "$DOTFILES/.vimrc:$HOME/.vimrc"
        "$DOTFILES/config/bash/.bash_profile:$HOME/.bash_profile"
        "$DOTFILES/config/zsh/.zshenv:$HOME/.zshenv"
        "$DOTFILES/config/zsh/.zshrc:$HOME/.zshrc"
        "$DOTFILES/config/fish/config.fish:$HOME/.config/fish/config.fish"
        "$DOTFILES/config/fish/alias.fish:$HOME/.config/fish/alias.fish"
        "$DOTFILES/config/fish/local.fish:$HOME/.config/fish/local.fish"
        "$DOTFILES/config/fish/export.fish:$HOME/.config/fish/export.fish"
        "$DOTFILES/config/fish/completions:$HOME/.config/fish/completions"
        "$DOTFILES/config/starship.toml:$HOME/.config/starship.toml"
    )

    for entry in "${links[@]}"; do
        src="${entry%%:*}"
        dst="${entry##*:}"
        if [ -e "$src" ]; then
            ln -snvf "$src" "$dst"
        else
            warn "Skipping $(basename "$src") — source not found"
        fi
    done

    success "Symlinks created"
}

task_homebrew() {
    if [[ "$OSTYPE" != darwin* ]]; then
        warn "Skipping Homebrew — macOS not detected"
        return
    fi
    info "Installing Homebrew packages (this may take a while)"
    bash "$DOTFILES/brew-install.sh"
    success "Homebrew packages installed"
}

task_fish_default() {
    local fish_path
    fish_path="$(which fish 2>/dev/null || true)"

    if [ -z "$fish_path" ]; then
        fail "Fish shell not found — install it first (e.g. brew install fish)"
        return 1
    fi

    if ! grep -qF "$fish_path" /etc/shells; then
        info "Adding $fish_path to /etc/shells (requires sudo)"
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi

    info "Setting Fish as default shell"
    chsh -s "$fish_path"
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
