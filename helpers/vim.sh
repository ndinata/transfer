#!/usr/bin/env bash

local_init_vim_file="dotfiles/init.vim"
nvim_home_dir="$HOME/.config/nvim"
vim_plug_download_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
vim_plug_install_dir="~/.local/share/nvim/site/autoload/plug.vim"

init_vim_cmd() {
    mkdir -pv "$nvim_home_dir"
    cp "$local_init_vim_file" "$nvim_home_dir"
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

echo_header "Neovim"
echo "$DIVIDER"

# Copy .vimrc
try_action "Copying init.vim" init_vim_cmd

# Install vim-plug
try_action "Installing vim-plug" vim_plug_install_cmd "$VIM_LOGFILE"
echo && echo
