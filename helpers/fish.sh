#!/usr/bin/env bash

fish_function_dir="$HOME/.config/fish/functions"
fishfiles_dir="fishfiles"
fisher_install_dir="$HOME/.config/fish/functions/fisher.fish"
fish_function_cmd() {
    if [ ! -d "$fish_function_dir/" ]; then
        mkdir -pv $fish_function_dir
    fi
    cp $fishfiles_dir/* $fish_function_dir
}
fisher_install_cmd() {
    curl https://git.io/fisher --create-dirs -sLo "$fisher_install_dir"
}
fish_pkg_install_cmd() {
    fish -c "fisher install rafaelrinaldi/pure" 
    fish -c "fisher install jorgebucaran/nvm.fish" 
}
fish_python_cmd() {
    fish -c "set -U fish_user_paths /usr/local/opt/python@3.9/libexec/bin \$fish_user_paths" 
}

###########################################################################

echo_header "Fish"
echo "$DIVIDER"

# Copy fish function files
try_action "Adding fish function files" fish_function_cmd

# Install Fisher
try_action "Installing Fisher" fisher_install_cmd "$FISH_LOGFILE"

# Install fish packages
try_action "Installing fish packages" fish_pkg_install_cmd "$FISH_LOGFILE"

# Setup fish PATH
try_action "Adding Brew's python symlink location to \$PATH" fish_python_cmd
echo && echo
