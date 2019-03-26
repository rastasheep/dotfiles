SHELL = /bin/bash

.PHONY: install bootstrap reload_shell clean

install: bootstrap reload_shell

bootstrap:
	script/bootstrap

reload_shell:
	cd && env zsh && . ~/.zshrc

clean:
	git add . && git reset --hard HEAD
