#!/usr/bin/env bash

echo "Utilities"
echo "$DIVIDER"

# Fix sub-pixel AA
echo -n "Fixing subpixel AA..."
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
echo -e "\rFixing subpixel AA... Done! $SUCCESS"

# Copy iTerm theme 
echo -n "Copying iTerm theme file to ~/Downloads..."
cp others/OneSnazzy.itermcolors $HOME/Downloads/
echo -e "\rCopying iTerm theme file to ~/Downloads... Done! $SUCCESS"
echo && echo
