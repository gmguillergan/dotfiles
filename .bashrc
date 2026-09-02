#
# ~/.bashrc
# @author chanchanjeu
# Creation Date: 2025/12/27
# Last Modified: 2026/09/02
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

# Use eza and bat if installed, fallback to native commands if missing
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

# Bash configuration helpers
alias reload='source ~/.bashrc && echo "✓ ~/.bashrc reloaded!"'
alias bashrc='$EDITOR ~/.bashrc'

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

# Clean package caches safely (retains last 2 versions for downgrade rollback)
clean-cache() {
    echo ":: Trimming Pacman and Yay caches..."
    if command -v paccache &> /dev/null; then
        echo "-> Trimming official repo cache (/var/cache/pacman/pkg)..."
        sudo paccache -rk2

        if [ -d "$HOME/.cache/yay" ]; then
            echo "-> Trimming Yay AUR cache (~/.cache/yay)..."
            paccache -rk2 -c "$HOME/.cache/yay"
        fi
    else
        echo "-> 'pacman-contrib' not found. Falling back to standard cleanup..."
        yay -Sc --noconfirm
    fi

    echo "-> Removing unneeded build/clean dependencies..."
    yay -Yc --noconfirm

    echo "✓ Package cache cleanup complete!"
}


# Export installed packages to dotfiles
alias pkgexport="pacman -Qqe > ~/dotfiles/pkglist-native.txt && pacman -Qqm > ~/dotfiles/pkglist-aur.txt && flatpak list --app --columns=application > ~/dotfiles/pkglist-flatpak.txt 2>/dev/null && echo '✓ Package lists updated in ~/dotfiles/'"

# Disk usage shortcuts
alias df='df -h'
alias du='du -h'

if command -v dust &> /dev/null; then
    alias du='dust'
fi

# ==========================================
# 4. GIT & GPG SHORTCUTS
# ==========================================
# Git
alias gs="git status -sb"
alias ga="git add"
alias gcm="git commit -S -m"
alias gp="git push"
alias gpull="git pull"
alias gd="git diff"
alias glog="git log --show-signature --oneline --graph --decorate"
alias gkeys="gpg --list-secret-keys --keyid-format=long"
alias gq="echo 'gs=\"git status -sb\"'; echo 'ga=\"git add\"'; echo 'gcm=\"git commit -S -m\"'; echo 'gp=\"git push\"'; echo 'gpull=\"git pull\"'; echo 'gd=\"git diff\"'; echo 'glog=\"git log --show-signature --oneline --graph --decorate\"'; echo 'gkeys=\"gpg --list-secret-keys --keyid-format=long\"'"
alias gc="git checkout"
alias gf="git fetch"
alias gfu="git fetch upstream"
alias gpullu="git pull upstream"
alias gundo="git reset --soft HEAD~1"
alias gstash="git stash"
alias gstashp="git stash pop"
alias gb="git branch"

# Dotfiles
alias dotfiles="cd ~/dotfiles"

# GPG Testing & Management
alias gpg-test="echo 'test' | gpg --clearsign"
alias gpg-restart="gpgconf --kill gpg-agent && gpgconf --launch gpg-agent && echo '✓ GPG Agent reloaded!'"

# Usage: gpg-encrypt-to <recipient> <file> [asc|gpg]
gpg-encrypt-to() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: gpg-encrypt-to <recipient_email_or_keyid> <file> [asc|gpg]"
        return 1
    fi

    local recipient="$1"
    local file="$2"
    local mode="${3:-gpg}"

    if [ ! -f "$file" ]; then
        echo "Error: File not found: '$file'"
        return 1
    fi

    case "$mode" in
        asc)
            gpg --armor --encrypt --recipient "$recipient" "$file" && \
            echo "✓ Encrypted as ${file}.asc for: $recipient"
            ;;
        gpg)
            gpg --encrypt --recipient "$recipient" "$file" && \
            echo "✓ Encrypted as ${file}.gpg for: $recipient"
            ;;
        *)
            echo "Invalid format! Choose either 'asc' or 'gpg' (Default: gpg)"
            return 1
            ;;
    esac
}

# Usage: gpg-encrypt-self <file> [asc|gpg]
gpg-encrypt-self() {
    if [ "$#" -lt 1 ]; then
        echo "Usage: gpg-encrypt-self <file> [asc|gpg]"
        return 1
    fi

    local file="$1"
    local mode="${2:-gpg}"

    if [ ! -f "$file" ]; then
        echo "Error: File not found: '$file'"
        return 1
    fi

    case "$mode" in
        asc)
            gpg --armor --encrypt --default-recipient-self "$file" && \
            echo "✓ Encrypted as ${file}.asc using your key."
            ;;
        gpg)
            gpg --encrypt --default-recipient-self "$file" && \
            echo "✓ Encrypted as ${file}.gpg using your key."
            ;;
        *)
            echo "Invalid format! Choose either 'asc' or 'gpg' (Default: gpg)"
            return 1
            ;;
    esac
}

# Usage: gpg-decrypt <file.asc|file.gpg>
gpg-decrypt() {
    if [ -z "$1" ]; then
        echo "Usage: gpg-decrypt <file.gpg|file.asc>"
        return 1
    fi

    local out="${1%.asc}"
    out="${out%.gpg}"

    if [ "$out" = "$1" ]; then
        out="${1}.decrypted"
    fi

    gpg --output "$out" --decrypt "$1" && echo "✓ Decrypted as: $out"
}

# ==========================================
# 5. USEFUL FUNCTIONS
# ==========================================
# Create directory and switch to it immediately
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Universal archive extraction tool
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
   echo " " && echo "==========" && fastfetch --logo none && echo "==========" && echo " "

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
    # Fallback colored prompt if Starship is unavailable
    PS1='\[\033[01;36m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# ==========================================
# 7. NETWORK UTILITIES
# ==========================================
alias myip="curl -s ifconfig.me && echo"

# Ping with limit
alias ping='ping -c 5'
