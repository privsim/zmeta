#
# .zshenv
# read by every instance of zsh shell (interactive or not) ie for global variables

### language
export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

# ZSH
export ZMETA=$HOME/.zmeta
export ZDOTDIR=$HOME/.zmeta
export ZINIT_HOME=$HOME/.zmeta/zinit

# XDG basedirs (https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_RUNTIME_DIR=~/.xdg

if [ -e /etc/os-release ]; then
  if [  $(grep -qi "ubuntu" /etc/os-release) ]; then
    skip_global_compinit=1
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
# set PATH so it includes user's arkade bin if it exists
if [ -d "$HOME/.arkade/bin" ]; then
  PATH="$HOME/.arkade/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes user's zmeta bin if it exists
if [ -d "$HOME/.zmeta/bin" ]; then
  PATH="$HOME/.zmeta/bin:$PATH"
fi

# set PATH so it includes user's .docker bin if it exists
if [ -d "$HOME/.docker/bin" ]; then
  PATH="$HOME/.docker/bin:$PATH"
fi

