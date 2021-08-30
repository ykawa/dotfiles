# vim: filetype=sh autoindent smartindent expandtab tabstop=2 softtabstop=2 shiftwidth=2 shiftround
#exec 4> $HOME/debug_output.txt
#BASH_XTRACEFD=4
#PS4='$LINENO: '
#set -x

case $- in
  *i*) ;;
  *) return;;
esac

shopt -s checkwinsize
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE='ls:pwd:exit'

case "$TERM" in
  xterm*|rxvt*)
    PROMPT_COMMAND='history -a && history -c && history -r && echo -ne "\033]0;${PWD##*/}\007"'
    show_command_in_title_bar()
    {
      case "$BASH_COMMAND" in
        echo*|*history*)
          ;;
        *)
          echo -ne "\033]0;${BASH_COMMAND} - ${PWD##*/}\007"
          ;;
      esac
    }
    trap show_command_in_title_bar DEBUG
    ;;
  *)
    ;;
esac

[ type lesspipe >/dev/null 2>&1 ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ type dircolors >/dev/null 2>&1 ]; then
  if [ -e ~/dotfiles/dircolors ]; then
    eval "$(dircolors -b ~/dotfiles/dircolors)"
  fi
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias al='ls -al'
alias l='ls -CF'
alias s='screen'
alias open='xdg-open'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
  if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
  fi
fi

# modify PS1
PS1_HOST=${HOSTNAME}
HOST_LEN=${#HOSTNAME}
if [ ${HOST_LEN} -gt 8 ]; then
  PS1_HOST="${HOSTNAME:0:4}${HOSTNAME:$HOST_LEN-4:4}"
fi
SHORTHOST=$PS1_HOST
export PS1="[\u@$SHORTHOST \W]$ "

if [ -e ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=
GIT_PS1_SHOWSTASHSTATE=
if declare -f __git_ps1 | grep __git_ps1 >/dev/null; then
  export PS1='$(__git_ps1)'"[\u@$SHORTHOST \W]$ "
fi
unset PS1_HOST
unset SHORTHOST


stty werase undef
stty stop undef
bind "\C-w":unix-filename-rubout

export VISUAL=vim
export EDITOR="$VISUAL"

complete -cf sudo

if builtin command -v resize >/dev/null; then
  rs () {
    eval `resize`
  }
else
  rs () {
    kill -s WINCH $$
  }
fi

ffg () {
  find ! -type d -print0 | xargs -0 grep --binary-files=without-match "$@"
}

cffg () {
  find -maxdepth 2 ! -type d -print0 | xargs -0 grep --binary-files=without-match "$@"
}

effg () {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' -o -name 'storage' -o -name 'docs' -o -name '.tmp' \) -prune -o -type f -print0 | xargs -0 grep --binary-files=without-match "$@"
}

jffg () {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'framework' -o -name '.tmp' \) -prune -o -type f -name '*.java' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

pffg () {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' \
    -o -name 'storage' -o -name 'docs' -o -name 'libraries' -o -name 'vendor' -o -name '.tmp' \) -prune -o -type f -name '*.php' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

ccol () {
  cut -c1-${COLUMNS}
}

cls () {
  perl -e 'print "\n"x`tput lines`'
}

# remove everything Docker containers
removecontainers() {
  docker stop $(docker ps -aq)
  docker rm $(docker ps -aq)
}

# remove everything Docker
armaggedon() {
  removecontainers
  docker network prune -f
  docker rmi -f $(docker images --filter dangling=true -qa)
  docker volume rm $(docker volume ls --filter dangling=true -q)
  docker rmi -f $(docker images -qa)
}


if [ -d $HOME/bin ]; then
  PATH="${PATH}:$HOME/bin"
fi

if [ type npm >/dev/null 2>&1 ]; then
  source <(npm completion)
fi

# -- plenv
if [ -d $HOME/.plenv/bin ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
elif [ -e $HOME/perl5/lib/perl5/local/lib.pm ]; then
  eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
fi

# -- PYTHONSTARTUP
if [ -z "$PYTHONSTARTUP" -a -s "$HOME/.pythonstartup" ]; then
  export PYTHONSTARTUP="$HOME/.pythonstartup"
fi

# -- GNU Global
if [ ! -f $HOME/.globalrc ]; then
  if [ -x /usr/local/bin/gtags ]; then
    export GTAGSCONF=/usr/local/share/gtags/gtags.conf
  fi
  if command type pygmentize >/dev/null; then
    export GTAGSLABEL=pygments
  fi
fi

echo ":$PATH:" | grep -q ":$HOME/.local/bin:" || export PATH="$HOME/.local/bin:$PATH"

if [ -n "$STY" ]; then
  scr_cd()
  {
    cd "$@"
    screen -X chdir "$PWD"
  }
  alias cd=scr_cd
fi

[ -e $HOME/.bashrc_local ] && . $HOME/.bashrc_local

# for developing alpine docker images helper.
alprun()
{
  touch $HOME/ash_history .ash_history
  docker run --rm -it -v $HOME/ash_history:/work/.ash_history \
    -v $(pwd):/work -w /work alpine:latest \
    sh -c "addgroup -g `id -g` people;
      adduser -D -G people -h /work -u `id -u` person;
      apk add --no-cache sudo;
      echo '%people ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers;
      su - person"
  rm -f .ash_history
}
