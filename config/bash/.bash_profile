# Bash isn't the daily shell, but give it the same environment, PATH and
# aliases so it behaves when something drops into it.

export BASH_SILENCE_DEPRECATION_WARNING=1   # macOS "default shell is now zsh" nag

if [ -r ~/.config/shell/env.sh ]; then
    . ~/.config/shell/env.sh
fi
if [ -r ~/.config/shell/aliases ]; then
    . ~/.config/shell/aliases
fi
