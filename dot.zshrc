
export LANG=ja_JP.UTF-8

autoload -Uz colors
colors

setopt globdots
fpath=($fpath $HOME/.zsh/completion)
autoload -Uz compinit
compinit

bindkey -e
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt append_history
setopt hist_expand
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
setopt share_history # history 共有
setopt noautoremoveslash

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
#zstyle ':zle:*' word-chars "/;@ "
#zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-chars " '\"/=;@:{}[]()<>,|."
zstyle ':zle:*' word-style unspecified

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control

# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# cdrコマンドを有効 ログアウトしても有効なディレクトリ履歴
# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
# cdrコマンドで履歴にないディレクトリにも移動可能に
zstyle ":chpwd:*" recent-dirs-default true

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias al='ls -al'
alias cgrep='grep --color=always'
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --group-directories-first --color=auto'
alias open='xdg-open'
alias s='screen -DRR'
alias vdir='vdir --color=auto'
alias zmv='noglob zmv -W'

export VISUAL=vim
export EDITOR="$VISUAL"
export LESSCHARSET=utf-8
export LESS='-XR'

# git設定
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true

xhost +local:root > /dev/null 2>&1

export PATH="/opt/bin:$HOME/bin:$PATH"

# -- coreutils for macos
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

## dircolors
if [ -e ~/dotfiles/dircolors ]; then
  eval "$(dircolors -b ~/dotfiles/dircolors)"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# -- npm
export PATH="$HOME/.nodebrew/current/bin:$PATH"

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
  export PERL_CPANM_OPT="--local-lib=~/perl5"
  export PATH="$HOME/perl5/bin:$PATH"
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
  if builtin command -v type pygmentize >/dev/null; then
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
  export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc --disable-install-capi"
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

# -------------------------------------------
# clean up and normalize the PATH.
# -------------------------------------------
eval "$( LC_ALL=C perl -CIO ~/dotfiles/organize_path.pl )"

# -------------------------------------------
if builtin command -v resize >/dev/null; then
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
  find -type d \( -name 'node_modules' -o -name '.git' -o -name 'public' \
    -o -name 'storage' -o -name 'docs' -o -name 'libraries' -o -name 'vendor' -o -name '.tmp' \) -prune -o -type f -name '*.rb' -print0 | xargs -0 grep --binary-files=without-match "$@"
}

c() {
  # usage: ls -la | c
  perl ~/dotfiles/colon.pl
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
  docker ps -aq
  docker ps -aq | xargs --no-run-if-empty docker stop
  docker ps -aq | xargs --no-run-if-empty docker rm
  docker volume ls -f dangling=true --format "{{ .Name }}" | grep -E '^[a-z0-9]{64}$' | xargs --no-run-if-empty docker volume rm
}

# remove everything Docker containers
removecontainers() {
  stopcontainers
  docker system prune -f
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

alprun() {
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
debrun() {
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

ex() {
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

reload() {
  exec "${SHELL}" "$@"
}

termtitle() {
  case "$TERM" in
    rxvt*|xterm*|nxterm|gnome|screen|screen-*|st|st-*)
      local prompt_host="${(%):-%m}"
      local prompt_user="${(%):-%n}"
      local prompt_char="${(%):-%~}"
      case "$1" in
        precmd)
          printf '\e]0;%s@%s: %s\a' "${prompt_user}" "${prompt_host}" "${prompt_char}"
          ;;
        preexec)
          printf '\e]0;%s [%s@%s: %s]\a' "$2" "${prompt_user}" "${prompt_host}" "${prompt_char}"
          ;;
      esac
      ;;
  esac
}

precmd()
{
  termtitle precmd
  vcs_info
}

preexec()
{
  termtitle preexec "${(V)1}"
}

PERIOD=600
periodic()
{
  [ -d .git/ -o -d ../.git -o -d ../../.git ] && git status -s
}

PROMPT='${vcs_info_msg_0_}[%n@%m %1~]$ '

[ -e $HOME/.zshrc_local ] && . $HOME/.zshrc_local

