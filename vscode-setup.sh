#!/usr/bin/env bash

echo && echo "vscode-setup.sh"

# Install extensions
echo "Installing extensions..."
code --install-extension zhuangtongfa.material-theme
code --install-extension ms-python.python
code --install-extension github.vscode-pull-request-github

# Setup user preferences
echo && echo "Copying user settings..."
cp settings.json $HOME/Library/Application\ Support/Code/User/

echo "end vscode-setup.sh"
