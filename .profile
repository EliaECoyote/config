# Configure locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Set nvim as default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_PREFIX

# Prefer GNU binaries over default binaries.
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-indent/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/gnu-indent/libexec/gnuman:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnuman:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnuman:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnuman:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/gnu-getopt/bin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/gnu-getopt/share/man:$MANPATH"
export PATH="$HOMEBREW_PREFIX/opt/gnutls/bin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/gnutls/share/man:$MANPATH"

# Export non-system libraries and executables
export PATH="/usr/local/bin:$PATH"

# Export local binaries
export PATH="$HOME/.local/bin:$PATH"

# Add homebrew binaries to the path.
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

# Define user-config directory
# cf. https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html
export XDG_CONFIG_HOME="$HOME/.config"

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# FZF settings
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Silence macos default shell warnings
export BASH_SILENCE_DEPRECATION_WARNING=1

# Enable terminal.app colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Python settings
export PYENV_ROOT="$HOME/.pyenv"

# Golang settings
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
# cf. https://go.dev/blog/go116-module-changes
export GO111MODULE=auto
