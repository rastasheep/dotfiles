#!/usr/bin/env bash

set -e

sudo apt-get -y install zsh curl

echo "\033[0;34mLooking for an existing zsh config...\033[0m"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  echo "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32mBacking up to ~/.zshrc.pre-dot-files\033[0m";
  mv ~/.zshrc ~/.zshrc.pre-dot-files;
fi

sudo chsh -s `which zsh` $USER
