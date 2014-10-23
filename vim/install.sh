#!/usr/bin/env bash

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall 2>&1 1>/dev/null

