#!/usr/bin/env bash

fish_function_dir="$HOME/.config/fish/functions"
fish_config_file="$HOME/.config/fish/config.fish"
fishfiles_dir="fishfiles"
fisher_install_dir="$HOME/.config/fish/functions/fisher.fish"
fish_function_cmd() {
    if [ ! -d "$fish_function_dir/" ]; then
        mkdir -pv $fish_function_dir
    fi
    cp $fishfiles_dir/* $fish_function_dir
}
fisher_install_cmd() {
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
}
fish_pkg_install_cmd() {
    fish -c "fisher install rafaelrinaldi/pure"
    # fish -c "fisher install jorgebucaran/nvm.fish"
    # fish -c "fisher install wfxr/forgit"
}
fish_python_cmd() {
    fish -c "fish_add_path /opt/homebrew/opt/python@3.10/libexec/bin"
}
# fish_forgit_cmd() {
#   echo "set -x FORGIT_FZF_DEFAULT_OPTS \"\$FORGIT_FZF_DEFAULT_OPTS --reverse --cycle\"" >> "$fish_config_file"
#   echo "set -x FORGIT_LOG_GRAPH_ENABLE true" >> "$fish_config_file"
# }

###########################################################################

echo_header "Fish"
echo "$DIVIDER"

# Copy fish function files
try_action "Adding fish function files" fish_function_cmd

# Install Fisher
try_action "Installing Fisher" fisher_install_cmd "$FISH_LOGFILE"

# Install fish packages
try_action "Installing fish packages" fish_pkg_install_cmd "$FISH_LOGFILE"

# Setup fish Python PATH
try_action "Adding Brew's python symlink location to \$PATH" fish_python_cmd

# Set up custom options for forgit
# try_action "Setting up custom options for forgit" fish_forgit_cmd "$FISH_LOGFILE"
echo && echo
