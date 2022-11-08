# vim: set fdm=marker:

# ----------------------------
# Shared shells configuration 
# ----------------------------

# Prefer GNU binaries to Macintosh binaries.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Export common binaries
export PATH="$HOME/.local/bin:${PATH}"

# Define base directory relative to which user specific configuration files should be stored
# cf. https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html
export XDG_CONFIG_HOME="$HOME/.config"

# Golang {{{

export GOPATH="${HOME?}/go"
export GOBIN="${GOPATH}/bin"
export PATH="${GOBIN}:${PATH}"
# Enable Go modules-mode by default
export GO111MODULE=on

# }}}

# Load env variables {{{

if [ -e ~/.env ]
then
  export $(cat "$HOME/.env" | xargs)
else
  echo "⚠️  No env found!"
fi

# }}}

# Brew settings {{{

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# }}}

# App settings {{{

# export PATH="${HOME?}/nvim-osx64/bin:${PATH}"

# Set nvim as default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

# }}}

# FZF settings {{{

export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# }}}

# Configure locales {{{

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# }}}

# ls aliases {{{

alias ll='ls -alFG'
alias ls='ls -G'
alias la='ls -AG'
alias l='ls -CFG'

# }}}

# Folder navigation aliases {{{

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# }}}

# Git utils {{{

alias g='git'

# Open PR {{{2

function open_pr() {
  github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/'`;
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  pr_url=$github_url"/compare/"$branch_name"?expand=1";
  open $pr_url;
}

# }}}

# Show file authors stats
function author_stats() {
  git blame --line-porcelain $1 | grep  "^author " | sort | uniq -c | sort -nr
}

# Alias to handle `config` bare repo more easily
alias config='/usr/bin/git --git-dir=$HOME/.config.git/ --work-tree=$HOME'

# }}}

# App aliases {{{

alias hub-pr='hub pull-request -o'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias v='nvim'
alias lazyconfig='lazygit --git-dir=$HOME/.config.git/ --work-tree=$HOME'

# }}}

# Bash functions {{{

# Prints all the processes currently listening on a port
processes_listening_in_port() {
  lsof -i:$1 -sTCP:LISTEN
}

# Prints the size of an element. Can be used with `folder_name\/*` syntax
foldersize() {
  du -hcs $1
}

video_to_gif() {
  ffmpeg -i "$1" -vf "scale=640:-2" -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=7 --colors 128 > out.gif
}

# example:
# ```
# # Get latest commit for 2022-10-10 in `main` branch
# get_commit_before 2022-10-10
#
# # Get latest commit for 2022-10-10 in `staging` branch
# get_commit_before 2022-10-10 staging
# ```
commit_before() {
  branch="${2:-main}"
  git rev-list -n1 --before=$1 $branch
}

# https://wiki.vifm.info/index.php/How_to_set_shell_working_directory_after_leaving_Vifm
vicd() {
  local dst="$(command vifm --choose-dir - "$@")"
  if [ -z "$dst" ]; then
      echo 'Directory picking cancelled/failed'
      return 1
  fi
  cd "$dst"
}

# }}}

# Company-specific stuff {{{

[ -f ~/.workrc.bash ] && source ~/.workrc.bash

# }}}

