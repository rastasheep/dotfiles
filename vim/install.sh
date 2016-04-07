#!/usr/bin/env bash

# If we're not on a Mac, let's install vim first
if [ "$(uname -s)" != "Darwin" ]
then
  yes | sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update 2>&1 1>/dev/null
  sudo apt-get install neovim
fi

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall --headless
