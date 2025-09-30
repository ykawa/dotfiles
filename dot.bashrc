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
fi
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# --- fzf: キーバインド＆補完 ---
if [ -f /usr/share/fzf/key-bindings.bash ]; then
  . /usr/share/fzf/key-bindings.bash
fi
if [ -f /usr/share/fzf/completion.bash ]; then
  . /usr/share/fzf/completion.bash
fi

eval "$(dircolors -b 2>/dev/null || true)"
eval "$(direnv hook bash)"

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

# いい感じにファイルを検索する
ffg() {
  # Usage: ffg [-e EXT]... [--] GREP_ARGS...
  local -a exts
  local OPTIND opt
  while getopts "e:" opt; do
    case "$opt" in
      e) exts+=("${OPTARG}") ;;
    esac
  done
  shift $((OPTIND-1))

  local ext_regex=""
  if [ ${#exts[@]} -gt 0 ]; then
    local sep=""
    ext_regex='\.('
    local e
    for e in "${exts[@]}"; do
      e="${e#.}"
      ext_regex="${ext_regex}${sep}${e}"
      sep='|'
    done
    ext_regex="${ext_regex})$"
  fi

  if [ -d .git ]; then
    if [ -n "$ext_regex" ]; then
      git ls-files -z | perl -0ne "print if /$ext_regex/s" | xargs -0 grep --binary-files=without-match "$@"
    else
      git ls-files -z | xargs -0 grep --binary-files=without-match "$@"
    fi
  else
    local -a find_args
    find_args=(
      -type d \( -name node_modules -o -name .git -o -name public -o -name storage -o -name docs -o -name libraries -o -name vendor -o -name .tmp -o -name out -o -name framework \) -prune -o -type f
    )
    if [ ${#exts[@]} -gt 0 ]; then
      find_args+=( '(' )
      local idx=0
      local e
      for e in "${exts[@]}"; do
        e="${e#.}"
        find_args+=( -name "*.${e}" )
        idx=$((idx+1))
        if [ $idx -lt ${#exts[@]} ]; then
          find_args+=( -o )
        fi
      done
      find_args+=( ')' )
    fi
    find_args+=( -print0 )
    find "${find_args[@]}" | xargs -0 grep --binary-files=without-match "$@"
  fi
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

hs()
{
  if [ $# -gt 0 ]; then
    cat ~/.zsh_history* ~/.bash_history* | col -bfx | sed -re 's/^: [^;]+//g' -e 's/^;//g' | sort | uniq | peco --query "$*" | tr -d '\n' | xclip -selection clipboard
  else
    cat ~/.zsh_history* ~/.bash_history* | col -bfx | sed -re 's/^: [^;]+//g' -e 's/^;//g' | sort | uniq | peco | tr -d '\n' | xclip -selection clipboard
  fi
}

reload() {
  exec "${SHELL}" "$@"
}

gh-pr-rebase-onto-develop() {
  # オプション:
  #   -r <remote>   リモート名 (既定: origin)
  #   -m <main>     mainブランチ名 (既定: main)
  #   -d <develop>  developブランチ名 (既定: develop)
  #   -b <name>     新規ブランチ名 (省略時は自動生成)
  #   -k            マージコミットを保持してrebase (--rebase-merges)
  #   -N            PRは作成しない (ブランチ作成＆pushのみ)
  #
  # 使い方:
  #   gh-pr-rebase-onto-develop <PR番号|ブランチ名> [オプション...]
  #
  # 例:
  #   gh-pr-rebase-onto-develop 123
  #   gh-pr-rebase-onto-develop feature/foo -k -d develop -m main
  local remote="origin" main="main" develop="develop" new_branch="" keep_merges=0 no_pr=0
  while getopts "r:m:d:b:kN" opt; do
    case "$opt" in
      r) remote="$OPTARG" ;;
      m) main="$OPTARG" ;;
      d) develop="$OPTARG" ;;
      b) new_branch="$OPTARG" ;;
      k) keep_merges=1 ;;
      N) no_pr=1 ;;
    esac
  done
  shift $((OPTIND-1))

  local pr_or_branch="${1:-}"
  if [[ -z "$pr_or_branch" ]]; then
    echo "Usage: gh-pr-rebase-onto-develop <PR番号|ブランチ名> [-r remote] [-m main] [-d develop] [-b new_branch] [-k] [-N]" >&2
    return 2
  fi

  # 必要コマンド確認
  command -v git >/dev/null 2>&1 || { echo "git が見つかりません"; return 1; }
  if [[ "$pr_or_branch" =~ ^[0-9]+$ ]]; then
    command -v gh >/dev/null 2>&1 || { echo "gh (GitHub CLI) が見つかりません"; return 1; }
  fi

  # 作業ツリーがクリーンか確認
  if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "作業ツリーに未コミットの変更があります。コミットまたはstashしてください。" >&2
    return 1
  fi

  git fetch --all --prune || return 1

  # 引数がPR番号なら head ブランチ名を取得、そうでなければそのまま使う
  local head
  if [[ "$pr_or_branch" =~ ^[0-9]+$ ]]; then
    head="$(gh pr view "$pr_or_branch" --json headRefName -q .headRefName)" || return 1
  else
    head="$pr_or_branch"
  fi

  # new_branch が未指定なら自動生成
  if [[ -z "$new_branch" ]]; then
    if [[ "$pr_or_branch" =~ ^[0-9]+$ ]]; then
      new_branch="${head}-onto-${develop}-from-pr-${pr_or_branch}"
    else
      new_branch="${head}-onto-${develop}"
    fi
  fi

  # 参照が存在するか軽くチェック
  git rev-parse --verify "${remote}/${main}" >/dev/null 2>&1 || { echo "リモート ${remote}/${main} が見つかりません"; return 1; }
  git rev-parse --verify "${remote}/${develop}" >/dev/null 2>&1 || { echo "リモート ${remote}/${develop} が見つかりません"; return 1; }
  git rev-parse --verify "${remote}/${head}" >/dev/null 2>&1 || { echo "リモート ${remote}/${head} が見つかりません"; return 1; }

  # 元ブランチから作業ブランチを切る（ローカルに無くてもOK）
  if ! git switch "$head" 2>/dev/null; then
    git switch -c "$head" "${remote}/${head}" || return 1
  fi
  git switch -c "$new_branch" || return 1

  echo "Rebasing commits in '${head}' that are not in '${remote}/${main}' onto '${remote}/${develop}' ..."
  if [[ $keep_merges -eq 1 ]]; then
    git rebase --rebase-merges --onto "${remote}/${develop}" "${remote}/${main}" || { echo "rebase失敗。必要なら 'git rebase --abort' を実行してください。"; return 1; }
  else
    git rebase --onto "${remote}/${develop}" "${remote}/${main}" || { echo "rebase失敗。必要なら 'git rebase --abort' を実行してください。"; return 1; }
  fi

  # push & PR作成
  git push -u "${remote}" "${new_branch}" || return 1

  if [[ $no_pr -eq 0 ]]; then
    # 既定テンプレを使いたくない場合は --fill を外して --title/--body を指定してください
    gh pr create --base "${develop}" --head "${new_branch}" --fill || return 1
    echo "✅ develop向けPRを作成しました。"
  else
    echo "✅ ブランチ '${new_branch}' を push しました（PR未作成 -N）。"
  fi
}

# Shift+↑/↓ で ScrollToPrompt が効くように、プロンプト直前に A マーカーを送る
if [ -n "$WEZTERM_EXECUTABLE" ] 2>/dev/null; then
  __wezterm_prompt_mark() { printf '\033]133;A\007'; }
  if [ -z "${PROMPT_COMMAND}" ]; then
    PROMPT_COMMAND="__wezterm_prompt_mark"
  else
    PROMPT_COMMAND="__wezterm_prompt_mark; ${PROMPT_COMMAND}"
  fi
fi
