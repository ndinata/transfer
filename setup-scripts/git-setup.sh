#!/usr/bin/env bash

echo && echo "git-setup.sh"

printf "Enter your full name: "
read full_name

printf "Enter your Github email address: "
read email

echo "Setting your full name and email address..."
git config --global user.name "$full_name"
git config --global user.email $email

echo "Setting the default commit message editor to TextEdit..."
git config --global core.editor "open -W -n"

echo "Setting prune to true when fetching..."
git config --global fetch.prune true

echo ".gitconfig has now been added in $HOME."
echo "end git-setup.sh"
