#!/usr/bin/env bash

sudo apt-get -q -y install vim

git clone --depth 1 https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall 2>&1 1>/dev/null
