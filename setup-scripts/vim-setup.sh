#!/usr/bin/env bash

echo && echo "vim-setup.sh"

echo "Copying .vimrc..."
mkdir -pv $HOME/.vim
cp dotfiles/.vimrc $HOME/.vim/vimrc

echo "Creating directory for vim colorschemes..."
mkdir -pv $HOME/.vim/colors
mkdir -pv $HOME/.vim/autoload

echo "Downloading vim colorschemes..."
curl https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim -o $HOME/.vim/autoload/onedark.vim
curl https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim -o $HOME/.vim/colors/onedark.vim

echo "end vim-setup.sh"
