#!/usr/bin/env bash

# Install extensions
echo "    VScode | Installing extensions..."
code --install-extension zhuangtongfa.material-theme
code --install-extension ms-python.python
code --install-extension github.vscode-pull-request-github

# Setup user preferences
echo "    VScode | Copying user settings..."
cp settings.json $HOME/Library/Application\ Support/Code/User/
