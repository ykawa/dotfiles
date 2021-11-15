#!/bin/bash -vex
DATETIME=$(date +%Y%m%d%H%M%S)
LOCATION=$(cd $(dirname $0); pwd)
RELATIVE=${LOCATION##$HOME/}

pushd $HOME

touch \
  .bash_profile \
  .bashrc \
  .dircolors \
  .gitconfig \
  .globalrc \
  .grcat \
  .hyper.js \
  .my.cnf \
  .perltidyrc \
  .pythonstartup \
  .screenrc \
  .tmux.conf \
  .vimrc \
  .Xmodmap \
  .zshrc

for f in ${RELATIVE}/*
do
  dotf=$(basename $f)
  if [ -L .$dotf ]; then
    readlink .$dotf | grep -q dotfiles
    if [ $? == 0 ]; then
      continue
    else
      echo "update: .$dotf"
      mv .$dotf $dotf.${DATETIME}
    fi
  elif [ -f .$dotf -o -d .$dotf ]; then
    echo "update: .$dotf"
    mv .$dotf $dotf.${DATETIME}
  else
    echo "no link: $dotf"
    continue
  fi
  ln -sf $f .$dotf
done
popd

if !(type "wget" >/dev/null 2>&1); then
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
fi

