#!/bin/zsh
# =====================================================
# fzf: Ctrl-R history, Ctrl-T files, Alt-C directories
# =====================================================

command -v fzf >/dev/null 2>&1 || return

source <(fzf --zsh)

export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --info=inline"

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi

if command -v bat >/dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
fi

if command -v eza >/dev/null 2>&1; then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
fi
