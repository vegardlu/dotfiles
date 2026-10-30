# Login shells, which is every new tab in Terminal, iTerm2 and Ghostty.
#
# macOS's /etc/zprofile runs path_helper between ~/.zshenv and this file, and
# it moves /usr/bin and friends back in front of Homebrew. Re-apply our order.
[[ -r ~/.config/shell/env.sh ]] && source ~/.config/shell/env.sh
