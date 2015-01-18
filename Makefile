SHELL = /bin/bash

.PHONY: linux mac bootstrap setup_zsh backup_mac_files osx_defaults install_homebrew clean restore_mac_files set_zsh

linux: backup_mac_files setup_zsh bootstrap restore_mac_files set_zsh

mac: osx_defaults bootstrap set_zsh

setup_zsh:
	sudo apt-get -y install zsh curl vim
	zsh/install.sh
	sudo chsh -s `which zsh` $$USER

bootstrap:
	script/bootstrap
	vim/install.sh

set_zsh:
	[[ -z $$PS1 ]] || (cd && env zsh && . ~/.zshrc)

osx_defaults:
	osx/set-defaults.sh

install_homebrew:
	homebrew/install.sh

backup_mac_files:
	mv atom.symlink atom.symlink.tmp

restore_mac_files:
	mv atom.symlink.tmp atom.symlink

clean:
	git add . && git reset --hard HEAD
