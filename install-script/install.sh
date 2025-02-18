source ~/dotfiles/utils/spinner.sh
#==============
# Remove previous old files
#==============

sudo rm -rf ~/.vim >/dev/null 2>&1
sudo rm -rf ~/.zshrc >/dev/null 2>&1
sudo rm -rf ~/.config >/dev/null 2>&1
sudo rm -rf ~/.local/state/nvim ~/.local/share/nvim >/dev/null 2>&1
sudo rm -rf ~/.local/share/zinit >/dev/null 2>&1

#==============
# Install all the packages
#==============
echo "Installing Brew ..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(
  echo
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >>/Users/maxime.cappellen/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew doctor
brew update
brew install gum

gum spin --spinner dot --title "Bundling the Brewfile ..." -- brew bundle --file=~/dotfiles/brew/Brewfile

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
