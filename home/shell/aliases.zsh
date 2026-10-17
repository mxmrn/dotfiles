#!/bin/zsh
# =====================================================
# Shell Aliases
# =====================================================

# Dotfiles management
alias dotfiles='cd ${HOME}/dotfiles'
alias dots='cd ${HOME}/dotfiles'
alias hyprconf='cd ${HOME}/dotfiles/config/hypr'
alias nvimconf='cd ${HOME}/dotfiles/config/nvim'

# System
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "No orphans to remove"'

# ls with colors
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'

# Modern replacements (only when installed)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first --icons=auto'
    alias ll='eza -lah --git --icons=auto --group-directories-first'
    alias la='eza -a --group-directories-first --icons=auto'
    alias lt='eza --tree --level=2 --icons=auto'
fi
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v dust >/dev/null 2>&1 && alias du='dust'
command -v duf >/dev/null 2>&1 && alias df='duf'

# grep with colors
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# Hyprland
alias hypr-reload='hyprctl reload'
alias hypr-restart='systemctl --user restart waybar swaync'

# Docker-compose
alias dcup='docker-compose up -d --build'
alias dcdn='docker-compose down'
alias dclg='docker-compose logs -f'

# nvim
alias v='nvim'

