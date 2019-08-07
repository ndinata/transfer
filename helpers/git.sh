#!/usr/bin/env bash

gitconfig_dir="dotfiles/.gitconfig"
gitconfig_cmd() { cp "$gitconfig_dir" $HOME; }
git_lfs_cmd() { git lfs install; }

###########################################################################

echo_header "Git"
echo "$DIVIDER"

# Copy gitconfig
try_action "Copying .gitconfig" gitconfig_cmd

# Setup git lfs
try_action "Setting up git lfs" git_lfs_cmd "$GIT_LOGFILE"
echo && echo
