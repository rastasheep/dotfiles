#!/usr/bin/env bash

sudo apt-get -q -y purge vim
sudo apt-get -q -y install ncurses-dev

git clone --depth 1 https://github.com/b4winckler/vim.git ~/.vim/src

cd ~/.vim/src
./configure --enable-rubyinterp
sudo make && sudo make install && sudo make clean
cd

git clone --depth 1 https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall 2>&1 1>/dev/null
