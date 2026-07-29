# Docker / colima. Testcontainers does not read the active docker context, so it
# needs DOCKER_HOST pointed at colima's socket; the override gives Ryuk the
# in-VM socket path to bind-mount. Guarded so the dotfiles stay portable.
if [[ -S "$HOME/.colima/default/docker.sock" ]]; then
    export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
    export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"
fi

# Android SDK, managed by Android Studio. ANDROID_HOME is how Gradle locates the
# SDK without a local.properties. Here rather than in .zprofile so that
# non-interactive zsh — scripts, Gradle, agent tooling — finds adb too, the same
# reason DOCKER_HOST sits in this file; fish gets it for free since config.fish
# runs for every session. Appended so nothing shadows a Homebrew binary, each
# directory tested because Studio installs them piecemeal, and re-entry guarded
# because .zshenv runs again for every nested shell.
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    for _android_dir in platform-tools emulator cmdline-tools/latest/bin; do
        _android_path="$ANDROID_HOME/$_android_dir"
        case ":$PATH:" in
            *":$_android_path:"*) ;;
            *) [ -d "$_android_path" ] && export PATH="$PATH:$_android_path" ;;
        esac
    done
    unset _android_dir _android_path
fi
