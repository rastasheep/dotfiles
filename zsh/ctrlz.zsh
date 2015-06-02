# A ZSH plugin that allows you to foreground the last backgrounded job using
# Ctrl+Z. So in your terminal, you hit Ctrl+Z to background a job, then Ctrl+Z
# again to foreground it.
#
# All credit goes to:
# http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/.
#

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
