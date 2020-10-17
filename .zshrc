# vim: set fdm=marker:

# Load .bashrc config
source ~/.bashrc

# Zsh vi mode
bindkey -v

# Avoid ESC delay
export KEYTIMEOUT=1

# Yank to the system clipboard {{{

function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'Y' vi-yank-xclip

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
NORMAL_MODE_PROMPT="%F{green}NORMAL%f"
INSERT_MODE_PROMPT="%F{blue}INSERT%f"

parse-git-branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function set-prompt() {
  case ${KEYMAP} in
    (vicmd)      VI_MODE=${NORMAL_MODE_PROMPT} ;;
    (main|viins) VI_MODE=${INSERT_MODE_PROMPT} ;;
    (*)          VI_MODE=${INSERT_MODE_PROMPT} ;;
  esac
  CURRENT_BRANCH=$(parse-git-branch)
  PROMPT="%F{red}%~%f ${CURRENT_BRANCH} ${NEWLINE}${VI_MODE} %F{cyan}⇢ %f"
}

function zle-line-init zle-keymap-select {
  set-prompt
  zle reset-prompt
}

# Bind the callback
zle -N zle-line-init
zle -N zle-keymap-select

# }}}

# Fzf {{{

# bindkey -M viins '/' vi-history-search-backward
# bindkey -M viins '?' history-incremental-pattern-search-backward
# bindkey -M viins '^r' history-incremental-pattern-search-backward

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}
