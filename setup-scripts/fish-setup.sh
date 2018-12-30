#!/usr/bin/env bash

echo && echo "fish-setup.sh"

# Add the new bash to the list of allowed shells
echo "Adding fish to the list of allowed shells..."
sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"

# Change to the new shell
echo && echo "Changing default shell to fish..."
chsh -s /usr/local/bin/fish

echo "Remember to add Brew's Python symlink location to PATH!"
echo "Fire up a fish session and type this:"
echo && echo "set -U fish_user_paths /usr/local/opt/python/libexec/bin \$fish_user_paths"
echo

echo "end fish-setup.sh"
