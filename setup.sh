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

#########################################
# Setup Git
#########################################

echo "Let's set up git."
echo "Type in your first and last name: "
read full_name

echo "Type in your Github email address: "
read email

git config --global user.name $full_name
git config --global user.email $email

echo "Git is all set!"
