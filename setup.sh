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

# bash-it
if [ ! -d .bash_it ]; then
  git clone --depth=1 https://github.com/Bash-it/bash-it.git .bash_it
  .bash_it/install.sh --silent --no-modify-config
else
  git -C .bash_it pull --all -vv --prune
fi

# Enable bash-it plugins and completions
if [ -f .bash_it/bash_it.sh ]; then
  export BASH_IT="$PWD/.bash_it"
  source "$BASH_IT/bash_it.sh"

  # Enable useful plugins
  bash-it enable plugin git ssh history npm docker

  # Enable useful completions
  bash-it enable completion git ssh npm docker

  # Enable useful aliases
  bash-it enable alias git docker
fi

# oh-my-zsh
if [ ! -d .oh-my-zsh ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git .oh-my-zsh
else
  git -C .oh-my-zsh pull --all -vv --prune
fi

# oh-my-zsh additional plugins
if [ -d .oh-my-zsh ]; then
  # zsh-autosuggestions
  if [ ! -d .oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions
  else
    git -C .oh-my-zsh/custom/plugins/zsh-autosuggestions pull --all -vv --prune
  fi

  # zsh-syntax-highlighting
  if [ ! -d .oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  else
    git -C .oh-my-zsh/custom/plugins/zsh-syntax-highlighting pull --all -vv --prune
  fi
fi

# mise
if ! type mise >/dev/null 2>&1; then
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# Set up .tool-versions file
if [ ! -e .tool-versions ]; then
  cat > .tool-versions << 'EOF'
node lts
ruby latest
perl latest
EOF
fi

cat <<EOF
# ----------------------------------------------------------------------
#  It is recommended to RELOAD.
#   exec \$SHELL -l
#
# ----------------------------------------------------------------------
# example of setting up mise.
#
#   mise install    # Install all tools in .tool-versions
#   mise use        # Activate tools for current directory
#
# ----------------------------------------------------------------------
# For more information about mise, visit:
#   https://mise.jdx.dev/
# ----------------------------------------------------------------------
EOF
