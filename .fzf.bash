# Setup fzf
# ---------
HOMEBREW_ROOT="$(brew --prefix)"

if [[ ! "$PATH" == *$HOMEBREW_ROOT/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOMEBREW_ROOT/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOMEBREW_ROOT/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOMEBREW_ROOT/opt/fzf/shell/key-bindings.bash"
