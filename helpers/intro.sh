#!/usr/bin/env bash

# Ensure correct usage of script
if [ $# != 0 ]; then
    echo
    errcho "$ERROR extra parameters detected"
    errcho "Usage: bash $SCRIPT_NAME.sh"
    exit 1
fi

# Check if signed in to Mac App Store
echo "Hello! Starting $NAME."
echo "Before we proceed, you need to be signed in to the Mac App Store for mas-cli to work."
echo "Are you signed in? [yes|no]"
read -p "[no] >> " REPLY
if [[ $REPLY =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo
else
    errcho "$ERROR not signed in to Mac App Store"
    errcho "Cannot proceed until you have signed in. Please try again."
    exit 1
fi

# Check if Xcode CLT is installed
echo "You also need to have installed Xcode CLT."
echo "You can do so by opening a new Terminal instance and running:"
echo
echo "    xcode-select --install"
echo
echo "Is the CLT installed? [yes|no]"
read -p "[no] >> " REPLY
if [[ $REPLY =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Let's start!"
    mkdir -pv "$LOGFILE_DIR"
    echo "$LOGFILE_DIR has been created to store logfiles."
    echo
else
    errcho "$ERROR Xcode CLT not installed"
    errcho "Cannot proceed until you have downloaded the CLT. Please try again."
    exit 1
fi
