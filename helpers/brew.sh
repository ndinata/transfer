#!/usr/bin/env bash

brew_install_cmd() {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
}
brew_update_cmd() { brew update && brew upgrade; }
brew_analytics_cmd() { brew analytics off; }
brew_bundle_cmd() { brew bundle; }

###########################################################################

echo "Homebrew"
echo "$DIVIDER"

# Install Homebrew
try_action "Installing Homebrew" brew_install_cmd "$BREW_LOGFILE"

# Update and upgrade Homebrew
try_action "Updating Homebrew" brew_update_cmd "$BREW_LOGFILE"

# Opt out of Homebrew's analytics
try_action "Opting out of Homebrew's analytics" brew_analytics_cmd

# Install Brewfile
try_action "Installing brew bundle" brew_bundle_cmd "$BREW_LOGFILE"
echo && echo
