#!/usr/bin/env bash

printf "\n------------------------\n"
echo "Commence git-setup."

printf "Type in your first and last name: "
read full_name

printf "Type in your Github email address: "
read email

git config --global user.name $full_name
git config --global user.email $email
git config --global credential.helper osxkeychain

echo ".gitconfig has now been added in $HOME."
echo "git-setup is done!"
printf "------------------------\n"