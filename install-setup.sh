#!/usr/bin/env bash

printf "\n------------------------\n"
echo "Commence install-setup."

####################################
# Install GUI applications
####################################

# Install Dropbox
echo "Brew cask | Installing Dropbox..."
brew cask install dropbox

# Install Franz
echo "Brew cask | Installing Franz..."
brew cask install franz

# Install VSCode
echo "Brew cask | Installing VScode..."
brew cask install visual-studio-code
bash vscode-setup.sh

# Install Rocket
echo "Brew cask | Installing Rocket..."
brew cask install rocket

# Install Firefox
echo "Brew cask | Installing Firefox..."
brew cask install firefox

# Install Cryptomator
echo "Brew cask | Installing Cryptomator..."
brew cask install cryptomator

# Install Spotify
echo "Brew cask | Installing Spotify..."
brew cask install spotify

# Install Dash
echo "Brew cask | Installing Dash..."
brew cask install dash

# Install Discord
echo "Brew cask | Installing Discord..."
brew cask install discord

# Install Slack
echo "Brew cask | Installing Slack..."
brew cask install slack

# Install VLC
echo "Brew cask | Installing VLC..."
brew cask install vlc

# Install Mac App Store CLI
echo "MAS       | Installing MAS..."
brew install mas

# Install Flock
echo "MAS       | Installing Flock..."
mas install 883594849

# Install 1Password 7
echo "MAS       | Installing 1Password..."
mas install 1333542190

# Install Pages
echo "MAS       | Installing Pages..."
mas install 409201541

# Install Numbers
echo "MAS       | Installing Numbers..."
mas install 409203825

# Install Keynote
echo "MAS       | Installing Keynote..."
mas install 409183694

# Install Magnet
echo "MAS       | Installing Magnet..."
mas install 441258766

# Install Garageband
echo "MAS       | Installing Garageband..."
mas install 682658836

# Install Xcode
echo "MAS       | Installing Xcode..."
mas install 497799835

####################################
# Install binary commands
####################################

echo "Installing binary commands/utilities..."
brew install git
brew install nano
brew install wget

brew install python
pip3 install -U pytest

echo "Installing Bash, sudo incoming!"
printf "\a"; printf "\a"; printf "\a";
brew install bash
bash bash-setup.sh

echo "install-setup is done!"
