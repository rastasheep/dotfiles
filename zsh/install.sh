#!/usr/bin/env bash

set -e

# If we're not on a Mac, let's install vim first
if [ "$(uname -s)" != "Darwin" ]
then
  sudo apt-get -q -y install zsh curl
fi

sudo chsh -s `which zsh` $USER
