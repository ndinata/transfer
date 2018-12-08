#!/usr/bin/env bash

echo && echo "cleanup.sh"

echo "Installing pytest..."
pip install -U pytest

# Setup VSCode
bash vscode-setup.sh

# Install fonts
bash font-setup.sh

# Setup new git and git-lfs
bash git-setup.sh
git lfs install

# Setup new bash environment
bash bash-setup.sh

echo "end cleanup.sh"
