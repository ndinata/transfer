#!/usr/bin/env bash

echo && echo "git-setup.sh"

echo "Copying .gitconfig..."
cp dotfiles/.gitconfig $HOME/

printf "Enter your full name: "
read full_name

printf "Enter your Github email address: "
read email

echo "Setting your full name and email address..."
git config --global user.name "$full_name"
git config --global user.email $email

echo "end git-setup.sh"

