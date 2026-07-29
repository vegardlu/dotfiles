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

    # cmdline-tools goes first, ahead of Homebrew: the android-commandlinetools
    # cask links the same binaries, but that copy defaults to its own empty SDK
    # root, so sdkmanager/avdmanager would quietly operate on nothing. This copy
    # lives inside the SDK and resolves it without any --sdk_root flag.
    _android_cli="$ANDROID_HOME/cmdline-tools/latest/bin"
    case ":$PATH:" in
        *":$_android_cli:"*) ;;
        *) [ -d "$_android_cli" ] && export PATH="$_android_cli:$PATH" ;;
    esac

    # platform-tools and emulator go last — platform-tools ships its own sqlite3,
    # which must not shadow /usr/bin/sqlite3.
    for _android_dir in platform-tools emulator; do
        _android_path="$ANDROID_HOME/$_android_dir"
        case ":$PATH:" in
            *":$_android_path:"*) ;;
            *) [ -d "$_android_path" ] && export PATH="$PATH:$_android_path" ;;
        esac
    done
    unset _android_cli _android_dir _android_path
fi
