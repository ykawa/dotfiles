# vim: filetype=sh autoindent smartindent expandtab tabstop=2 softtabstop=2 shiftwidth=2 shiftround
#exec 4>> $HOME/debug_output.txt
#BASH_XTRACEFD=4
#PS4='$LINENO: '
#set -x

case $- in
  *i*) ;;
  *) return;;
esac

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE='ls:pwd:exit'

case "$TERM" in
  screen*)
    PROMPT_COMMAND='history -a; history -c; history -r; printf "\033k\033\134\033k%s\033\134" "${PWD/#$HOME/\~}"'
    show_command_in_title_bar()
    {
      case "$BASH_COMMAND" in
        echo*|history*|printf*|LS_COLORS*)
          ;;
        *)
          printf "\033k\033\134\033k\$ %s\033\134" "${BASH_COMMAND}"
          ;;
      esac
    }
    trap show_command_in_title_bar DEBUG
    ;;
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND='history -a; history -c; history -r; printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    show_command_in_title_bar()
    {
      case "$BASH_COMMAND" in
        echo*|history*|screen*)
          ;;
        *)
          printf "\033]0;%s\007" "${BASH_COMMAND}"
          ;;
      esac
    }
    trap show_command_in_title_bar DEBUG
    ;;
  *) ;;
esac

short_host_name() {
  local len=${#HOSTNAME}
  if [ $len -gt 8 ]; then
    echo "${HOSTNAME:0:4}${HOSTNAME:$len-4:4}"
  else
    echo "${HOSTNAME}"
  fi
}

# wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
PS1="[\u@$(short_host_name) \W]$ "
if [ -e ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=
  GIT_PS1_SHOWUPSTREAM=1
  GIT_PS1_SHOWUNTRACKEDFILES=
  GIT_PS1_SHOWSTASHSTATE=
  export PS1='$(__git_ps1)'"${PS1:+$PS1}"
else
  export PS1="${PS1:+$PS1}"
fi
unset -f short_host_name

# wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

[ type lesspipe >/dev/null 2>&1 ] && eval "$(SHELL=/bin/sh lesspipe)"

if command -v type dircolors >/dev/null 2>&1; then
  if [ -e ~/dotfiles/dircolors ]; then
    eval "$(dircolors -b ~/dotfiles/dircolors)"
  fi
fi

alias ls='ls --group-directories-first --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cgrep='grep --color=always'
alias ll='ls -alF'
alias la='ls -A'
alias al='ls -al'
alias l='ls -CF'
alias s='screen -DRR'
alias open='xdg-open'

if [ type stty >/dev/null 2>&1 ]; then
  stty werase undef
  stty stop undef
fi
bind "\C-w":unix-filename-rubout

export VISUAL=vim
export EDITOR="$VISUAL"

xhost +local:root > /dev/null 2>&1
complete -cf sudo

export PATH="/opt/bin:$HOME/bin:$PATH"

# -- npm
if [ -d $HOME/.nodebrew/current/bin ]; then
  export PATH="$HOME/.nodebrew/current/bin:$PATH"
fi

if [ type npm >/dev/null 2>&1 ]; then
  source <(npm completion)
fi

# -- plenv
if [ -d $HOME/.plenv/bin ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
elif [ -e $HOME/perl5/lib/perl5/local/lib.pm ]; then
  # cpanm --local-lib=~/perl5 local::lib
  eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
elif [ -d $HOME/perl5 ]; then
  export PATH="$HOME/perl5/bin:$PATH"
  export PERL_CPANM_OPT="--local-lib=~/perl5"
  export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB"
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

# -- GO
if [ -z "$GOPATH" -a -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
fi

if [ -n "$GOROOT" ]; then
  export PATH="$GOROOT/bin:$PATH"
fi

# -- ruby
if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  if [ -e ~/.rbenv/completions/rbenv.zsh ]; then
    . ~/.rbenv/completions/rbenv.zsh
  fi
fi

# -- local env
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.vim/bin:$PATH"

[ -e $HOME/.bashrc_local ] && . $HOME/.bashrc_local

# -------------------------------------------
# clean up and normalize the PATH.
# -------------------------------------------
eval "$(perl ~/dotfiles/organize_path.pl)"

# -------------------------------------------
if builtin command -v resize >/dev/null; then
  rs () {
    eval `resize`
  }
else
  rs () {
    kill -s WINCH $$
  }
fi

# -- gnu screen
if [ -n "$STY" ]; then
  scr_cd()
  {
    cd "$@"
    screen -X chdir "$PWD"
  }
  alias cd=scr_cd
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
  docker system prune -f
  docker volume ls -f dangling=true --format "{{ .Name }}" | grep -E '^[a-z0-9]{64}$' | xargs --no-run-if-empty docker volume rm
}

# remove everything Docker
armaggedon() {
  removecontainers
  docker network prune -f
  docker rmi -f $(docker images --filter dangling=true -qa)
  docker volume rm $(docker volume ls --filter dangling=true -q)
  docker rmi -f $(docker images -qa)
  docker system prune -f -a
}

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

# for developing bullseye docker images helper.
debrun()
{
  touch $HOME/bash_history .bash_history
  docker run --rm -it -v $HOME/bash_history:/work/.bash_history \
    -v $(pwd):/work -w /work debian:latest \
    sh -c "groupadd -g `id -g` people;
  useradd -u `id -u` -g people -s /bin/bash -d /work person;
  apt-get update; apt-get install -y --no-install-recommends sudo $@;
  echo '%people ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers;
  su - person"
  [ "$HOME" = $(pwd) ] || rm -f .bash_history
}

ex()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1       ;;
      *.tar.gz)    tar xzf $1       ;;
      *.bz2)       bunzip2 $1       ;;
      *.rar)       unrar x $1       ;;
      *.gz)        gunzip $1        ;;
      *.tar)       tar xf $1        ;;
      *.tbz2)      tar xjf $1       ;;
      *.tgz)       tar xzf $1       ;;
      *.zip)       unzip -u sjis $1 ;;
      *.Z)         uncompress $1    ;;
      *.7z)        7z x $1          ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

c()
{
  # usage: ls -la | c
  perl ~/dotfiles/colon.pl
}

