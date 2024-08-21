#==============
# Remove previous old files
#==============

sudo rm -rf ~/.vim > /dev/null 2>&1
sudo rm -rf ~/.zshrc > /dev/null 2>&1
sudo rm -rf ~/.config > /dev/null 2>&1
sudo rm -rf ~/.p10k.zsh > /dev/null 2>&1

#==============
# Install all the packages
#==============
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor
brew update

brew bundle --file=~/dotfiles/brew/Brewfile

# Init stow symlinks
cd ~/dotfiles
stow .
