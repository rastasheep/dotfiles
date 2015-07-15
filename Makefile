SHELL = /bin/bash

.PHONY: linux mac bootstrap backup_mac_files restore_mac_files reload_shell clean

linux: backup_mac_files bootstrap restore_mac_files reload_shell

mac: bootstrap reload_shell

bootstrap:
	script/bootstrap

reload_shell:
	cd && env zsh && . ~/.zshrc

backup_mac_files:
	mv atom.symlink atom.symlink.tmp

restore_mac_files:
	mv atom.symlink.tmp atom.symlink

clean:
	git add . && git reset --hard HEAD
