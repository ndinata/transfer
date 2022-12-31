#!/usr/bin/env bash

fish_config_file="$HOME/.config/fish/config.fish"
# tldr_autocomplete_url="https://raw.githubusercontent.com/tldr-pages/tldr-cpp-client/master/autocomplete/complete.fish"
# tldr_autocomplete_path="$HOME/.config/fish/completions/tldr.fish"
bat_config_content="# Set theme to \"TwoDark\"\n--theme=\"TwoDark\""
bat_config_path="$HOME/.config/bat"
local_rg_config_file="dotfiles/ripgreprc"
rg_config_path="$HOME/.config/ripgrep/"

# download_tldr_cmd() { curl "$tldr_autocomplete_url" -sLo "$tldr_autocomplete_path"; }
setup_config_bat_cmd() {
  mkdir -p "$bat_config_path"
  echo -e "$bat_config_content" >> "$bat_config_path/config"
}
setup_rg_config_file_cmd() {
  mkdir -p "$rg_config_path"
  cp "$local_rg_config_file" "$rg_config_path"
  fish -c "set -Ux RIPGREP_CONFIG_PATH /Users/nico/.config/ripgrep/ripgreprc"
}

###########################################################################

echo_header "Utilities"
echo "$DIVIDER"

# Download autocomplete file for `tldr`
# try_action "Downloading tldr autocomplete file" download_tldr_cmd

# Setting up config file for `bat`
try_action "Setting up config file for bat" setup_config_bat_cmd

# Setting up config file for `ripgrep`
try_action "Setting up config file for ripgrep" setup_rg_config_file_cmd

echo && echo
