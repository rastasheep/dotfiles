.PHONY: linux mac bootstrap setup_zsh backup_mac_files osx_defaults install_homebrew clean install_vim_bundle

linux: backup_mac_files setup_zsh bootstrap install_vim_bundle

mac: osx_defaults bootstrap

setup_zsh:
	sudo apt-get install zsh
	wget --no-check-certificate http://install.ohmyz.sh -O - | bash
	chsh -s `which zsh`

bootstrap:
	script/bootstrap
	env zsh && . ~/.zshrc

backup_mac_files:
	mv atom.symlink atom.symlink.tmp

osx_defaults:
	osx/set-defaults.sh

install_vim_bundle:
	sudo apt-get install vim
	vim/install.sh

install_homebrew:
	homebrew/install.sh

clean:
	git add . && git reset --hard HEAD
