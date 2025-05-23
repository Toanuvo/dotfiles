# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export CC=gcc

ZSH_THEME="robbyrussell"
hue_to_rgb() {
    local p=$1 q=$2 t=$3
    
    # Handle t < 0
    if [ $(echo "$t < 0" | bc) -eq 1 ]; then
        t=$(echo "$t + 1" | bc)
    fi
    
    # Handle t > 1
    if [ $(echo "$t > 1" | bc) -eq 1 ]; then
        t=$(echo "$t - 1" | bc)
    fi
    
    # Apply the hue to RGB conversion logic
    if [ $(echo "$t < 0.166666667" | bc) -eq 1 ]; then
        echo "scale=6; $p + ($q - $p) * 6 * $t" | bc
    elif [ $(echo "$t < 0.5" | bc) -eq 1 ]; then
        echo "$q"
    elif [ $(echo "$t < 0.666666667" | bc) -eq 1 ]; then
        echo "scale=6; $p + ($q - $p) * (0.666666667 - $t) * 6" | bc
    else
        echo "$p"
    fi
}
generate_terminal_color() {
    # Get user and hostname for unique identification
    local user=$(whoami)
    local hostname=$(cat /etc/hostname)
    local mac=$(ip link show 2>/dev/null | awk '/ether/ {print $2}' | head -1)
    local identifier="${user}${hostname}${mac}"
    
    # Create a hash from the identifier
    local hash=$(echo -n "$identifier" | shasum -a 256 | cut -c1-6)

        # Extract values for HSL generation
    local h_hex=${hash:0:4}
    local s_hex=${hash:4:4}
    local l_hex=${hash:8:4}
    
    # Convert to HSL values
    echo "hash $hash"
    h=$((16#$hash % 360))          # Hue: 0-359
    s=$((60 + (16#$hash % 40)))    # Saturation: 60-99% (vibrant colors)
    l=$((40 + (16#$hash % 35)))    # Lightness: 40-74% (readable range)
       # Normalize values
    h=$(echo "scale=6; $h / 360" | bc)
    s=$(echo "scale=6; $s / 100" | bc)
    l=$(echo "scale=6; $l / 100" | bc)
    echo "hsl: RGB(${h}, ${s}, ${l})"

        local r g b
      # Check if achromatic (s == 0)
    if [ $(echo "$s == 0" | bc) -eq 1 ]; then
        # Achromatic case - all components equal to lightness
        r=$l
        g=$l
        b=$l
    else
        # Chromatic case
        local q
        if [ $(echo "$l < 0.5" | bc) -eq 1 ]; then
            q=$(echo "scale=6; $l * (1 + $s)" | bc)
        else
            q=$(echo "scale=6; $l + $s - $l * $s" | bc)
        fi
        
        local p=$(echo "scale=6; 2 * $l - $q" | bc)
        
        # Calculate RGB components
        r=$(hue_to_rgb $p $q $(echo "scale=6; $h + 0.333333333" | bc))
        g=$(hue_to_rgb $p $q $h)
        b=$(hue_to_rgb $p $q $(echo "scale=6; $h - 0.333333333" | bc))
    fi
    
    # Convert to 0-255 range and round
    r=$(echo "scale=0; ($r * 255 + 0.5) / 1" | bc)
    g=$(echo "scale=0; ($g * 255 + 0.5) / 1" | bc)
    b=$(echo "scale=0; ($b * 255 + 0.5) / 1" | bc)
     
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
