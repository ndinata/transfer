#!/usr/bin/env bash

echo && echo "vscode-setup.sh"

# Install extensions
echo "Installing extensions..."
code --install-extension zhuangtongfa.material-theme
code --install-extension ms-python.python
code --install-extension github.vscode-pull-request-github
code --install-extension vscodevim.vim
code --install-extension vscjava.vscode-java-pack

# Setup user preferences
echo && echo "Copying user settings..."
cp vscode/settings.json $HOME/Library/Application\ Support/Code/User/

# Enable key-repeating for vim plugin
echo "Enabling key-repeating..."
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

echo "end vscode-setup.sh"
