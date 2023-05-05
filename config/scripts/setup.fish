# Install fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install pure
fisher install pure-fish/pure

# Set ripgrep config file path
set -Ux RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/ripgreprc

# Set up pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
echo "pyenv init - | source" >> $HOME/.config/fish/config.fish

# Set up rbenv
echo "status --is-interactive; and rbenv init - fish | source" >> $HOME/.config/fish/config.fish
