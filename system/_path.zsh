export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# dotfiles
export PATH=$PATH:$ZSH/bin

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# go
export GOPATH=$HOME/gocode
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN:$GOROOT/bin
