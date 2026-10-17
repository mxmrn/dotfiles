# =====================================================
# ZSH Plugins
# =====================================================

# fzf-tab: fzf menu for completion (must load before autosuggestions/highlighting)
if [[ -f /usr/share/zsh/plugins/fzf-tab-source/fzf-tab.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/fzf-tab-source/fzf-tab.plugin.zsh
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:*' switch-group ',' '.'
    if command -v eza >/dev/null 2>&1; then
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    fi
fi

# zsh-autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-history-substring-search
if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    # Bind arrow keys
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi
