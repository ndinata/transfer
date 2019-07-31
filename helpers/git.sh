#!/usr/bin/env bash

gitconfig_dir="dotfiles/.gitconfig"

echo "Git"
echo "$DIVIDER"

echo -n "Copying .gitconfig..."
cp "$gitconfig_dir" $HOME/
echo -ne "\rCopying .gitconfig... Done! $SUCCESS"
echo

echo -n "Setting up git lfs..."
git lfs install &> "$GIT_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when setting up git lfs"
    errcho "Please check the generated \`$GIT_LOGFILE\`."
    exit 1
fi

echo -ne "\rSetting up git lfs... Done! $SUCCESS"
echo && echo
