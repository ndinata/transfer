#!/usr/bin/env bash

echo "Installing VS Code..."
brew cask install visual-studio-code

# Install extensions
echo "Installing VS Code extensions..."
code --install-extension zhuangtongfa.material-theme
code --install-extension ms-python.python
