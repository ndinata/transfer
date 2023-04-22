# Set dock size
defaults write com.apple.dock tilesize -int 32

# Turn on magnification and set size
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 44

# Set windows-minimising effect
defaults write com.apple.dock mineffect -string "scale"

# Disable recent apps
defaults write com.apple.dock show-recents -bool false

# Disable auto-correct, auto-capitalisation, and auto-period substitution
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes and dashes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable tags
defaults write com.apple.finder ShowRecentTags -bool false

# Fix subpixel AA
defaults write -g CGFontRenderingFontSmoothingDisabled -bool false

# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Disable in-app reviews & video auto-play
defaults write com.apple.appstore InAppReviewEnabled -bool false
defaults write com.apple.appstore AutoPlayVideoSetting -string "off"
