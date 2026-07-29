# Fish alias
source ~/.config/fish/alias.fish

# Fish local
source ~/.config/fish/local.fish

# Fish export
source ~/.config/fish/export.fish

# Path
set PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
set PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH
set PATH $HOME/workspace/dotfiles/bin $PATH

# Android SDK tools (ANDROID_HOME comes from export.fish, sourced above).
# cmdline-tools goes first, ahead of Homebrew: the android-commandlinetools cask
# links the same binaries, but that copy defaults to its own empty SDK root, so
# sdkmanager/avdmanager would quietly operate on nothing. This copy lives inside
# the SDK and resolves it without any --sdk_root flag. platform-tools and
# emulator go last — platform-tools ships its own sqlite3, which must not shadow
# /usr/bin/sqlite3. fish_add_path can't express that ordering: its --append only
# orders within fish_user_paths, a block fish prepends to PATH wholesale, so an
# "appended" platform-tools still landed first and did shadow sqlite3.
if set -q ANDROID_HOME
    set -l cli $ANDROID_HOME/cmdline-tools/latest/bin
    if test -d $cli; and not contains $cli $PATH
        set -gx PATH $cli $PATH
    end
    for dir in platform-tools emulator
        if test -d $ANDROID_HOME/$dir; and not contains $ANDROID_HOME/$dir $PATH
            set -gx PATH $PATH $ANDROID_HOME/$dir
        end
    end
end

# Fish syntax highlighting
set -g fish_color_autosuggestion '555'  'brblack'
set -g fish_color_cancel -r
set -g fish_color_command --bold
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end brmagenta
set -g fish_color_error brred
set -g fish_color_escape 'bryellow'  '--bold'
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection brblue
set -g fish_color_search_match 'bryellow'  '--background=brblack'
set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

# My Starship
starship init fish | source

# Zoxide directory jumping
zoxide init fish | source

# Java 25
java25

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vegard/google-cloud-sdk/path.fish.inc' ]; . '/Users/vegard/google-cloud-sdk/path.fish.inc'; end
