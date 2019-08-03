#!/usr/bin/env bash

echo "Sudo Operations"
echo "$DIVIDER"

# Ask for sudo permissions
echo "Please provide sudo permissions."
sudo -v

# Keep sudo "alive"
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo
echo -n "Installing Cocoapods..."
sudo gem install cocoapods &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing Cocoapods"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -e "\rInstalling Cocoapods... Done! $SUCCESS"

# Add fish to the list of allowed shells
# This "hack" is to circumvent homebrew invalidating sudo timestamp on each install.
echo -n "Adding fish to the list of allowed shells..."
sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"
echo -e "\rAdding fish to the list of allowed shells... Done! $SUCCESS"
echo && echo
