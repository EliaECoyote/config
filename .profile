# Configure locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Set nvim as default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

# Add homebrew binaries to the path.
export PATH="/usr/local/bin:$PATH"

# Prefer GNU binaries to Macintosh binaries.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Export local binaries
export PATH="$HOME/.local/bin:${PATH}"

# Add homebrew binaries to the path.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

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

# Golang settings
export GOPATH="${HOME?}/go"
export GOBIN="${GOPATH}/bin"
export PATH="${GOBIN}:${PATH}"
# cf. https://go.dev/blog/go116-module-changes
export GO111MODULE=auto
