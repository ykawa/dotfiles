if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ -d $HOME/.rbenv/bin ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi


if [ -d $HOME/.pyenv ]; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

