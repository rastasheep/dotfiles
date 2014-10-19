#!/bin/sh

if test ! $(which rbenv)
then
  echo "  Installing rbenv for you."
  if [ "$(uname -s)" == "Darwin" ]
  then
    brew install rbenv > /tmp/rbenv-install.log
  else
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  fi
fi

if test ! $(which ruby-build)
then
  echo "  Installing ruby-build for you."
  if [ "$(uname -s)" == "Darwin" ]
  then
    brew install ruby-build > /tmp/ruby-build-install.log
  else
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  fi
fi
