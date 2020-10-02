#!/usr/bin/env bash

gitconfig_dir="dotfiles/.gitconfig"
gitconfig_cmd() { cp "$gitconfig_dir" $HOME; }

###########################################################################

echo_header "Git"
echo "$DIVIDER"

# Copy gitconfig
try_action "Copying .gitconfig" gitconfig_cmd

echo && echo
