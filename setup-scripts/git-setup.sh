#!/usr/bin/env bash

echo && echo "git-setup.sh"

printf "Enter your full name: "
read full_name

printf "Enter your Github email address: "
read email

echo "Setting your full name and email address..."
git config --global user.name "$full_name"
git config --global user.email $email

echo "Setting prune to true when fetching..."
git config --global fetch.prune true

echo "Setting lg as log alias..."
git config --global alias.lg "log --graph --all --format=format:'%C(blue)%h%C(reset)  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(yellow)%d%C(reset)%n''         %C(dim cyan)%aD%C(reset) %C(dim green)%ar%C(reset)'"

echo ".gitconfig has now been added in $HOME."
echo "end git-setup.sh"

