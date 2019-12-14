#!/usr/bin/env bash

vscode_setup_cmd() {
    cp "vscode/settings.json" "$HOME/Desktop"
    cp "vscode/vscode-setup.sh" "$HOME/Desktop" 
    cp "vscode/react-native.code-snippets" "$HOME/Desktop"
}

vscode_vim_cmd() {
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
}

###########################################################################

echo_header "VSCode"
echo "$DIVIDER"

# Copy VS Code setup script to ~/Desktop
try_action "Copying setup scripts to Desktop" vscode_setup_cmd

# Enable key-repeating for vim plugin
try_action "Enabling key-repeating for vim plugin" vscode_vim_cmd
echo && echo
