# shellcheck source=/Users/elia.camposilvan/.shellrc
source "$HOME/.shellrc"

eval "$(fzf --bash)"
source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
source "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash"

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
