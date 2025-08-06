# vim: filetype=zsh autoindent smartindent expandtab tabstop=2 softtabstop=2 shiftwidth=2 shiftround

export LANG=ja_JP.UTF-8

if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"

  ZSH_THEME=""

  plugins=(
    git
    docker
    npm
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
  )

  source $ZSH/oh-my-zsh.sh

  autoload -Uz colors
  colors
  setopt globdots
else
  autoload -Uz colors
  colors

  setopt globdots
  fpath=($fpath $HOME/.zsh/completion)
  autoload -Uz compinit
  compinit
fi

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
setopt share_history
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
# OS-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS aliases
  if builtin command -v gls >/dev/null 2>&1; then
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
  # Linux aliases
  alias ls='ls --group-directories-first --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias open='xdg-open'
fi

# Common aliases
alias al='ls -al'
alias cgrep='grep --color=always'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias lu='ls -U1'
alias s='screen -DRR'
alias zmv='noglob zmv -W'

export VISUAL=vim
export EDITOR="$VISUAL"
export LESSCHARSET=utf-8

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

# X11 forwarding (Linux only)
if [[ "$OSTYPE" != "darwin"* ]]; then
  xhost +local:root > /dev/null 2>&1
fi

export PATH="/opt/bin:$HOME/bin:$PATH"

# OS detection and specific settings
if [[ "$OSTYPE" == "darwin"* ]]; then
  # -- coreutils for macOS
  if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  fi
  if [ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]; then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
  fi

  ## dircolors for macOS
  if [ -e ~/.dircolors ]; then
    if builtin command -v gdircolors >/dev/null 2>&1; then
      eval "$(gdircolors -b ~/.dircolors)"
      zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    fi
  fi
else
  # Linux specific settings
  ## dircolors for Linux
  if [ -e ~/.dircolors ]; then
    if builtin command -v dircolors >/dev/null 2>&1; then
      eval "$(dircolors -b ~/.dircolors)"
      zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    fi
  fi
fi

# -- mise
if [ -f "$HOME/.local/bin/mise" ]; then
  export PATH="$HOME/.local/bin:$PATH"
  eval "$(mise activate zsh)"
fi

# -- npm completion (if npm is available)
if builtin type npm >/dev/null 2>&1; then
  source <(npm completion)
fi

# -- PYTHONSTARTUP
if [ -z "$PYTHONSTARTUP" -a -s "$HOME/.pythonstartup" ]; then
  export PYTHONSTARTUP="$HOME/.pythonstartup"
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
  local user_gemhome="$(gem environment user_gemhome 2>/dev/null)"
  if [ -n "$user_gemhome" ]; then
    export PATH="$PATH:$user_gemhome/bin"
  fi
fi

# -- local env
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.vim/bin:$PATH"
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

# -------------------------------------------
# clean up and normalize the PATH.
# -------------------------------------------
eval export "$( LC_ALL=C perl -CIO ~/dotfiles/organize_path.pl )"

# -------------------------------------------
if builtin command -v resize >/dev/null 2>&1; then
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

# Custom precmd and preexec functions
# These need to be defined after oh-my-zsh to override any conflicting functions
custom_precmd()
{
  termtitle precmd
  vcs_info
}

custom_preexec()
{
  termtitle preexec "${(V)1}"
}

# Add our custom functions to the hook arrays (oh-my-zsh compatible)
if [[ -n "${precmd_functions}" ]]; then
  # oh-my-zsh is loaded, use hook arrays
  precmd_functions+=(custom_precmd)
  preexec_functions+=(custom_preexec)
else
  # Fallback to direct function definition
  precmd() { custom_precmd "$@" }
  preexec() { custom_preexec "$@" }
fi

PERIOD=600
periodic()
{
  # gitコマンドがあるか確認する
  if ! builtin command -v git >/dev/null 2>&1; then
    return
  fi

  # gitリポジトリ内であるか確認する
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local stashes="$(git stash list)"
    if [ -n "${stashes}" ]; then
      echo "----------------------------------------"
      echo -e "\033[34m"
      echo "${stashes}"
      echo -e "\033[m"
      echo ""
    fi
  fi
}

PROMPT='${vcs_info_msg_0_}[%n@%m %1~]$ '

[ -e $HOME/.zshrc_local ] && . $HOME/.zshrc_local

alias claude="/home/ykawa/.claude/local/claude"
