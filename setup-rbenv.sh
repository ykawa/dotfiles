#!/bin/bash
#
# Usage:
#
#  bash ~/dotfiles/setup-rbenv.sh
#
#    or
#
#  curl -L https://raw.githubusercontent.com/ykawa/dotfiles/develop/setup-rbenv.sh | bash -
#
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

# rbenv
if [ ! -d .rbenv ]; then
  git clone https://github.com/rbenv/rbenv.git .rbenv
else
  git -C .rbenv pull --all -vv --prune
fi
if [ ! -e .rbenv/default-gems ]; then
  curl -L https://raw.githubusercontent.com/ykawa/dotfiles/develop/default-gems -o .rbenv/default-gems
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

curl -L https://raw.githubusercontent.com/ykawa/dotfiles/develop/ruby_ver.pl -o /tmp/ruby_ver.pl
RUBY_VERSION=$(curl -s "https://api.github.com/repos/ruby/ruby/tags" | perl /tmp/ruby_ver.pl)

cat <<EOF
# ----------------------------------------------------------------------
#  It is recommended to RELOAD.
#   exec \$SHELL -l
#
# ----------------------------------------------------------------------
# Libraries required for ruby-build are described at the following URLs.
#
#   https://github.com/rbenv/ruby-build/wiki
#   rbenv install ${RUBY_VERSION}
#
# ----------------------------------------------------------------------
EOF

cat <<EOF
# ----------------------------------------------------------------------
#  Add the following to your .bashrc or .zshrc
# ----------------------------------------------------------------------
if [ -d \$HOME/.rbenv ]; then
  export CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc --disable-install-capi"
  export PATH="\$HOME/.rbenv/bin:\$PATH"
  eval "\$(rbenv init -)"
  if [ -e ~/.rbenv/completions/rbenv.zsh ]; then
    . ~/.rbenv/completions/rbenv.zsh
  fi
fi
if builtin type gem >/dev/null 2>&1; then
  export PATH="\$PATH:\$(gem environment user_gemhome)/bin"
fi
EOF
