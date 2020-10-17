# vim: set fdm=marker:

# Load env variables {{{

if [ -e ~/.env ]
then
  export $(cat ~/.env | xargs)
else
  echo "⚠️  No env found!"
fi

# }}}

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# Set nvim as default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

# Enable colors in vim
export TERM=xterm-256color

# FZF settings
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="rg --files --hidden --smart-case --no-ignore --follow"
export FZF_ALT_C_COMMAND='find .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Configure locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# custom cmd that starts fzf and hides the following fzf init error:
# ```
# /usr/local/opt/fzf/shell/key-bindings.bash:63: command not found: bind
# ```
# https://github.com/junegunn/fzf/issues/846#issuecomment-280822238
[ -z "$ZSH_NAME" ] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash

source ~/.ddbashrc

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

# Git aliases {{{

alias gits='git status'
alias gitd='git diff'
alias gito='git push -u origin HEAD'
alias gitp='git pull'
alias gitcm='git commit -m'
alias gitl='git log --pretty=short --abbrev-commit'
alias gita='git add -p'
alias gite='git commit --allow-empty -m'
alias up="git branch | awk '/^\\* / { print \$2 }' | xargs -I {} git branch --set-upstream-to=origin/{} {}"
# Alias to handle config bare repo more easily
alias config='/usr/bin/git --git-dir=$HOME/.config.git/ --work-tree=$HOME'

# }}}

# App aliases {{{

alias hub-pr='hub pull-request -o'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias vim='nvim'
alias v='vim'

# }}}

# Prints all the processes currently listening on a port
processes_listening_in_port() {
  lsof -i:$1 -sTCP:LISTEN
}

# Prints the size of an element. Can be used with foldername\/* syntax
foldersize() {
  du -hcs $1
}

video_to_gif() {
  ffmpeg -i $1 -vf "scale=640:-2" -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=7 --colors 128 > out.gif
}

