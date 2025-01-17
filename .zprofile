# Universal .zprofile - Platform agnostic configuration

# Basic environment setup
export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Ensure path arrays do not contain duplicates
typeset -gU path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# Universal path structure (will be extended by platform-specific init)
path=(
    $HOME/{,s}bin(N)
    $HOME/.local/{,s}bin(N)
    $HOME/{.arkade,.zmeta,.cargo,.docker}/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    /usr/bin(N)
    /bin(N)
    $path
)

# Source zmeta platform initialization if it exists
if [[ -n "$ZMETA" ]]; then
    typeset platform_init="${ZMETA}/hosts/platforms/$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)/init.zsh"
    [[ -f "$platform_init" ]] && source "$platform_init"
fi

# Export PATH for child processes
export PATH
