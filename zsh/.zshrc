# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export CC=gcc

ZSH_THEME="robbyrussell"



# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

 zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
 #DISABLE_AUTO_TITLE="true"

 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git zsh-autosuggestions docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration
export QHOME="$HOME/programming/q/q"

# If you come from bash you might have to change your $PATH.
# export MANPATH="/usr/local/man:$MANPATH"
export PATH="$PATH:/home/kz/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/home/kz/.local/bin"
export PATH="$PATH:/home/kz/.cargo/bin"
export PATH="$PATH:/home/kz/.local/share/coursier/bin"
export PATH="$PATH:/usr/local/go/bin"
export EDITOR='nvim'

export ZIG_PREFIX='/home/kz/programming/zig'

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#PROMPT=%(?:%{%}➜ :%{%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)
NEWLINE=$'\n'
export PROMPT='%@ %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info) ${NEWLINE}%K{#ff0000} %k '
#export PROMPT='%@ %{$fg[cyan]%}%~%{$reset_color%} ${NEWLINE}%K{#ff0000} %k '



setopt HIST_IGNORE_DUPS
setopt HISTfindnodups

alias gpi='git config --global --add oh-my-zsh.hide-info'

alias gs='git status'
alias gu='git pull'
alias gl='git clone'
alias ta='nocorrect tmux a -t'
alias n='nvim'
alias q='rlwrap q'

PKG_DEB="sudo apt update && sudo apt install "
PKG_ARCH="sudo pacman -Sy "
PKG_ALP="apk update && apk add "

# /etc/os-release is the newer standard w/ systemd, look for that first
if [[ -f "/etc/os-release" ]] then
	DISTRO=$(cat /etc/os-release | head -n 1 | cut -d "=" -f 2 | tr '[:upper:]' '[:lower:]' | tr -d '\"')
# hostnamectl is still newer, but a nice fallback and exists on some systems not running systemd (ex: Ubuntu 14.04)
elif [[ -x "$( command -v hostnamectl )" ]] then
	DISTRO=$(hostnamectl | grep "Operating System" | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' | tr '[:upper:]' '[:lower:]')
fi

if [[ ${DISTRO} == *"arch"* ]] then
    alias get=$PKG_ARCH
elif [[ ${DISTRO} == *"manjaro"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"centos"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"fedora"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"rhel"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"debian"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"ubuntu"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"mint"* ]] then
    alias get=$PKG_DEB
elif [[ ${DISTRO} == *"artix"* ]] then
    alias get=$PKG_ARCH
elif [[ ${DISTRO} == *"alpine"* ]] then
    alias get=$PKG_ALP
fi

zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+r:|[._-]=* r:|=*' '+l:|=*'  
#:completion:* 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'  

#if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    #exec startx
#elif [[ -t 0 && $(tty) == /dev/tty1 &&  $DISPLAY ]]; then
	#exec startx
#fi


[ -f "/home/kz/.ghcup/env" ] && source "/home/kz/.ghcup/env" # ghcup-env
eval "$(zoxide init zsh)"
