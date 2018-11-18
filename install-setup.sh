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

# Install GitHub Desktop
echo "Installing GitHub Desktop..."
brew cask install github

# Install Franz
echo "Installing Franz..."
brew cask install franz

# Install VSCode
bash vscode-setup.sh

# Install Rocket
echo "Installing Rocket..."
brew cask install rocket

# Install Firefox
echo "Installing Firefox..."
brew cask install firefox

# Install Cryptomator
echo "Installing Cryptomator..."
brew cask install cryptomator

# Install Spotify
echo "Installing Spotify..."
brew cask install spotify

# Install Dash
echo "Installing Dash..."
brew cask install dash

# Install Discord
echo "Installing Discord..."
brew cask install discord

# Install Slack
echo "Installing Slack..."
brew cask install slack

# Install Flock
echo "Installing Flock..."
mas install 883594849

# Install 1Password 7
echo "Installing 1Password..."
mas install 1333542190

# Install Pages
echo "Installing Pages..."
mas install 409201541

# Install Numbers
echo "Installing Numbers..."
mas install 409203825

# Install Keynote
echo "Installing Keynote..."
mas install 409183694

# Install Magnet
echo "Installing Magnet..."
mas install 441258766

# Install Garageband
echo "Installing Garageband..."
mas install 682658836

# Install Xcode
echo "Installing Xcode..."
mas install 497799835

####################################
# Install binary commands
####################################

brew install nano
brew install wget
brew install python
pip3 install -U pytest


# Cleanup
brew update && brew upgrade && brew cleanup && brew doctor

echo "install-setup is done!"
