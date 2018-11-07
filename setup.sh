#!/usr/bin/env bash

echo "Commence qsetup."

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

# Install Mac App Store CLI
echo "Installing MAS..."
brew install mas

# Set up git
bash git-setup.sh
