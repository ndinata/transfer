#!/usr/bin/env bash

vscode_settings_file="vscode/settings.json"
vscode_snippets_file="vscode/react-native.code-snippets"
vscode_settings_dir="$HOME/Library/Application Support/Code/User"
vscode_snippets_dir="${vscode_settings_dir}/snippets"

vscode_install_cmd() {
    code --install-extension amatiasq.sort-imports
    code --install-extension bradlc.vscode-tailwindcss
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension EditorConfig.EditorConfig
    code --install-extension esbenp.prettier-vscode
    code --install-extension flowtype.flow-for-vscode
    code --install-extension GitHub.github-vscode-theme
    code --install-extension kamikillerto.vscode-colorize
    code --install-extension ms-python.python
    code --install-extension rust-lang.rust-analyzer
    code --install-extension vscodevim.vim
}

vscode_setup_cmd() {
    mkdir -p "$vscode_snippets_dir"
    mv "$vscode_settings_file" "${vscode_settings_dir}/"
    mv "$vscode_snippets_file" "${vscode_snippets_dir}/"
}

vscode_vim_cmd() {
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
}

###########################################################################

echo_header "VSCode"
echo "$DIVIDER"

# Install extensions
try_action "Installing extensions" vscode_install_cmd "$VSCODE_LOGFILE"

# Copy preferences and snippets file
try_action "Copying preferences and snippets" vscode_setup_cmd

# Enable key-repeating for vim plugin
try_action "Enabling key-repeating for vim plugin" vscode_vim_cmd
echo && echo
