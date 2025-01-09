### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/maxime.cappellen/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
fish_add_path /opt/homebrew/bin
set -gx nvm_data /opt/homebrew/opt/nvm

set -x IS_THALES false

# Starship
starship init fish | source

# Caparace
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
mkdir -p ~/.config/fish/completions
carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish # disable auto-loaded completions (#185)
carapace _carapace | source
zoxide init --cmd cd fish | source
set -gx PATH $PATH $HOME/.krew/bin

alias k="kubectl"
alias n="nvim"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
