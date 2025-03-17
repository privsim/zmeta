# ~/.zmeta/hosts/platforms/linux-x86_64/init.zsh

# x86_64 Linux specific environment
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# x86_64 specific optimizations
export CFLAGS="-march=x86-64-v3 -mtune=generic"
export CXXFLAGS="$CFLAGS"

# Platform-specific paths
path=(
    /usr/local/bin
    /usr/bin
    /bin
    $path
)

# x86_64 Linux specific aliases
alias cpu_info="lscpu"
alias cpu_temp="sensors | grep Core"
alias mem_info="free -h"

# Setup platform-specific configurations
setup_x86_linux() {
    local CONFIG_DIR="$HOME/.config"
    local TEMPLATE_DIR="$ZMETA/templates/linux-x86"

    if [[ ! -d "$CONFIG_DIR" ]]; then
        echo "Setting up x86_64 Linux configuration..."
        mkdir -p "$CONFIG_DIR"
        [[ -d "$TEMPLATE_DIR" ]] && cp -r "$TEMPLATE_DIR"/* "$CONFIG_DIR/"
    fi
}

# Call setup functions
setup_x86_linux
