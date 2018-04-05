# vim: set autoindent smartindent expandtab tabstop=2 softtabstop=2 shiftwidth=2 shiftround

case $- in
*i*) ;;
*) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=20000
HISTFILESIZE=20000
HISTIGNORE='ls:pwd:exit'
export PROMPT_COMMAND='history -a; history -c; history -r'

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

# modify PS1
PS1_HOST=${HOSTNAME}
HOST_LEN=${#HOSTNAME}
if [ ${HOST_LEN} -gt 8 ]; then
  PS1_HOST="${HOSTNAME:0:4}${HOSTNAME:$HOST_LEN-4:4}"
fi
SHORTHOST=$PS1_HOST
export PS1="[\u@$SHORTHOST \W]$ "

# GIT_PS1_SHOWUPSTREAM
#  現在のブランチがupstreamより進んでいるとき">"を、遅れているとき"<"を、
#  遅れてるけど独自の変更もあるとき"<>"を表示する。
#  オプションが指定できるけど(svnをトラックするかとか)
# GIT_PS1_SHOWUNTRACKEDFILES
#  addされてない新規ファイルがある(untracked)とき"%"を表示する
# GIT_PS1_SHOWSTASHSTATE
#  stashになにか入っている(stashed)とき"$"を表示する
# GIT_PS1_SHOWDIRTYSTATE
#  addされてない変更(unstaged)があったとき"*"を表示する、
#  addされているがcommitされていない変更(staged)があったとき"+"を表示する
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=
GIT_PS1_SHOWSTASHSTATE=1
if declare -f __git_ps1 | grep __git_ps1 >/dev/null; then
  export PS1='$(__git_ps1)'"[\u@$SHORTHOST \W]$ "
fi
unset PS1_HOST
unset SHORTHOST


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

ffg () {
  find ! -type d -print0 | xargs -0 grep --binary-files=without-match $@
}

# send WINCH signal
kill -s WINCH $$

