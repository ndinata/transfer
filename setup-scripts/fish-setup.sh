#!/usr/bin/env bash

echo && echo "fish-setup.sh"

# Copy fish function files
echo "Adding fish files..."
if [ ! -d "$HOME/.config/fish/functions/" ]; then
    mkdir -pv $HOME/.config/fish/functions/
fi
cp fishfiles/* $HOME/.config/fish/functions

# Install Fisher
echo "Installing Fisher..."
curl https://git.io/fisher --create-dirs -sLo $HOME/.config/fish/functions/fisher.fish

echo "Installing fish pure..."
fish -c "fisher add rafaelrinaldi/pure"

# Change to the new shell
# echo && echo "Changing default shell to fish..."
# chsh -s /usr/local/bin/fish

# echo && echo "Downloading fish-pure..."
# curl git.io/pure-fish --output /tmp/pure_installer.fish --location --silent

echo && echo "Creating fish directory for linking..."
mkdir -pv $HOME/.config/fish/conf.d/

# echo && echo "Remember to do something:"
# echo "1. Install the prompt by starting a fish session and typing this:"
# echo "source /tmp/pure_installer.fish; and install_pure"

# echo && echo "1. Add Brew's Python symlink location to PATH by starting a fish session and typing this:"
# echo "set -U fish_user_paths /usr/local/opt/python/libexec/bin \$fish_user_paths"
echo "Adding Brew's python symlink location to \$PATH..."
fish -c "set -U fish_user_paths /usr/local/opt/python/libexec/bin \$fish_user_paths"

# echo && echo "Enable vi keybindings on fish by typing this:"
# echo "fish_vi_key_bindings"
echo "Enabling vi keybindings on fish..."
fish -c "fish_vi_key_bindings"
echo

echo "end fish-setup.sh"

