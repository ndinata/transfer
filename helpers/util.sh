#!/usr/bin/env bash

tldr_autocomplete_url="https://raw.githubusercontent.com/tldr-pages/tldr-cpp-client/master/autocomplete/complete.fish"
tldr_autocomplete_path="$HOME/.config/fish/completions/tldr.fish"
bat_config_content="# Set theme to \"TwoDark\"\n--theme=\"TwoDark\""
bat_config_path="$HOME/.config/bat"

download_tldr_cmd() { curl "$tldr_autocomplete_url" -sLo "$tldr_autocomplete_path"; }
setup_config_bat_cmd() {
  mkdir -p "$bat_config_path"
  echo -e "$bat_config_content" >> "$bat_config_path/config"
}

###########################################################################

echo_header "Utilities"
echo "$DIVIDER"

# Download autocomplete file for `tldr`
try_action "Downloading tldr autocomplete file" download_tldr_cmd

# Setting up config file for `bat`
try_action "Setting up config file for bat" setup_config_bat_cmd
echo && echo
