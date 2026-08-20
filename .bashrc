#
# ~/.bashrc
# @author chanchanjeu
# Creation Date: 2025/12/27
# Last Modified: 2026/08/20
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ==========================================
# 1. ENVIRONMENT & ESSENTIALS
# ==========================================
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nano'
export VISUAL='nano'
export GPG_TTY=$(tty)

# Better and larger history settings (ignores duplicates)
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd 2>/dev/null # type '..' or folder name directly to cd

# ==========================================
# 2. MODERN REPLACEMENTS & COLOR ALIASES
# ==========================================

# Use eza' at 'bat' kung naka-install, fallback sa native kung wala (prefer)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first --git'
    alias la='eza -lah --icons --group-directories-first --git'
    alias tree='eza --tree --icons'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -lh --color=auto --group-directories-first'
    alias la='ls -lah --color=auto --group-directories-first'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# Safety aliases (interactive on destructive commands)
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"

# Fast Directory Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ==========================================
# 3. ENDEAVOUROS & PACMAN / YAY MAINTENANCE
# ==========================================
alias update="yay -Syu"
alias orphans="pacman -Qtdq"
alias cleanup="yay -Sc && yay -Yc"
alias unlock="sudo rm -f /var/lib/pacman/db.lck"
alias mirrors="sudo reflector --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"

# Export installed packages to dotfiles
alias pkgexport="pacman -Qqe > ~/dotfiles/pkglist-native.txt && pacman -Qqm > ~/dotfiles/pkglist-aur.txt && flatpak list --app --columns=application > ~/dotfiles/pkglist-flatpak.txt 2>/dev/null && echo '✓ Package lists updated in ~/dotfiles/'"

# ==========================================
# 4. GIT & GPG SHORTCUTS
# ==========================================
alias gs="git status -sb"
alias ga="git add"
alias gcm="git commit -S -m"
alias gp="git push"
alias gpull="git pull"
alias gd="git diff"
alias glog="git log --show-signature --oneline --graph --decorate"
alias gkeys="gpg --list-secret-keys --keyid-format=long"

# Mabilisang pag-manage ng dotfiles repository
alias dotfiles="cd ~/dotfiles"

# ==========================================
# 5. USEFUL FUNCTIONS
# ==========================================
# Gumawa ng directory at pumasok agad
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Universal extract function
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# ==========================================
# 6. SHELL PROMPT & INITIALIZATION
# ==========================================
# Welcome screen
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# Modern CLI tools integration (FZF, Zoxide, Starship)
if command -v fzf &> /dev/null; then
    eval "$(fzf --bash)"
fi

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # Fallback colored prompt kung sakaling wala ang Starship
    PS1='\[\033[01;36m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
