#!/usr/bin/env bash

echo "Installing VS Code..."
brew cask install visual-studio-code

# Install extensions
echo "Installing VS Code extensions..."
code --install-extension zhuangtongfa.material-theme
code --install-extension ms-python.python
code --install-extension github.vscode-pull-request-github

# Setup user preferences
echo "Copying user settings..."
cp settings.json $HOME/Library/Application\ Support/Code/User/