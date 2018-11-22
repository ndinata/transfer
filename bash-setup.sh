#!/usr/bin/env bash

# Add the new bash to the list of allowed shells
echo "    Bash  | Adding the new bash to the list of allowed shells. Authentication required."
sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"

# change to the new shell
echo "    Bash  | Changing to the new shell..."
chsh -s /usr/local/bin/bash
