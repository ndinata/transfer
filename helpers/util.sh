#!/usr/bin/env bash

iterm_theme_dir="others/OneSnazzy.itermcolors"
iterm_theme_dl_dir="$HOME/Downloads/"
subpixel_cmd() {
   defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
}
iterm_theme_cmd() { cp "$iterm_theme_dir" "$iterm_theme_dl_dir"; }

###########################################################################

echo "Utilities"
echo "$DIVIDER"

# Fix sub-pixel AA
try_action "Fixing subpixel AA" subpixel_cmd

# Copy iTerm theme 
try_action "Copying iTerm theme file to $iterm_theme_dl_dir" iterm_theme_cmd
echo && echo
