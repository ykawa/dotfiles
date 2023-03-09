#!/bin/bash
# set -e
# set -u
# set -x

hash -r

check_lacking_commands()
{
  for command in $@; do
    if ! type "$command" >/dev/null 2>&1; then
      echo "ERROR: < ${command} > is not available." >&2
      exit 1
    else
      echo "check ${command} ... ok"
    fi
  done
}

check_lacking_commands git perl curl

[ -z "$DEBUG_DOTFILES" ] || pushd $HOME

if [ ! -d dotfiles ]; then
  # This trick is to ignore the configuration status of ssh.
  git clone https://github.com/ykawa/dotfiles.git dotfiles
  git -C "dotfiles" remote set-url origin git@github.com:ykawa/dotfiles.git
fi

for df in dotfiles/dot.*; do
  link="${df##dotfiles/dot}"
  if [[ -e "${link}" || -L "${link}" ]]; then
    mv -fv "${link}" "${link}~"
  fi
  ln -s "${df}" "${link}"
done

mkdir -p .{bash,zsh}/completion
curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh              -o .bash/completion/git-prompt.sh
curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash        -o .bash/completion/git-completion.bash
curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose -o .bash/completion/docker-compose
curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh         -o .zsh/completion/_git
curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker             -o .zsh/completion/_docker
curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose -o .zsh/completion/_docker-compose

unset check_lacking_commands

# plenv
if [ ! -d .plenv ]; then
  git clone https://github.com/tokuhirom/plenv.git .plenv
else
  git -C .plenv pull --all -vv --prune
fi
if [ ! -d .plenv/plugins/perl-build ]; then
  git clone https://github.com/tokuhirom/Perl-Build.git .plenv/plugins/perl-build
else
  git -C .plenv/plugins/perl-build pull --all -vv --prune
fi
if [ ! -d .plenv/plugins/plenv-contrib ]; then
  git clone https://github.com/miyagawa/plenv-contrib.git .plenv/plugins/plenv-contrib
else
  git -C .plenv/plugins/plenv-contrib pull --all -vv --prune
fi
if [ ! -x .plenv/shims/cpanm ]; then
  export PATH="$PWD/.plenv/bin:$PATH"
  eval "$(plenv init -)"
  plenv global system
  plenv install-cpanm
fi

# nodebrew
if [ ! -x "$PWD/.nodebrew/current/bin/nodebrew" ]; then
  export NODEBREW_ROOT="$PWD/.nodebrew"
  curl -L https://raw.githubusercontent.com/hokaccha/nodebrew/master/nodebrew | perl - setup
else
  export PATH="$PWD/.nodebrew/current/bin:$PATH"
  nodebrew selfupdate
fi
if [ ! -x "$PWD/.nodebrew/current/bin/node" ]; then
  export PATH="$PWD/.nodebrew/current/bin:$PATH"
  nodebrew install stable
  nodebrew use stable
fi

# rbenv
if [ ! -d .rbenv ]; then
  git clone https://github.com/rbenv/rbenv.git .rbenv
else
  git -C .rbenv pull --all -vv --prune
fi
if [ ! -d .rbenv/plugins/ruby-build ]; then
  git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build
else
  git -C .rbenv/plugins/ruby-build pull --all -vv --prune
fi

cat <<EOF
# ----------------------------------------------------------------------
#  It is recommended to RELOAD.
#   exec \$SHELL -l
#
# ----------------------------------------------------------------------
# example of setting up plenv.
#
#   plenv install 5.36.0 -Dusethreads -Dman1dir=none -Dman3dir=none --as stable
#   plenv local stable
#   plenv install-cpanm
#
# ----------------------------------------------------------------------
# Libraries required for ruby-build are described at the following URLs.
#
#   https://github.com/rbenv/ruby-build/wiki
#   rbenv install 3.1.3
#
# ----------------------------------------------------------------------
EOF
