#!/bin/bash -vex
DATETIME=$(date +%Y%m%d%H%M%S)
LOCATION=$(cd $(dirname $0); pwd)
RELATIVE=${LOCATION##$HOME/}

pushd $HOME

touch .bash_profile .bashrc .gitconfig .globalrc .perltidyrc .screenrc .vimrc .vim

for f in ${RELATIVE}/*
do
  dotf=$(basename $f)
  if [ -L .$dotf ]; then
    echo -n "update: "
    readlink .$dotf
  elif [ -f .$dotf -o -d .$dotf ]; then
    mv .$dotf $dotf.${DATETIME}
  else
    echo "no link: $dotf"
    continue
  fi
  ln -sf $f .$dotf
  readlink .$dotf
done
popd

