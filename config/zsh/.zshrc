# Interactive zsh only. Environment and PATH live in ~/.zshenv.

# ─── Options ──────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space
setopt interactive_comments

# Emacs keys. zsh would pick vi mode on its own because EDITOR is vim, and
# /etc/zshrc has already bound Delete/Home/End into that vi keymap, so bind
# them again here.
bindkey -e
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line '^[OH' beginning-of-line
bindkey '^[[F' end-of-line '^[OF' end-of-line

# Up/down search history for what's already typed, like fish.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search

# ─── Completion ───────────────────────────────────────────
# Homebrew's completions (brew, gh, kubectl, …). Apple's /bin/zsh doesn't look
# there by default.
[[ -n $HOMEBREW_PREFIX ]] && fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

# Rebuild the dump once a day and trust it in between, skipping compinit's
# slow security check. Deleting it first matters: compinit leaves an unchanged
# dump untouched, so its age would never reset. After installing new
# completions, `rm ~/.zcompdump` to pick them up right away.
autoload -Uz compinit
_zcompdump=~/.zcompdump
_fresh=(${~_zcompdump}(N.mh-24))
if (( $#_fresh )); then
    compinit -C -d $_zcompdump
else
    rm -f $_zcompdump
    compinit -d $_zcompdump
fi
unset _zcompdump _fresh

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ─── Aliases and functions ────────────────────────────────
source ~/.config/shell/aliases

# jdk 21: point JAVA_HOME at that JDK for this shell. No argument lists JDKs.
jdk() {
    if (( $# == 0 )); then
        /usr/libexec/java_home -V
        return
    fi
    local home
    home=$(/usr/libexec/java_home -F -v "$1") || return
    export JAVA_HOME=$home
    java -version
}

# ─── Tools ────────────────────────────────────────────────
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Machine-local additions, not in the repo.
if [[ -r ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# Must come last: it wraps the widgets defined above. (An `if`, not `&&`, so a
# missing file doesn't leave the first prompt showing a failed status.)
if [[ -r $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
