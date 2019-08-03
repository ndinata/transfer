#!/usr/bin/env bash

fish_function_dir="$HOME/.config/fish/functions"
fishfiles_dir="fishfiles"

echo "Fish"
echo "$DIVIDER"

# Copy fish function files
echo -n "Adding fish function files..."
if [ ! -d "$fish_function_dir/" ]; then
    mkdir -pv $fish_function_dir
fi
cp $fishfiles_dir/* $fish_function_dir
echo -e "\rAdding fish function files... Done! $SUCCESS"

# Install Fisher
echo -n "Installing Fisher..."
curl https://git.io/fisher --create-dirs -sLo $HOME/.config/fish/functions/fisher.fish &> "$FISH_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing Fisher"
    errcho "Please check the generated \`$FISH_LOGFILE\`."
    exit 1
fi
echo -e "\rInstalling Fisher... Done! $SUCCESS"

# Install fish-pure
echo -n "Installing fish pure..."
fish -c "fisher add rafaelrinaldi/pure" &> "$FISH_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when installing fish-pure"
    errcho "Please check the generated \`$FISH_LOGFILE\`."
    exit 1
fi
echo -e "\rInstalling fish pure... Done! $SUCCESS"

# echo && echo "Creating fish directory for linking..."
# mkdir -pv $HOME/.config/fish/conf.d/

echo -n "Adding Brew's python symlink location to \$PATH..."
fish -c "set -U fish_user_paths /usr/local/opt/python/libexec/bin \$fish_user_paths"
echo -e "\rAdding Brew's python symlink location to \$PATH... Done! $SUCCESS"

echo -n "Adding node@10 to \$PATH..."
fish -c "set -U fish_user_paths /usr/local/opt/node@10/bin \$fish_user_paths"
echo -e "\rAdding node@10 to \$PATH... Done! $SUCCESS"

echo -n "Enabling vi keybindings on fish..."
fish -c "fish_vi_key_bindings"
echo -e "\rEnabling vi keybindings on fish... Done! $SUCCESS"
echo && echo
