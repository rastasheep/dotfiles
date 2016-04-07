#!/usr/bin/env bash

# If we're not on a Mac, let's install vim first
if [ "$(uname -s)" != "Darwin" ]
then
  sudo apt-get -q -y install vim
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall 2>&1 1>/dev/null
