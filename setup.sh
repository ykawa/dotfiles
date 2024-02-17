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

check_lacking_commands ssh git perl curl
unset check_lacking_commands

[ -z "$DEBUG_DOTFILES" ] || pushd $HOME

# Add github.com to ~/.ssh/known_hosts
ssh -T -n -o StrictHostKeyChecking=accept-new git@github.com

if [ ! -d dotfiles ]; then
  # This trick is to ignore the configuration status of ssh.
  git clone https://github.com/ykawa/dotfiles.git dotfiles
  git -C "dotfiles" remote set-url origin git@github.com:ykawa/dotfiles.git
fi

for df in dotfiles/dot.*; do
  link="${df##dotfiles/dot}"
  if [[ -e "${link}" || -L "${link}" ]]; then
    mv -fv "${link}" "${link}.bak"
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
if [ ! -x .nodebrew/current/bin/nodebrew ]; then
  export NODEBREW_ROOT="$PWD/.nodebrew"
  curl -L https://raw.githubusercontent.com/hokaccha/nodebrew/master/nodebrew | perl - setup
else
  export PATH="$PWD/.nodebrew/current/bin:$PATH"
  nodebrew selfupdate
fi
# node
if [ ! -x .nodebrew/current/bin/node ]; then
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
if [ ! -d .rbenv/plugins/rbenv-default-gems ]; then
  git clone https://github.com/rbenv/rbenv-default-gems.git .rbenv/plugins/rbenv-default-gems
else
  git -C .rbenv/plugins/rbenv-default-gems pull --all -vv --prune
fi
if [ ! -d .rbenv/plugins/rbenv-communal-gems ]; then
  git clone https://github.com/tpope/rbenv-communal-gems.git .rbenv/plugins/rbenv-communal-gems
else
  git -C .rbenv/plugins/rbenv-communal-gems pull --all -vv --prune
fi
touch .rbenv/default-gems
if ! grep -q '^pry$' .rbenv/default-gems; then
  echo 'pry' >> .rbenv/default-gems
fi
if ! grep -q '^awesome_print$' .rbenv/default-gems; then
  echo 'awesome_print' >> .rbenv/default-gems
fi
if ! grep -q '^rubocop$' .rbenv/default-gems; then
  echo 'rubocop' >> .rbenv/default-gems
fi
if ! grep -q '^solargraph$' .rbenv/default-gems; then
  echo 'solargraph' >> .rbenv/default-gems
fi

PERL_VERSION=5.38.2
if [ -e dotfiles/perl_ver.pl ]; then
  PERL_VERSION=$(curl -s "https://api.github.com/repos/Perl/perl5/tags" | perl dotfiles/perl_ver.pl)
fi

RUBY_VERSION=3.3.0
if [ -e dotfiles/ruby_ver.pl ]; then
  RUBY_VERSION=$(curl -s "https://api.github.com/repos/ruby/ruby/tags" | perl dotfiles/ruby_ver.pl)
fi

cat <<EOF
# ----------------------------------------------------------------------
#  It is recommended to RELOAD.
#   exec \$SHELL -l
#
# ----------------------------------------------------------------------
# example of setting up plenv.
#
#   plenv install ${PERL_VERSION} -Dusethreads -Dman1dir=none -Dman3dir=none --as stable
#   plenv local stable
#   plenv install-cpanm
#
# ----------------------------------------------------------------------
# Libraries required for ruby-build are described at the following URLs.
#
#   https://github.com/rbenv/ruby-build/wiki
#   rbenv install ${RUBY_VERSION}
#
# ----------------------------------------------------------------------
EOF
