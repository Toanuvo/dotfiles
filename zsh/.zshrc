# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export CC=gcc

ZSH_THEME="robbyrussell"

generate_terminal_color() {
    # Get user and hostname for unique identification
    local user=$(whoami)
    local hostname=$(hostname -s)
    local identifier="${user}@${hostname}"
    
    # Create a hash from the identifier
    local hash=$(echo -n "$identifier" | shasum -a 256 | cut -c1-6)

        # Extract values for HSL generation
    local h_hex=${hash:0:4}
    local s_hex=${hash:4:4}
    local l_hex=${hash:8:4}
    
    # Convert to HSL values
    h=$((16#$h_hex % 360))          # Hue: 0-359
    s=$((60 + (16#$s_hex % 40)))    # Saturation: 60-99% (vibrant colors)
    l=$((40 + (16#$l_hex % 35)))    # Lightness: 40-74% (readable range)
       # Normalize values
    h=$((h % 360))
    s=$(echo "scale=2; $s / 100" | bc)
    l=$(echo "scale=2; $l / 100" | bc)
    
    local c=$(echo "scale=2; (1 - sqrt(($l * 2 - 1)^2)) * $s" | bc -l)
    local x=$(echo "scale=2; $c * (1 - sqrt(((($h / 60) % 2) - 1)^2))" | bc -l)
    local m=$(echo "scale=2; $l - $c / 2" | bc)
    
    if [ $h -lt 60 ]; then
        r=$c; g=$x; b=0
    elif [ $h -lt 120 ]; then
        r=$x; g=$c; b=0
    elif [ $h -lt 180 ]; then
        r=0; g=$c; b=$x
    elif [ $h -lt 240 ]; then
        r=0; g=$x; b=$c
    elif [ $h -lt 300 ]; then
        r=$x; g=0; b=$c
    else
        r=$c; g=0; b=$x
    fi
    
    # Convert to 0-255 range
    r=$(echo "scale=0; ($r + $m) * 255" | bc)
    g=$(echo "scale=0; ($g + $m) * 255" | bc)
    b=$(echo "scale=0; ($b + $m) * 255" | bc)
    
    # Remove decimal points and ensure integers
    r=${r%.*}; g=${g%.*}; b=${b%.*}
    r=${r:-0}; g=${g:-0}; b=${b:-0} 
    r=$(( r > 255 ? 255 : r ))
    g=$(( g > 255 ? 255 : g ))
    b=$(( b > 255 ? 255 : b ))
    
    # Set terminal colors using ANSI escape sequences
    # This sets the background and text colors
    #printf "\033]11;rgb:%02x/%02x/%02x\007" $((r/4)) $((g/4)) $((b/4))  # Background (darker)
    #printf "\033]10;rgb:%02x/%02x/%02x\007" $r $g $b                      # Foreground (brighter)
    
    
    # Also set the prompt color to match
    export COLOR_ID=$(printf "#%02x%02x%02x" $r $g $b)
    
    # Optional: Display the color info
    echo "Terminal color set for ${identifier}: RGB(${r}, ${g}, ${b})"
}
generate_terminal_color



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
# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# # initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

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
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

export EDITOR='nvim'

export ZIG_PREFIX='/home/kz/programming/zig'

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#PROMPT=%(?:%{%}➜ :%{%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)
NEWLINE=$'\n'
export PROMPT='%@ %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info) ${NEWLINE}%K{$COLOR_ID} %k '
#export PROMPT='%@ %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info) ${NEWLINE}%K{#ff0000} %k '
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

PKG_DEB="sudo apt update && sudo apt install -y "
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
eval "$(tv init zsh)"


. "$HOME/.local/bin/env"
