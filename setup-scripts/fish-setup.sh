#!/usr/bin/env bash

echo && echo "fish-setup.sh"

# Add the new bash to the list of allowed shells
echo "Adding fish to the list of allowed shells..."
sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"

# Change to the new shell
echo && echo "Changing default shell to fish..."
chsh -s /usr/local/bin/fish

echo "end fish-setup.sh"
