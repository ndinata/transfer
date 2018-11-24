#!/usr/bin/env bash

echo "Commence qsetup."
echo "Before we proceed, please sign in to the Mac App Store for mas-cli to work."
echo "Ready to go? [yes|no]"
read -p "[no] >>> "
if [[ $REPLY =~ ^[yY] ]]; then
    echo "Nice, let's continue."
else
    echo "Cannot proceed until you have signed in. Please try again."
    exit 1
fi

echo "Also, another thing. You need to have installed Xcode command-line tools."
echo "You can do so by opening a new Terminal instance and running:"
echo "      xcode-select --install"
echo "Ready to go? [yes|no]"
read -p "[no] >>> "
if [[ $REPLY =~ ^[yY] ]]; then
    echo "That's it. Let's go!"
else
    echo "Cannot proceed until you have downloaded the command-line tools. Please try again."
    exit 1
fi

# Fix sub-pixel AA
echo "Fixing subpixel AA..."
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

# Install Homebrew
echo "Homebrew  | Installing Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update and upgrade Homebrew
echo "Homebrew  | Updating Homebrew..."
brew update
brew upgrade --all

# Opt out of Homebrew's analytics
echo "Homebrew  | Opting out of Homebrew's analytics..."
brew analytics off

# Set up dotfiles
echo "Adding .bash_profile and .bashrc to $HOME..."
cp .bash_profile $HOME && source $HOME/.bash_profile
cp .bashrc $HOME && source $HOME/.bashrc

# Set up installations
bash install-setup.sh

# Install fonts
bash font-setup.sh

# Cleanup
brew update && brew upgrade && brew cleanup && brew doctor

echo "qsetup completed! Remember to restart for some changes to take into effect."
