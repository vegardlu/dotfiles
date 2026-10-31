# Environment and PATH for zsh and bash.
#
# Sourced by ~/.zshenv (every zsh, scripts included), again by ~/.zprofile (see
# the note there) and by ~/.bash_profile, so it must stay idempotent and cheap:
# no subprocesses. Fish has its own copy in config/fish/config.fish — keep the
# two in sync.

export DOTFILES="${DOTFILES:-$HOME/workspace/dotfiles}"
export WORKSPACE="$HOME/workspace"
export LANG="${LANG:-en_US.UTF-8}"
export EDITOR="${EDITOR:-vim}"

# Homebrew. A static `brew shellenv`, which saves a subprocess per shell.
if [ -x /opt/homebrew/bin/brew ]; then
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_CELLAR=/opt/homebrew/Cellar
    export HOMEBREW_REPOSITORY=/opt/homebrew
fi

# Login shells (each new terminal tab) put our directories first, moving them
# if they're already there. Every other shell inherits a PATH that is already
# right, maybe with a venv or nvm deliberately in front, so it only adds
# what's missing.
_login=
if [ -n "${ZSH_VERSION-}" ]; then
    [[ -o login ]] && _login=1
elif [ -n "${BASH_VERSION-}" ]; then
    shopt -q login_shell && _login=1
fi

# _path_front DIR: put DIR first on PATH (login shells move it there).
_path_front() {
    [ -d "$1" ] || return 0
    if [ -z "$_login" ]; then
        case ":$PATH:" in *":$1:"*) return 0 ;; esac
    fi
    local p=":$PATH:"
    p="${p//":$1:"/:}"
    p="${p#:}"
    p="${p%:}"
    PATH="$1${p:+:$p}"
}

# _path_back DIR: append DIR to PATH unless already present.
_path_back() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

# Ends up as: ~/.local/bin, dotfiles/bin, Homebrew, system, then the extras.
_path_front /opt/homebrew/sbin
_path_front /opt/homebrew/bin
_path_front "$DOTFILES/bin"
_path_front "$HOME/.local/bin"   # Claude Code's native installer, pipx

_path_back "$HOME/go/bin"
_path_back "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
_path_back /Applications/Postgres.app/Contents/Versions/latest/bin   # psql & co

# Android SDK, in Android Studio's location (android-sdk installs it). Gradle finds it through
# ANDROID_HOME, so projects build without a local.properties. Appended, because
# platform-tools ships its own sqlite3, which must not shadow /usr/bin/sqlite3.
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
    _path_back "$ANDROID_HOME/cmdline-tools/latest/bin"
    _path_back "$ANDROID_HOME/platform-tools"
    _path_back "$ANDROID_HOME/emulator"
fi

export PATH
unset -f _path_front _path_back
unset _login

# Java. Default to Temurin 25 (LTS) without asking java_home; `jdk <version>`
# switches for the current shell. An inherited JAVA_HOME is left alone.
_jdk=/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home
if [ -z "${JAVA_HOME-}" ] && [ -d "$_jdk" ]; then
    export JAVA_HOME="$_jdk"
fi
unset _jdk

# Docker / colima. Testcontainers doesn't read the active docker context, so it
# needs DOCKER_HOST pointed at colima's socket; the override gives Ryuk the
# in-VM socket path to bind-mount. Set whenever colima has been set up, not
# just while it runs, so shells and IDEs opened before `colima-start` work too.
if [ -z "${DOCKER_HOST-}" ] && [ -d "$HOME/.colima" ]; then
    export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
    export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
fi
