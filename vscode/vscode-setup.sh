#!/usr/bin/env bash

vscode_settings_file="./settings.json"
vscode_snippets_file="./react-native.code-snippets"
vscode_settings_dir="$HOME/Library/Application Support/Code/User"
vscode_snippets_dir="${vscode_settings_dir}/snippets"

# Install extensions
code --install-extension zhuangtongfa.material-theme
code --install-extension ms-python.python
code --install-extension vscodevim.vim
code --install-extension flowtype.flow-for-vscode
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension kamikillerto.vscode-colorize
code --install-extension gruntfuggly.todo-tree
code --install-extension coenraads.bracket-pair-colorizer-2

# Copy user preferences and snippets file
mkdir -p "$vscode_snippets_dir"
mv "$vscode_settings_file" "${vscode_settings_dir}/"
mv "$vscode_snippets_file" "${vscode_snippets_dir}/"
