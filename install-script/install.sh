source ~/dotfiles/utils/spinner.sh
#==============
# Remove previous old files
#==============


sudo rm -rf ~/.vim > /dev/null 2>&1 
sudo rm -rf ~/.zshrc > /dev/null 2>&1 
sudo rm -rf ~/.config > /dev/null 2>&1 
sudo rm -rf ~/.oh-my-zsh > /dev/null 2>&1
sudo rm -rf ~/.p10k.zsh > /dev/null 2>&1 
sudo rm -rf ~/.local/state/nvim ~/.local/share/nvim > /dev/null 2>&1 
sudo rm -rf ~/.local/share/zinit > /dev/null 2>&1

#==============
# Install all the packages
#==============
echo "Installing Brew ..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &
brew doctor &
brew update &
spin $!

echo "Brewing ..."
brew bundle --file=~/dotfiles/brew/Brewfile &
spin $!

# Init stow symlinks
cd ~/dotfiles
stow .
exec zsh

# Clone plugins
tmpDir="~/dotfiles/.config/tmux/plugins/tpm"
if [ ! -d "$dir"]; then
  echo "No TPM Plugins found; Cloning them"
  git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.config/tmux/plugins/tpm
fi

tmux source ~/dotfiles/.config/tmux/tmux.conf

cd ~/dotfiles
./.config/tmux/plugins/tpm/scripts/install_plugins.sh

