#!/usr/bin/env bash

NAME="Wake"
SCRIPT_NAME="wake"
IS_SHOWCASE_MODE=false
SHOWCASE_FLAG_LONG="^--showcase$"
SHOWCASE_FLAG_SHORT="^-s$"
LOGFILE_DIR="$HOME/Desktop/${NAME}_logfiles"
SUDO_LOGFILE="$LOGFILE_DIR/sudo.txt"
BREW_LOGFILE="$LOGFILE_DIR/brew.txt"
VSCODE_LOGFILE="$LOGFILE_DIR/vscode.txt"
FONT_LOGFILE="$LOGFILE_DIR/fonts.txt"
GIT_LOGFILE="$LOGFILE_DIR/git.txt"
VIM_LOGFILE="$LOGFILE_DIR/vim.txt"
FISH_LOGFILE="$LOGFILE_DIR/fish.txt"

# Colourful output
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
NC='\033[0m'
SUCCESS="${GREEN}✔${NC}"
FAIL="${RED}✖${NC}"
ERROR="${RED}Error${NC}"
# ARROW="${BLUE}===>${NC}"
DIVIDER="-------------------------------"

###########################################################################

errcho() { >&2 echo -e "$@"; }

echo_header() { echo -e "${BLUE}$@${NC}"; }

# $1: message to be printed on the console while the action is running
# $2: action to be carried out
# $3: logfile to send output of action to (required if error-handling is needed)
try_action() {
    echo -n "$1..."

    # only redirect output of action if a logfile is supplied
    if [[ -z $3 ]]; then
        if [[ $IS_SHOWCASE_MODE == true ]]; then
            sleep 1s
        else
            $2
        fi
        echo -e "\r$1... Done! $SUCCESS"
    else
        if [[ $IS_SHOWCASE_MODE == true ]]; then
            sleep 1s
            echo -e "\r$1... Done! $SUCCESS"
        else
            if $2 >> "$3" 2>&1 ; then
                echo -e "\r$1... Done! $SUCCESS"
            else
                echo -e "\r$1... $FAIL"
                errcho "$ERROR something went wrong"
                errcho "Please check the generated \"$3\"."
                echo
            fi
        fi
    fi
}

###########################################################################

# Check if prerequisites for the script are satisfied
source helpers/intro.sh

# Carry out operations with sudo upfront to prevent further user interaction
source helpers/all_sudo.sh

# Setup Homebrew
source helpers/brew.sh

# Setup VSCode
source helpers/vscode.sh

# Install extra fonts
source helpers/fonts.sh

# Setup git and git-lfs
source helpers/git.sh

# Setup neovim
source helpers/nvim.sh

# Setup fish
source helpers/fish.sh

# Setup macOS configs
source helpers/macos.sh

# Run general utility stuff
source helpers/util.sh

echo
echo "$NAME completed!"
echo "Please remember to do several more things:"
echo "1. Set fish as the default shell by running:"
echo -e "   ${BOLD}chsh -s /opt/homebrew/bin/fish${NC}"
echo
echo "2. Enable fish vi keybindings by running:"
echo -e "   ${BOLD}fish_vi_key_bindings${NC}"
echo
echo "3. Load rbenv by running:"
echo -e "   ${BOLD}rbenv init${NC}"
echo
echo "4. Restart for some changes to take into effect."
echo
