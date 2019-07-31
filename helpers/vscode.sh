#!/usr/bin/env bash

vscode_settings_file="vscode/settings.json"
vscode_settings_dir="$HOME/Library/Application\ Support/Code/User/"

echo "VSCode"
echo "$DIVIDER"

# Install extensions
echo -n "Installing extensions..."
code --install-extension zhuangtongfa.material-theme &> "$VSCODE_LOGFILE"
code --install-extension ms-python.python &> "$VSCODE_LOGFILE"
code --install-extension vscodevim.vim &> "$VSCODE_LOGFILE"
code --install-extension esbenp.prettier-vscode &> "$VSCODE_LOGFILE"
code --install-extension dbaeumer.vscode-eslint &> "$VSCODE_LOGFILE"
code --install-extension kamikillerto.vscode-colorize &> "$VSCODE_LOGFILE"
code --install-extension rbbit.typescript-hero &> "$VSCODE_LOGFILE"
code --install-extension gruntfuggly.todo-tree &> "$VSCODE_LOGFILE"
echo -ne "\rInstalling extensions... Done! $SUCCESS"

# Setup user preferences
echo -n "Copying user settings..."
cp "$vscode_settings_file" "$vscode_settings_dir"
echo -ne "\rCopying user settings... Done! $SUCCESS"

# Enable key-repeating for vim plugin
echo -n "Enabling key-repeating for vim plugin..."
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
echo -ne "\rEnabling key-repeating for vim plugin... Done! $SUCCESS"
echo && echo
