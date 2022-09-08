# vim: set fdm=marker:

# Load shared config
source ~/.shellrc

# Git {{{

# Enables git completion.
# Note that `git-completion.zsh` is not designed to be sourced.
# Here we're loading it through a zsh function, available in `fpath`.
zstyle ':completion:*:*:git:*' script ~/.config/git-completion.bash
# `compinit` scans $fpath, so do this before calling it.
fpath=(~/.zsh/functions $fpath)
autoload -Uz compinit && compinit

# }}}

# Zsh history settings {{{

# Share history across terminals
setopt sharehistory
# Immediately append to the history file, not just when a term is killed
setopt incappendhistory

# }}}

# Prompt settings {{{

PROMPT=""
NEWLINE=$'\n'

parse-git-branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function set-prompt() {
  CURRENT_BRANCH=$(parse-git-branch)
  PROMPT="%F{red}%~%f ${CURRENT_BRANCH} ${NEWLINE}%F{cyan}⇢ %f"
}
function zle-line-init {
  set-prompt
  zle reset-prompt
}
zle -N zle-line-init

# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
