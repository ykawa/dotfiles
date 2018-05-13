# vim: set autoindent smartindent expandtab tabstop=2 softtabstop=2 shiftwidth=2 shiftround

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi


# -- rbenv
if [ -d $HOME/.rbenv/bin ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# -- python - pyenv
if [ -d $HOME/.pyenv/bin ]; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init -)"
fi

# -- plenv
if [ -d $HOME/.plenv/bin ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
fi

if [ ! -f $HOME/.globalrc ]; then
  # TODO ちゃんとテストしてない・・・
  if [ -x /usr/local/bin/gtags ]; then
    export GTAGSCONF=/usr/local/share/gtags/gtags.conf
  fi
  if command which pygmentize >/dev/null; then
    export GTAGSLABEL=pygments
  fi
fi

# -- Node version manager
if [ -s ~/.nvm/nvm.sh ]; then
  source ~/.nvm/nvm.sh
fi

# -- npm completion
if type npm >/dev/null 2>&1; then
  source <(npm completion)
fi

# send WINCH signal
kill -s WINCH $$

