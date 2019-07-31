#!/usr/bin/env bash

vimrc_dir="dotfiles/.vimrc"
vim_home_dir="$HOME/.vim"
vimrc_home_dir="$vim_home_dir/vimrc"
vim_colors_dir="$vim_home_dir/colors"
vim_autoload_dir="$vim_home_dir/autoload"
vim_color_theme_url="https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim"
vim_autoload_theme_url="https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim"

echo "Vim"
echo "$DIVIDER"

echo -n "Copying .vimrc..."
mkdir -pv "$vim_home_dir"
cp "$vimrc_dir" "$vimrc_home_dir"
echo -ne "\rCopying .vimrc... Done! $SUCCESS"
echo

echo -n "Installing vim colorschemes..."
mkdir -pv "$vim_colors_dir"
mkdir -pv "$vim_autoload_dir"

echo "Downloading vim autoload file..." >> "$VIM_LOGFILE"
curl "$vim_autoload_theme_url" -o "$vim_autoload_dir/onedark.vim" &> "$VIM_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when downloading vim autoload file"
    errcho "Please check the generated \`$VIM_LOGFILE\`."
    exit 1
fi

echo "Downloading vim colors file..." >> "$VIM_LOGFILE"
curl "$vim_color_theme_url" -o "$vim_colors_dir/onedark.vim" &> "$VIM_LOGFILE"
if [ $? -ne 0 ]; then
    echo -e "\n"
    errcho "$ERROR something went wrong when downloading vim colors file"
    errcho "Please check the generated \`$VIM_LOGFILE\`."
    exit 1
fi

echo -ne "\rInstalling vim colorschemes... Done! $SUCCESS"
echo && echo
