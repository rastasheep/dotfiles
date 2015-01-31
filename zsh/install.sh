#!/usr/bin/env bash

set -e

sudo apt-get -y install zsh curl

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
  echo "\033[0;33mYou already have Oh My Zsh installed.\033[0m You'll need to remove $ZSH if you want to install"
  exit
fi

echo "\033[0;34mCloning Oh My Zsh...\033[0m"
hash git >/dev/null 2>&1 && env git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH >/dev/null || {
  echo "git not installed"
  exit
}

echo "\033[0;34mLooking for an existing zsh config...\033[0m"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  echo "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32mBacking up to ~/.zshrc.pre-oh-my-zsh\033[0m";
  mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
fi

echo "\033[0;34mUsing the Oh My Zsh template file and adding it to ~/.zshrc\033[0m"
cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
sed -i -e "/^ZSH=/ c\\
ZSH=$ZSH
" ~/.zshrc

echo "\033[0;34mCopying your current PATH and adding it to the end of ~/.zshrc for you.\033[0m"
sed -i -e "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.zshrc


echo "\033[0;32m"'         __                                     __   '"\033[0m"
echo "\033[0;32m"'  ____  / /_     ____ ___  __  __   ____  _____/ /_  '"\033[0m"
echo "\033[0;32m"' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '"\033[0m"
echo "\033[0;32m"'/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '"\033[0m"
echo "\033[0;32m"'\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '"\033[0m"
echo "\033[0;32m"'                        /____/                       ....is now installed!'"\033[0m"

sudo chsh -s `which zsh` $USER
