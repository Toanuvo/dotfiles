apt install i3 vifm zsh kitty git bzip2 xinit neovim pip curl 
startx
sh -c "$(curl -fsSL: https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
echo "exec i3" > ~/.xinitrc
./install
