#
# .zshenv
# read by every instance of zsh shell (interactive or not) ie for global variables

### Language
export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# SOPS
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

# ZSH
export ZMETA=$HOME/.zmeta
export ZDOTDIR=$HOME/.zmeta
export ZINIT_HOME=$HOME/.zmeta/zinit
export ZSH_CACHE_DIR="$HOME/.local/share/zsh/zinit"

# XDG basedirs (https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=$HOME/.xdg

# Create directories if they don't exist
for dir in "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_RUNTIME_DIR" "$ZSH_CACHE_DIR"; do
  [ -d "$dir" ] || mkdir -p "$dir"
done

# Go path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Set the list of directories that zsh searches for commands
path=(
    $HOME/{,s}bin(N)
    $HOME/.local/{,s}bin(N)
    $HOME/{.arkade,.zmeta,.cargo,.docker}/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $path
)

# Avoid global compinit if running on Ubuntu
if [ -e /etc/os-release ]; then
  if grep -qi "ubuntu" /etc/os-release; then
    skip_global_compinit=1
  fi
fi

# Load Cargo environment (Rust)
. "$HOME/.cargo/env"
