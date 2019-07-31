#!/usr/bin/env bash

NAME="qsetup"
SCRIPT_NAME="setup"
LOGFILE_DIR="$HOME/Desktop/${NAME}_logfiles"
SUDO_LOGFILE="$LOGFILE_DIR/sudo.txt"
VSCODE_LOGFILE="$LOGFILE_DIR/vscode.txt"
FONT_LOGFILE="$LOGFILE_DIR/fonts.txt"
GIT_LOGFILE="$LOGFILE_DIR/git.txt"
VIM_LOGFILE="$LOGFILE_DIR/vim.txt"
FISH_LOGFILE="$LOGFILE_DIR/fish.txt"
CLEANUP_LOGFILE="$LOGFILE_DIR/cleanup.txt"

# Colourful output
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
NC='\033[0m'
SUCCESS="${GREEN}✔${NC}"
ERROR="${RED}Error${NC}"
ARROW="${BLUE}===>${NC}"
DIVIDER="------------------------"

###########################################################################

errcho() { >&2 echo -e "$@"; }

###########################################################################

# Check if prerequisites for the script are satisfied
source helpers/intro.sh

# Carry out operations with sudo upfront to prevent further user interaction
source helpers/all_sudo.sh

# Setup VSCode
source helpers/vscode.sh

# Install extra fonts
source helpers/fonts.sh

# Setup git and git-lfs
source helpers/git.sh

# Setup vim
source helpers/vim.sh

# Setup fish
source helpers/fish.sh

# Run general utility stuff
source helpers/util.sh

# Cleanup
echo "$DIVIDER"
echo -n "Cleaning up..."
(brew update && brew upgrade && brew cleanup && brew doctor) &> "$CLEANUP_LOGFILE"
echo -ne "\rCleaning up... Done! $SUCCESS"
echo

echo "Please remember to set fish as the default shell by running:"
echo
echo "    chsh -s /usr/local/bin/fish"
echo
echo "$NAME completed! Remember to restart for some changes to take into effect."
