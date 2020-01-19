#!/usr/bin/env bash

config_dock() {
  # Set dock size
  defaults write com.apple.dock tilesize -int 28

  # Turn on magnification
  defaults write com.apple.dock magnification -bool true

  # Set magnified size
  defaults write com.apple.dock largesize -int 38

  # Set orientation to left of screen
  defaults write com.apple.dock orientation -string "left"

  # Set windows-minimising effect
  defaults write com.apple.dock mineffect -string "scale"

  # Disable recent apps
  defaults write com.apple.dock show-recents -bool false
}

config_keyboard() {
  # Disable auto-correct
  defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

  # Disable auto-capitalisation
  defaults write -g NSAutomaticCapitalizationEnabled -bool false

  # Disable automatic period substitution
  defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

  # Disable smart quotes
  defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

  # Disable smart dashes
  defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
}

config_finder() {
  # Set sidebar icon size to 'Small'
  defaults write -g NSTableViewDefaultSizeMode -int 1

  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Disable tags
  defaults write com.apple.finder ShowRecentTags -bool false

  # Fix subpixel AA
  defaults write -g CGFontRenderingFontSmoothingDisabled -bool false
}

###########################################################################

echo_header "macOS Config"
echo "$DIVIDER"

# Configure Dock
try_action "Configuring Dock settings" config_dock

# Configure Finder
try_action "Configuring Finder settings" config_finder

# Configure keyboard
try_action "Configuring keyboard settings" config_keyboard
echo && echo

