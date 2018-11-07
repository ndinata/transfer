#!/usr/bin/env bash

echo "------------------------"
echo "Commence git-setup."

echo "Type in your first and last name: "
read full_name

echo "Type in your Github email address: "
read email

git config --global user.name $full_name
git config --global user.email $email
git config --global credential.helper osxkeychain

echo "git-setup is done!"
echo "------------------------"