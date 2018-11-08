#!/usr/bin/env bash

echo "Commence qsetup."

defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

# Install Xcode command-line tools
echo "Installing Xcode command-line tools..."
xcode-select --install

# Install Homebrew
echo "Installing Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update and upgrade Homebrew
echo "Updating Homebrew..."
brew update
brew upgrade --all

# Set up dotfiles
echo "Adding .bash_profile and .bashrc to $HOME..."
cp .bash_profile $HOME && source $HOME/.bash_profile
cp .bashrc $HOME && source $HOME/.bashrc

# Set up git
bash git-setup.sh

# Set up installations
bash install-setup.sh

echo "qsetup completed! Remember to restart for some changes to take into effect."