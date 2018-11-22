#!/usr/bin/env bash

echo "Commence git-setup."

printf "Git       | Type in your first and last name: "
read full_name

printf "Git       | Type in your Github email address: "
read email

echo "Git       | Setting your full name and email address..."
git config --global user.name $full_name
git config --global user.email $email

echo "Git       | Setting osxkeychain as credential helper..."
git config --global credential.helper osxkeychain

echo "Git       | Setting the default commit message editor to TextEdit..."
git config --global core.editor "open -W -n"

echo "Git       | Setting prune to true when fetching..."
git config --global fetch.prune true

echo "Git       | .gitconfig has now been added in $HOME."

echo "Git       | Installing and configuring git-lfs.."
brew install git-lfs
git lfs install

echo "git-setup is done!"
