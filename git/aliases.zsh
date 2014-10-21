alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias grc="git add . && git rebase --continue"
alias gre="git add . && git reset --hard HEAD"

alias grc="git add . && git rebase --continue"
alias greset="git add . && git reset --hard HEAD"
alias gpull="git pull --rebase && git log --color --pretty=oneline --abbrev-commit HEAD@{1}.. | sed 's/^/ /'"
