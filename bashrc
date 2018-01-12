case $- in
  *i*) ;;
  *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=2000
HISTFILESIZE=2000
export PROMPT_COMMAND='history -a; history -r'


PS1_HOST=${HOSTNAME}
HOST_LEN=${#HOSTNAME}
if [ ${HOST_LEN} -gt 8 ]; then
  PS1_HOST="${HOSTNAME:0:4}${HOSTNAME:$HOST_LEN-4:4}"
fi
SHORTHOST=$PS1_HOST
export PS1="\u@$SHORTHOST:\W "
unset PS1_HOST
unset SHORTHOST

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias s='screen'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

stty werase undef
bind "\C-w":unix-filename-rubout

if builtin command -v resize >/dev/null; then
  rs () {
    eval `resize`
  }
else
  rs () {
    kill -s WINCH $$
  }
fi

if [ -d $HOME/.rbenv/bin ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  export WORKON_HOME=$HOME/.virtualenvs
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
  . /usr/local/bin/virtualenvwrapper.sh
fi

# send WINCH signal
kill -s WINCH $$
