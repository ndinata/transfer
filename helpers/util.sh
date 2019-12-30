#!/usr/bin/env bash

iterm_theme_dir="others/OneSnazzy.itermcolors"
iterm_theme_dl_dir="$HOME/Downloads/"
tldr_autocomplete_url="https://github.com/tldr-pages/tldr-cpp-client/blob/master/autocomplete/complete.fish"
tldr_autocomplete_path="$HOME/.config/fish/completions/tldr.fish"
bat_config_content="# Set theme to \"TwoDark\"\n--theme=\"TwoDark\""
bat_config_path="$HOME/.config/bat"
subpixel_cmd() {
   defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
}
iterm_theme_cmd() { cp "$iterm_theme_dir" "$iterm_theme_dl_dir"; }
download_tldr_cmd() { curl "$tldr_autocomplete_url" -sLo "$tldr_autocomplete_path"; }
setup_config_bat_cmd() {
  mkdir -p "$bat_config_path"
  echo -e "$bat_config_content" >> "$bat_config_path/config"
}

###########################################################################

echo_header "Utilities"
echo "$DIVIDER"

# Fix sub-pixel AA
try_action "Fixing subpixel AA" subpixel_cmd

# Copy iTerm theme 
try_action "Copying iTerm theme file to $iterm_theme_dl_dir" iterm_theme_cmd

# Download autocomplete file for `tldr`
try_action "Downloading tldr autocomplete file" download_tldr_cmd

# Setting up config file for `bat`
try_action "Setting up config file for bat" setup_config_bat_cmd
echo && echo
