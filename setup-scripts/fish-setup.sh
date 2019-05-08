#!/usr/bin/env bash

echo && echo "fish-setup.sh"

# Add the new bash to the list of allowed shells
echo "Adding fish to the list of allowed shells..."
sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"

# Change to the new shell
echo && echo "Changing default shell to fish..."
chsh -s /usr/local/bin/fish

echo && echo "Downloading fish-pure..."
curl git.io/pure-fish --output /tmp/pure_installer.fish --location --silent

echo && echo "Creating fish directory for linking..."
mkdir -pv $HOME/.config/fish/conf.d/

echo && echo "Remember to do 3 things:"
echo "1. Install the prompt by starting a fish session and typing this:"
echo "source /tmp/pure_installer.fish; and install_pure"

echo && echo "2. Add Brew's Python symlink location to PATH by starting a fish session and typing this:"
echo "set -U fish_user_paths /usr/local/opt/python/libexec/bin \$fish_user_paths"

echo && echo "3. Enable vi keybindings on fish by typing this:"
echo "fish_vi_key_bindings"
echo

echo "end fish-setup.sh"

