#!/usr/bin/env bash

echo && echo "vim-setup.sh"

echo "Copying .vimrc..."
cp dotfiles/.vimrc $HOME

echo "Creating directory for vim colorschemes..."
mkdir $HOME/.vim/colors
mkdir $HOME/.vim/autoload

echo "Downloading vim colorschemes..."
curl https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim -o $HOME/.vim/autoload/onedark.vim
curl https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim -o $HOME/.vim/colors/onedark.vim

echo "end vim-setup.sh"
