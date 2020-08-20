#!/usr/bin/env bash

fish_cmd() { sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"; }

###########################################################################

echo_header "Sudo Operations"
echo "$DIVIDER"

# Ask for sudo permissions
echo "Please provide sudo permissions."
sudo -v

# Keep sudo "alive"
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo

# Add fish to the list of allowed shells
# This "hack" is to circumvent homebrew invalidating sudo timestamp on each install.
try_action "Adding fish to the list of allowed shells" fish_cmd
echo && echo
