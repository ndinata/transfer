# Set ripgrep config file path
set -Ux RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/ripgreprc

# Install fisher
fisher install jorgebucaran/fisher

# Install pure
fisher install pure-fish/pure

# Set up pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
echo "pyenv init - | source" >> $HOME/.config/fish/config.fish
