#!/usr/bin/env bash

vscode_settings_file="vscode/settings.json"
vscode_settings_dir="$HOME/Library/Application Support/Code/User/"
vscode_install_cmd() {
    code --install-extension zhuangtongfa.material-theme
    code --install-extension ms-python.python
    code --install-extension vscodevim.vim
    code --install-extension esbenp.prettier-vscode
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension kamikillerto.vscode-colorize
    code --install-extension rbbit.typescript-hero
    code --install-extension gruntfuggly.todo-tree 
}
vscode_settings_cmd() { cp "$vscode_settings_file" "$vscode_settings_dir"; }
vscode_vim_cmd() {
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
}

###########################################################################

echo "VSCode"
echo "$DIVIDER"

# Install extensions
try_action "Installing extensions" vscode_install_cmd "$VSCODE_LOGFILE"

# Setup user preferences
try_action "Copying user settings" vscode_settings_cmd

# Enable key-repeating for vim plugin
try_action "Enabling key-repeating for vim plugin" vscode_vim_cmd
echo && echo
