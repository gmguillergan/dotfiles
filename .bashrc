#
# ~/.bashrc
# @author chanchanjeu
# Creation Date: 2025/12/27
# Last Modified: 2026/08/20
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ==========================================
# 1. ENVIRONMENT & GPG
# ==========================================
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nano' # o 'vim'/'nano' kung ano gamit mo
export GPG_TTY=$(tty)

# ==========================================
# 2. COLORED & CLEAN PS1 PROMPT
# ==========================================
# May kulay (Cyan user, Green host, Blue folder) + Git branch indicator
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Kulay definitions
C_CYAN='\[\033[01;36m\]'
C_GREEN='\[\033[01;32m\]'
C_BLUE='\[\033[01;34m\]'
C_PURPLE='\[\033[01;35m\]'
C_RESET='\[\033[00m\]'

PS1="${C_CYAN}\u${C_RESET}@${C_GREEN}\h${C_RESET}:${C_BLUE}\w${C_PURPLE}\$(parse_git_branch)${C_RESET}\$ "

# ==========================================
# 3. SAFETY & CONVENIENCE ALIASES
# ==========================================
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"

# Colored outputs
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh --color=auto --group-directories-first'
alias la='ls -lah --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ==========================================
# 4. ARCH / ENDEAVOUROS (PACMAN & YAY)
# ==========================================
alias update="yay -Syu"
alias orphans="pacman -Qtdq"
alias cleanup="yay -Sc && yay -Yc"

# ==========================================
# 5. GIT & GPG SHORTCUTS
# ==========================================
alias gs="git status -sb"
alias ga="git add"
alias gcm="git commit -S -m"      # Signed commit gamit ang GPG
alias gp="git push"
alias glog="git log --show-signature --oneline --graph --decorate"
alias gkeys="gpg --list-secret-keys --keyid-format=long"

# ==========================================
# 6. HELPFUL UTILITY FUNCTIONS
# ==========================================
# Gumawa ng folder at pumasok agad sa loob
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Auto extract kahit anong archive format
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
# 7. WELCOME SCREEN (FASTFETCH)
# ==========================================
# Kung naka-install ang fastfetch o neofetch
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

eval "$(starship init bash)"
