#!/usr/bin/env bash

echo "Homebrew"
echo "$DIVIDER"

# Install Homebrew
echo -n "Installing Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing Homebrew"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -e "\rInstalling Homebrew... Done! $SUCCESS"

# Update and upgrade Homebrew
echo -n "Updating Homebrew..."
brew update &> "$SUDO_LOGFILE"
brew upgrade &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when updating Homebrew"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -e "\rUpdating Homebrew... Done! $SUCCESS"

# Opt out of Homebrew's analytics
echo -n "Opting out of Homebrew's analytics..."
brew analytics off
echo -e "\rOpting out of Homebrew's analytics... Done! $SUCCESS"

# Install Brewfile
echo -n "Installing tools and applications from ./Brewfile..."
brew bundle &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing brew bundles"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -e "\rInstalling tools and applications from ./Brewfile... Done! $SUCCESS"
echo && echo
