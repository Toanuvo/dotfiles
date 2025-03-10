#apt install i3 vifm zsh kitty git bzip2 xinit neovim pip curl 
#sudo pacman -Sy --needed --noconfirm git neovim curl zsh bzip2 tmux python-pip zoxide television bat lf ripgrep
#sh -c "$(curl -fsSL: https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#echo "exec i3" > ~/.xinitrc
#echo "setxkbmap -option caps::escape" >> ~/.xinitrc
