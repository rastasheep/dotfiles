SHELL = /bin/bash

.PHONY: linux mac zsh bootstrap vim backup_mac_files osx_defaults install_homebrew clean restore_mac_files reload_shell

linux: backup_mac_files zsh bootstrap vim restore_mac_files reload_shell

mac: osx_defaults bootstrap reload_shell

zsh:
	zsh/install.sh

bootstrap:
	script/bootstrap

vim:
	vim/install.sh

reload_shell:
	cd && env zsh && . ~/.zshrc

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
