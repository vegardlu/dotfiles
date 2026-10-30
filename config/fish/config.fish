# ─── Environment and PATH (every fish, scripts included) ──
# Mirrors config/shell/env.sh, which zsh and bash use — keep the two in sync.

set -q DOTFILES; or set -gx DOTFILES $HOME/workspace/dotfiles
set -gx WORKSPACE $HOME/workspace
set -q LANG; or set -gx LANG en_US.UTF-8
set -q EDITOR; or set -gx EDITOR vim

# Homebrew. A static `brew shellenv`, which saves a subprocess per shell.
if test -x /opt/homebrew/bin/brew
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
end

# Ends up as: ~/.local/bin, dotfiles/bin, Homebrew, system, then the extras.
# --path edits PATH itself rather than the fish_user_paths universal variable.
# Login shells (each new terminal tab) --move entries that are already there
# to the front; every other fish inherits a PATH that is already right, maybe
# with a venv deliberately in front, so it only adds what's missing. Missing
# directories are skipped. ~/.local/bin is for Claude Code's native installer
# and pipx.
set -l front $HOME/.local/bin $DOTFILES/bin /opt/homebrew/bin /opt/homebrew/sbin
if status is-login
    fish_add_path --path --move $front
else
    fish_add_path --path $front
end
fish_add_path --path --append $HOME/go/bin "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" /Applications/Postgres.app/Contents/Versions/latest/bin

# Android SDK, managed by Android Studio. Gradle finds the SDK through
# ANDROID_HOME, so projects build without a local.properties. Appended, because
# platform-tools ships its own sqlite3, which must not shadow /usr/bin/sqlite3.
if test -d $HOME/Library/Android/sdk
    set -q ANDROID_HOME; or set -gx ANDROID_HOME $HOME/Library/Android/sdk
    fish_add_path --path --append $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator
end

# Java. Default to Temurin 25 (LTS) without asking java_home; `jdk <version>`
# switches for the current shell. An inherited JAVA_HOME is left alone.
set -l jdk /Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home
if not set -q JAVA_HOME; and test -d $jdk
    set -gx JAVA_HOME $jdk
end

# Docker / colima. Testcontainers doesn't read the active docker context, so it
# needs DOCKER_HOST pointed at colima's socket; the override gives Ryuk the
# in-VM socket path to bind-mount. Set whenever colima has been set up, not
# just while it runs, so shells and IDEs opened before `colima-start` work too.
if not set -q DOCKER_HOST; and test -d $HOME/.colima
    set -gx DOCKER_HOST unix://$HOME/.colima/default/docker.sock
    set -gx TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
end

# ─── Interactive only ─────────────────────────────────────
if status is-interactive
    source ~/.config/shell/aliases

    # Syntax highlighting
    set -g fish_color_autosuggestion '555' 'brblack'
    set -g fish_color_cancel -r
    set -g fish_color_command --bold
    set -g fish_color_comment red
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end brmagenta
    set -g fish_color_error brred
    set -g fish_color_escape 'bryellow' '--bold'
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_match --background=brblue
    set -g fish_color_normal normal
    set -g fish_color_operator bryellow
    set -g fish_color_param cyan
    set -g fish_color_quote yellow
    set -g fish_color_redirection brblue
    set -g fish_color_search_match 'bryellow' '--background=brblack'
    set -g fish_color_selection 'white' '--bold' '--background=brblack'
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline

    type -q starship; and starship init fish | source
    type -q zoxide; and zoxide init fish | source

    # Machine-local additions, not in the repo. (An `if`, not `and`, so a
    # missing file doesn't leave the first prompt showing a failed status.)
    if test -r ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end
end
