#!/usr/bin/env bash

vimrc_dir="dotfiles/.vimrc"
vim_home_dir="$HOME/.vim"
vimrc_home_dir="$vim_home_dir/vimrc"
vim_plug_download_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
vim_plug_install_dir="~/.local/share/nvim/site/autoload/plug.vim"

vimrc_cmd() {
    mkdir -pv "$vim_home_dir"
    cp "$vimrc_dir" "$vimrc_home_dir"
}
vim_plug_install_cmd() {
    curl -fLo "$vim_plug_install_dir" --create-dirs "$vim_plug_download_url"
    if [ $? -ne 0 ]; then
        echo -e "\n"
        errcho "$ERROR something went wrong when downloading vim-plug"
        errcho "Please check the generated \`$VIM_LOGFILE\`."
    fi
}

###########################################################################

echo_header "Vim"
echo "$DIVIDER"

# Copy .vimrc
try_action "Copying .vimrc" vimrc_cmd

# Install vim-plug
try_action "Installing vim-plug" vim_plug_install_cmd "$VIM_LOGFILE"
echo && echo
