#!/usr/bin/env bash

echo "Sudo Operations"
echo "$DIVIDER"

# Ask for sudo permissions
echo "Please provide sudo permissions."
sudo -v

# Keep sudo "alive"
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo
echo -n "Installing Cocoapods..."
sudo gem install cocoapods &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing Cocoapods"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -ne "\rInstalling Cocoapods... Done! $SUCCESS"

# Add fish to the list of allowed shells
# This "hack" is to circumvent homebrew invalidating sudo timestamp on each install.
echo -n "Adding fish to the list of allowed shells..."
sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"
echo -ne "\rAdding fish to the list of allowed shells... Done! $SUCCESS"

# Install Homebrew
echo -n "Installing Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing Homebrew"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -ne "\rInstalling Homebrew... Done! $SUCCESS"

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
echo -ne "\rUpdating Homebrew... Done! $SUCCESS"

# Opt out of Homebrew's analytics
echo -n "Opting out of Homebrew's analytics..."
brew analytics off
echo -ne "\rOpting out of Homebrew's analytics... Done! $SUCCESS"

# Install Brewfile
echo -n "Installing tools and applications from ./Brewfile..."
brew bundle &> "$SUDO_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing brew bundles"
    errcho "Please check the generated \`$SUDO_LOGFILE\`."
    exit 1
fi
echo -ne "\rInstalling tools and applications from ./Brewfile... Done! $SUCCESS"
echo && echo
