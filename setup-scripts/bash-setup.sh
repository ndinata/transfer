#!/usr/bin/env bash

echo && echo "bash-setup.sh"

# Add the new bash to the list of allowed shells
echo "AUTH: adding the new bash to the list of allowed shells..."
sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"

# Change to the new shell
echo && echo "Changing to the new shell..."
chsh -s /usr/local/bin/bash

echo "end bash-setup.sh"
