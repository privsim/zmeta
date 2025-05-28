# Platform-specific initialization for darwin-arm64
typeset -g -U path
typeset platform_dir="${ZMETA}/hosts/platforms/darwin-arm64"
typeset essence_dir="${platform_dir}/essence"
typeset core_init="${ZMETA}/hosts/platforms/_core/init.zsh"

# Error checking for critical paths
if [[ ! -d "${ZMETA}/hosts/platforms/_core" ]]; then
    echo "Error: Core platform directory not found"
    return 1
fi

# Source core initialization
[[ -f "$core_init" ]] && source "$core_init"

# Critical environment and paths - immediate setup
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"

# Homebrew basic setup
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

path=(
    $HOME/{,s}bin(N)
    $HOME/.local/{,s}bin(N)
    $HOME/{.arkade,.zmeta,.cargo,.docker}/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $path
)

# Define platform-specific configurations for later zinit loading
typeset -gA DARWIN_ARM64_CONFIGS
DARWIN_ARM64_CONFIGS=(
#    compiler_flags "
#        export CFLAGS='-O2 -pipe -march=armv8-a+crypto -mtune=native'
#        export CXXFLAGS=\${CFLAGS}
#        export MAKEFLAGS='-j$(sysctl -n hw.ncpu)'
#        export LDFLAGS='-L/opt/homebrew/opt/openssl@3/lib'
#        export CPPFLAGS='-I/opt/homebrew/opt/openssl@3/include'
#        export ARCHFLAGS='-arch arm64'
#    "
    brew_settings "
        export HOMEBREW_NO_ANALYTICS=1
        export HOMEBREW_NO_ENV_HINTS=1
        export HOMEBREW_AUTOREMOVE=1
        export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=7
    "
)

# Define platform functions
darwin-arm64-check-tmux() {
    [[ -n "$TMUX" ]] && { echo "Running inside tmux session"; return 0; }
    return 1
}

darwin-arm64-cleanup() {
    brew cleanup
    brew autoremove
    rm -rf "$HOME/Library/Caches/Homebrew"/* 
    command rm -rf "$XDG_CACHE_HOME"/*/*
}

# Platform aliases
alias cleanup="darwin-arm64-cleanup"
alias tmux-check="darwin-arm64-check-tmux"

# Export platform info for .zshrc
export ZMETA_PLATFORM="darwin-arm64"
# Only export essence dir if it actually exists
[[ -d "$essence_dir" ]] && export ZMETA_ESSENCE_DIR="$essence_dir"
