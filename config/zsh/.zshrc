# ─── Completion system ─────────────────────────────────────
# Only rebuild completion dump once per day; otherwise reuse cache
autoload -Uz compinit
if [[ -f ~/.zcompdump && $(date +'%j') == $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]]; then
    compinit -C
else
    compinit
fi

# ─── kubectl completions (cached) ─────────────────────────
# Regenerate cache if missing or older than 7 days
if command -v kubectl &>/dev/null; then
    local _kubectl_comp=~/.zsh_kubectl_completion
    if [[ ! -f "$_kubectl_comp" || $(find "$_kubectl_comp" -mtime +7 2>/dev/null) ]]; then
        kubectl completion zsh > "$_kubectl_comp" 2>/dev/null
    fi
    [[ -f "$_kubectl_comp" ]] && source "$_kubectl_comp"
fi

# ─── Environment ──────────────────────────────────────────
export LANG=en_US.UTF-8

# ─── thefuck (inlined to avoid spawning Python on every startup) ──
# Re-run: thefuck --alias  (from zsh) to update if thefuck changes
if command -v thefuck &>/dev/null; then
    fuck () {
        TF_PYTHONIOENCODING=$PYTHONIOENCODING
        export TF_SHELL=zsh
        export TF_ALIAS=fuck
        TF_SHELL_ALIASES=$(alias)
        export TF_SHELL_ALIASES
        TF_HISTORY="$(fc -ln -10)"
        export TF_HISTORY
        export PYTHONIOENCODING=utf-8
        TF_CMD=$(thefuck THEFUCK_ARGUMENT_PLACEHOLDER "$@") && eval "$TF_CMD"
        unset TF_HISTORY
        export PYTHONIOENCODING=$TF_PYTHONIOENCODING
        test -n "$TF_CMD" && print -s "$TF_CMD"
    }
fi

# ─── Prompt (Starship) ────────────────────────────────────
eval "$(starship init zsh)"
