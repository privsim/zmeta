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

source "${HOME}/.zmeta/lib/xdg.zsh"

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
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
