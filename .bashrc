# vim: set fdm=marker:

# Load env variables {{{

if test -r "$HOME/.env"; then
  set -a
  source "$HOME/.env"
  set +a
fi

# }}}

# ls aliases {{{

alias ll="ls -alF"
alias ls="ls --color=auto"
alias la="ls -A"
alias l="ls -CF"

# }}}

# Folder navigation aliases {{{

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# }}}

# App aliases {{{

alias v="nvim"
alias k="kubectl"
alias cat="bat --paging=never"
alias bathelp='bat --plain --language=help'
alias ka="sudo kanata -c ~/.config/kanata/kanata.kbd"
alias g="git"
# Alias to handle `config` bare repo more easily
alias config="/usr/bin/git --git-dir=$HOME/.config.git/ --work-tree=$HOME"

# }}}

# Shell functions {{{

# Prints all the processes currently listening on a port
processes_listening_in_port() {
  lsof -i:"$1" -sTCP:LISTEN
}

# Prints the size of an element. Can be used with `folder_name\/*` syntax
foldersize() {
  du -hcs "$1"
}

# }}}

# Company-specific stuff {{{

if test -r "$HOME/.workrc"; then
  # shellcheck source=/Users/elia.camposilvan/.workrc
  source "$HOME/.workrc"
fi

# }}}

eval "$(fzf --bash)"
# HOMEBREW_PREFIX is unset on Linux, so this loads /etc/profile.d/bash_completion.sh there.
if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
  source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

# cf. https://unix.stackexchange.com/a/1292/360789
# Avoid bash history duplicates
HISTCONTROL=ignoredups:erasedups
# Append to history file upon shell exit, instead of overwriting it
shopt -s histappend
# Append to history file after each command, and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

prompt_color() {
  printf '\[\e[%sm\]' "$1"
}

RED="0;31"
BLUE="0;34"
RESET="0"

PS1="$(prompt_color $RED) \w\n $(prompt_color $BLUE)⇢ \$ $(prompt_color $RESET)"
export PS1
