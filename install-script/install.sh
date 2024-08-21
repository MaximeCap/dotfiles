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
