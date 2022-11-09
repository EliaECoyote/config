# vim: set fdm=marker:
#
# Load shared config
source "$HOME/.shellrc"

# Add homebrew binaries to the path.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH?}"

# Git {{{

# Enables git completion.
# Note that `git-completion.zsh` is not designed to be sourced.
# Here we're loading it through a zsh function, available in `fpath`.
zstyle ':completion:*:*:git:*' script "$HOME/.config/git-completion.bash"
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

function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# NEWLINE=$'\n'
setopt PROMPT_SUBST
# export PROMPT='%F{red}%~%f $(parse_git_branch) ${NEWLINE}%F{cyan}⇢ %f'
export PROMPT='%F{red}%~%f $(parse_git_branch) %F{cyan}⇢ %f'

# }}}

function setup_custom_keybindings() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# Zsh Vim mode {{{

# https://github.com/jeffreytse/zsh-vi-mode
function zvm_config() {
  export VI_MODE_SET_CURSOR=true
  export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

if [ "${VIM_SHELL}" != "false" ]
then
  source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
  # We need to setup custom keybindings after zsh-vi-mode has been initialized
  # in order to avoid overwriting them.
  zvm_after_init_commands+=(setup_custom_keybindings)
else
  setup_custom_keybindings;
fi

# }}}
