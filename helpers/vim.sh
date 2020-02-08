#!/usr/bin/env bash

vimrc_dir="dotfiles/.vimrc"
vim_home_dir="$HOME/.vim"
vimrc_home_dir="$vim_home_dir/vimrc"
vim_colors_dir="$vim_home_dir/colors"
vim_autoload_dir="$vim_home_dir/autoload"
vim_color_theme_url="https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim"
vim_autoload_theme_url="https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim"
vimrc_cmd() {
    mkdir -pv "$vim_home_dir"
    cp "$vimrc_dir" "$vimrc_home_dir"
}
vim_theme_install_cmd() {
    mkdir -pv "$vim_colors_dir"
    mkdir -pv "$vim_autoload_dir"
    curl "$vim_autoload_theme_url" -o "$vim_autoload_dir/onedark.vim"
    if [ $? -ne 0 ]; then
        echo -e "\n"
        errcho "$ERROR something went wrong when downloading vim autoload file"
        errcho "Please check the generated \`$VIM_LOGFILE\`."
    fi

    curl "$vim_color_theme_url" -o "$vim_colors_dir/onedark.vim"
    if [ $? -ne 0 ]; then
        echo -e "\n"
        errcho "$ERROR something went wrong when downloading vim colors file"
        errcho "Please check the generated \`$VIM_LOGFILE\`."
    fi
}
vim_plug_install_cmd() {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ $? -ne 0 ]; then
        echo -e "\n"
        errcho "$ERROR something went wrong when downloading vim-plug file"
        errcho "Please check the generated \`$VIM_LOGFILE\`."
    fi
}

###########################################################################

echo_header "Vim"
echo "$DIVIDER"

# Copy .vimrc
try_action "Copying .vimrc" vimrc_cmd

# Install vim color schemes
try_action "Installing vim colorschemes" vim_theme_install_cmd "$VIM_LOGFILE"

# Install vim-plug
try_action "Installing vim-plug" vim_plug_install_cmd "$VIM_LOGFILE"
echo && echo
