#!/bin/bash -vex
DATETIME=$(date +%Y%m%d%H%M%S)
LOCATION=$(cd $(dirname $0); pwd)

pushd $HOME
for f in ${LOCATION}/.*
do
  [ ! -f $f ] && continue
  dotf=$(basename $f)
  if [ -L $dotf ]; then
    echo -n " $dotf -> " 1>&2
    readlink $dotf
    continue
  elif [ -f $dotf ]; then
    mv $dotf $dotf.${DATETIME}
  else
    echo "WARN: $dotf"
    continue
  fi
  ln -sf $f
  readlink $dotf
done
popd

