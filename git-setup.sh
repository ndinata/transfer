#!/usr/bin/env bash

printf "\n------------------------\n"
echo "Commence git-setup."

printf "Type in your first and last name: "
read full_name

printf "Type in your Github email address: "
read email

echo "Setting your full name and email address..."
git config --global user.name $full_name
git config --global user.email $email

echo "Setting osxkeychain as credential helper..."
git config --global credential.helper osxkeychain

echo "Setting the default commit message editor to TextEdit..."
git config --global core.editor "open -W -n"

echo "Setting prune to true when fetching..."
git config --global fetch.prune true

echo ".gitconfig has now been added in $HOME."

echo "Installing and configuring git-lfs..."
brew install git-lfs
git lfs install

echo "git-setup is done!"