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

# set the list of directories that zsh searches for commands
path=(
    $HOME/{,s}bin(N)
    $HOME/.local/{,s}bin(N)
	$HOME/{.arkade,.zmeta,.cargo,.docker}/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $path
)

if [ -e /etc/os-release ]; then
  if [  $(grep -qi "ubuntu" /etc/os-release) ]; then
    skip_global_compinit=1
  fi
fi
