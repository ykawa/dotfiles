# vim: set autoindent smartindent expandtab tabstop=2 softtabstop=2 shiftwidth=2 shiftround

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  echo "ctrl + c then break start X..." >&2
  sleep 3
  exec startx
fi

