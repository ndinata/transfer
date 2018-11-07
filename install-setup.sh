#!/usr/bin/env bash

printf "\n------------------------\n"
echo "Commence install-setup."

# Install Mac App Store CLI
echo "Installing MAS..."
brew install mas

####################################
# Install GUI applications
####################################

# Install Dropbox
echo "Installing Dropbox..."
brew cask install dropbox

# Install Franz
echo "Installing Franz..."
brew cask install franz

# Install VSCode
bash vscode-setup.sh

####################################
# Install binary commands
####################################

echo "Installing binary commands..."
brew install bash
brew install nano
brew install wget
brew install python


# Cleanup
brew update && brew upgrade && brew cleanup && brew doctor

echo "install-setup is done!"
printf "------------------------\n"
