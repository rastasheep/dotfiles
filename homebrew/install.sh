#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew, incuding favorite applications

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi

brew update

# Install homebrew packages

brew install grc
brew install coreutils

brew install wget
brew install ack
brew install tree
brew install zsh

# Install applications

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew cask install iterm2-nightly
brew cask install google-chrome

brew cask install virtualbox
brew cask install vagrant
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-berkshelf

brew cask install 1password
brew cask install transmission
brew cask install spotify
brew cask install spectacle
brew cask install dropbox
brew cask install google-drive
brew cask install mailbox
brew cask install xquartz
brew cask install fliqlo
brew cask install skype
brew cask install chefdk

# Install terminal font

brew tap caskroom/fonts
brew cask install font-source-code-pro

# Cleanup stuff

brew cleanup && brew cask cleanup
