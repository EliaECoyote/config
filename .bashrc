# shellcheck source=/Users/elia.camposilvan/.shellrc
source "$HOME/.shellrc"

source /opt/homebrew/etc/profile.d/bash_completion.sh

# cf. https://unix.stackexchange.com/a/1292/360789
# Avoid bash history duplicates
HISTCONTROL=ignoredups:erasedups
# Append to history file upon shell exit, instead of overwriting it
shopt -s histappend
# Append to history file after each command, and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

prompt_color() {
  echo "\[\033[${1}m\]"
}

BLACK="0;30"
RED="0;31"
BLUE="0;34"

CWD="\w"

PS1="$(prompt_color $RED) $CWD $(prompt_color $BLACK)\$ \n $(prompt_color $BLUE)⇢ $(prompt_color $BLACK)"
export PS1
