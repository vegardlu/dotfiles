# Homebrew (static — avoids spawning brew shellenv subprocess on every login)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# JetBrains Toolbox
export PATH="$PATH:/Users/vegard/Library/Application Support/JetBrains/Toolbox/scripts"
