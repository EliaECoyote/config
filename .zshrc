# vim: set fdm=marker:

# Load shared config
source ~/.shellrc

# VI mode {{{

# Enable vi mode
bindkey -v

# Avoid ESC delay
export KEYTIMEOUT=1

# }}}

# Yank to the system clipboard {{{

function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'Y' vi-yank-xclip

# }}}

# Zsh history settings {{{

# Share history across terminals
setopt sharehistory
# Immediately append to the history file, not just when a term is killed
setopt incappendhistory

# }}}

# File manager {{{

function vi-file-manager {
  zle kill-whole-line
  BUFFER=vifm
  zle accept-line
}
zle -N vi-file-manager
bindkey -M vicmd '\-' vi-file-manager

# }}}

# Customize prompt string {{{

PROMPT=""

NEWLINE=$'\n'
MODE_NORMAL_PS="%F{green}NORMAL%f"
MODE_INSERT_PS="%F{blue}INSERT%f"
CURSOR_BLOCK="\033[2 q"
CURSOR_LINE="\033[6 q"

parse-git-branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function set-prompt() {
  case ${KEYMAP} in
    (vicmd)      VI_MODE=${MODE_NORMAL_PS} ;;
    (main|viins) VI_MODE=${MODE_INSERT_PS} ;;
    (*)          VI_MODE=${MODE_INSERT_PS} ;;
  esac
  CURRENT_BRANCH=$(parse-git-branch)
  PROMPT="%F{red}%~%f ${CURRENT_BRANCH} ${NEWLINE}${VI_MODE} %F{cyan}⇢ %f"
}

function set-cursor() {
  case $KEYMAP in
    (vicmd)      printf ${CURSOR_BLOCK} ;;
    (main|viins) printf ${CURSOR_LINE} ;;
  esac
}

function zle-line-init zle-keymap-select {
  set-prompt
  set-cursor
  zle reset-prompt
}

# Bind the callback
zle -N zle-line-init
zle -N zle-keymap-select

# }}}

# Fzf {{{

bindkey -M vicmd '?' fzf-history-widget
bindkey -M viins 'Tab' fzf-completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}
