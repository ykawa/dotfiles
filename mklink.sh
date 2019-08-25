#!/bin/bash -vex
DATETIME=$(date +%Y%m%d%H%M%S)
LOCATION=$(cd $(dirname $0); pwd)
RELATIVE=${LOCATION##$HOME/}

pushd $HOME

touch .bash_profile .bashrc .gitconfig .globalrc .perltidyrc .screenrc .vimrc .vim .pythonstartup .Xmodmap .my.cnf .grcat .dircolors .hyper.js .tmux.conf
for f in ${RELATIVE}/*
do
  dotf=$(basename $f)
  if [ -L .$dotf ]; then
    readlink .$dotf | grep -q dotfiles
    if [ $? == 0 ]; then
      continue
    else
      echo -n "update: .$dotf"
      mv .$dotf $dotf.${DATETIME}
    fi
  elif [ -f .$dotf -o -d .$dotf ]; then
    echo -n "update: .$dotf"
    mv .$dotf $dotf.${DATETIME}
  else
    echo "no link: $dotf"
    continue
  fi
  ln -sf $f .$dotf
done
popd

if [ ! -e ~/.git-completion.bash ]; then
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash
fi
if [ ! -e ~/.git-prompt.sh ]; then
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
fi

