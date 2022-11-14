source "$HOME/.shellrc"

# Load fzf
if [ -r "$HOME/.fzf.bash" ]; then
  source "$HOME/.fzf.bash"
fi

if [ -r "$HOME/.config/git-completion.bash" ]; then
  source "$HOME/.config/git-completion.bash"
  # Load autocomplete for git alias "g"
  __git_complete g __git_main
fi

# cf. https://unix.stackexchange.com/a/1292/360789
# Avoid bash history duplicates
HISTCONTROL=ignoredups:erasedups
# Append to history file upon shell exit, instead of overwriting it
shopt -s histappend
# Append to history file after each command, and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export PS1="\[$(tput sgr0)\]\[\033[38;5;1m\]\w\[$(tput sgr0)\] \$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/') \\$\n\[\033[38;5;6m\]⇢\[$(tput sgr0)\] "
