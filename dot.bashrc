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

# Load bash-it
if [ -f "$HOME/.bash_it/bash_it.sh" ]; then
  # Lock and Load a custom theme file.
  # Leave empty to disable theming.
  export BASH_IT_THEME='bobby'

  # (Advanced): Change this to the name of your remote repo if you
  # cloned bash-it with a remote other than origin such as `bash-it`.
  # export BASH_IT_REMOTE='bash-it'

  # Your place for hosting Git repos. I use this for private repos.
  export GIT_HOSTING='git@github.com'

  # Don't check mail when opening terminal.
  unset MAILCHECK

  # Change this to your console based IRC client of choice.
  export IRC_CLIENT='irssi'

  # Set this to the command you use for todo.txt-cli
  export TODO="t"

  # Set this to false to turn off version control status checking within the prompt for all themes
  export SCM_CHECK=true

  # Set Xterm/screen/Tmux title with only a short hostname.
  # Uncomment this (or set SHORT_HOSTNAME to something else),
  # Will otherwise fall back on $HOSTNAME.
  #export SHORT_HOSTNAME=$(hostname -s)

  # Set Xterm/screen/Tmux title with only a short username.
  # Uncomment this (or set SHORT_USER to something else),
  # Will otherwise fall back on $USER.
  #export SHORT_USER=${USER:0:8}

  # Set Xterm/screen/Tmux title with shortened command and directory.
  # Uncomment this to set.
  #export SHORT_TERM_LINE=true

  # Set vcprompt executable path for scm advance info in prompt (demula theme)
  # https://github.com/djl/vcprompt
  #export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

  # (Advanced): Uncomment this to make Bash-it reload itself automatically
  # after enabling or disabling aliases, plugins, and completions.
  # export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

  # Uncomment this to make Bash-it create alias reload.
  # export BASH_IT_RELOAD_LEGACY=1

  # Load Bash It
  source "$HOME/.bash_it/bash_it.sh"
else
  # Fallback to basic prompt if bash-it is not available
  short_host_name() {
    local len=${#HOSTNAME}
    if [ $len -gt 8 ]; then
      echo "${HOSTNAME:0:4}${HOSTNAME:$len-4:4}"
    else
      echo "${HOSTNAME}"
    fi
  }

  PS1="[\u@$(short_host_name) \W]$ "
  unset -f short_host_name

  # Load basic bash completion
  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi
fi

# -- coreutils for macos
if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

[ builtin type lesspipe >/dev/null 2>&1 ] && eval "$(SHELL=/bin/sh lesspipe)"

# OS detection
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS specific settings
  if builtin type gdircolors >/dev/null 2>&1; then
    if [ -e ~/dotfiles/dircolors ]; then
      eval "$(gdircolors -b ~/dotfiles/dircolors)"
    fi
  fi

  # macOS aliases (using GNU coreutils if available)
  if builtin type gls >/dev/null 2>&1; then
    alias ls='gls --group-directories-first --color=auto'
    alias dir='gdir --color=auto'
    alias vdir='gvdir --color=auto'
  else
    alias ls='ls -G'
    alias dir='ls -G'
    alias vdir='ls -lG'
  fi
  alias open='open'
else
  # Linux specific settings
  if builtin type dircolors >/dev/null 2>&1; then
    if [ -e ~/dotfiles/dircolors ]; then
      eval "$(dircolors -b ~/dotfiles/dircolors)"
    fi
  fi

  # Linux aliases
  alias ls='ls --group-directories-first --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias open='xdg-open'
fi

# Common aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cgrep='grep --color=always'
alias ll='ls -alF'
alias la='ls -A'
alias al='ls -al'
alias l='ls -CF'
alias lu='ls -U1'
alias s='screen -DRR'

if builtin type stty >/dev/null 2>&1; then
  stty werase undef
  stty stop undef
fi
bind "\C-w":unix-filename-rubout

export VISUAL=vim
export EDITOR="$VISUAL"
export LESSCHARSET=utf-8

# X11 forwarding (Linux only)
if [[ "$OSTYPE" != "darwin"* ]]; then
  xhost +local:root > /dev/null 2>&1
fi
complete -cf sudo

export PATH="/opt/bin:$HOME/bin:$PATH"

# -- mise
if [ -f "$HOME/.local/bin/mise" ]; then
  export PATH="$HOME/.local/bin:$PATH"
  eval "$(mise activate bash)"
fi

# -- npm completion (if npm is available)
if builtin type npm >/dev/null 2>&1; then
  source <(npm completion)
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
  if builtin type pygmentize >/dev/null 2>&1; then
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

# -- gem (if gem is available)
if builtin type gem >/dev/null 2>&1; then
  user_gemhome="$(gem environment user_gemhome 2>/dev/null)"
  if [ -n "$user_gemhome" ]; then
    export PATH="$PATH:$user_gemhome/bin"
  fi
fi

# -- local env
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.vim/bin:$PATH"
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

[ -e $HOME/.bashrc_local ] && . $HOME/.bashrc_local

# -------------------------------------------
# clean up and normalize the PATH.
# -------------------------------------------
eval export "$( LC_ALL=C perl -CIO ~/dotfiles/organize_path.pl )"

# -------------------------------------------
if builtin type resize >/dev/null 2>&1; then
  rs() {
    eval `resize`
  }
else
  rs() {
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

ffg() {
  find ! -type d -print0 | xargs -0 grep --binary-files=without-match "$@"
}

cffg() {
  find -maxdepth 2 ! -type d -print0 | xargs -0 grep --binary-files=without-match "$@"
}

effg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' -o -name 'storage' -o -name 'docs' -o -name '.tmp' \) -prune -o -type f -print0 | xargs -0 grep --binary-files=without-match "$@"
}

jffg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'framework' -o -name '.tmp' \) -prune -o -type f -name '*.java' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

pffg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' \
    -o -name 'storage' -o -name 'docs' -o -name 'libraries' -o -name 'vendor' -o -name '.tmp' \) -prune -o -type f -name '*.php' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

rffg() {
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' -o -name 'out' \
    -o -name 'storage' -o -name 'docs' -o -name 'libraries' -o -name 'vendor' -o -name '.tmp' \) -prune -o -type f -name '*.rb' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

ccol() {
  cut -c1-${COLUMNS}
}

cls() {
  if builtin type banner >/dev/null 2>&1; then
      banner --width=$(tput cols) $(date "+%Y-%m-%d-%H:%M")
  fi
  perl -e 'print "\n"x`tput lines`'
}

# stop everything Docker containers
stopcontainers() {
  set -x
  docker ps -a
  docker ps -a | perl -nle 'print((split)[-1]) if $.>1' | xargs --no-run-if-empty docker stop
  docker ps -a | perl -nle 'print((split)[-1]) if $.>1' | xargs --no-run-if-empty docker rm
  set +x
}

# remove everything Docker containers
removecontainers() {
  stopcontainers
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
  [ "$HOME" = $(pwd) ] || rm -f .ash_history
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

reload() {
  exec "${SHELL}" "$@"
}
