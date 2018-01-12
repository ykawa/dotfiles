#!/bin/bash -vex
DATETIME=$(date +%Y%m%d%H%M%S)
LOCATION=$(cd $(dirname $0); pwd)
RELATIVE=${LOCATION##$HOME/}

pushd $HOME
for f in ${RELATIVE}/*
do
  [ ! -f $f ] && continue

  dotf=$(basename $f)
  if [ -L .$dotf ]; then
    echo -n "update: "
    readlink .$dotf
  elif [ -f .$dotf ]; then
    mv .$dotf $dotf.${DATETIME}
  elif [ -d .$dotf ]; then
    continue
  else
    echo "no link: $dotf"
    continue
  fi
  ln -sf $f .$dotf
  readlink .$dotf
done
popd

