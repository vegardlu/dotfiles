# Read by every zsh, interactive or not: environment and PATH only.

# Turn off Apple Terminal's per-tab history sessions (~/.zsh_sessions), so
# history behaves the same in Terminal, iTerm2 and Ghostty.
export SHELL_SESSIONS_DISABLE=1

[[ -r ~/.config/shell/env.sh ]] && source ~/.config/shell/env.sh
