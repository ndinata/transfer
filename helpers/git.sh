#!/usr/bin/env bash

gitconfig_cmd() { cp dotfiles/.gitconfig $HOME; }

###########################################################################

echo_header "Git"
echo "$DIVIDER"

# Copy gitconfig
try_action "Copying .gitconfig" gitconfig_cmd

echo && echo
