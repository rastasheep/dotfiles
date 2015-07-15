#!/usr/bin/env bash

git_clone_or_pull() {
  local REPOSRC=$1
  local LOCALREPO=$2
  local LOCALREPO_VC_DIR="$LOCALREPO/.git"
  if [[ ! -d "$LOCALREPO_VC_DIR" ]]; then
    git clone --depth 1 --recursive $REPOSRC $LOCALREPO
  else
    pushd $LOCALREPO
    git pull $REPOSRC && git submodule update --init --recursive
    popd
  fi
}

# If we're not on a Mac, let's install vim first
if [ "$(uname -s)" != "Darwin" ]
then
  sudo apt-get -q -y install vim
fi

git_clone_or_pull "https://github.com/gmarik/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"

vim +PluginInstall +qall 2>&1 1>/dev/null
