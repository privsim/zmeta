# ~/.zmeta/hosts/platforms/linux-aarch64/init.zsh

# ARM Linux specific environment
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib/aarch64-linux-gnu:$LD_LIBRARY_PATH"

# ARM-specific optimizations
export CFLAGS="-march=armv8-a+crc+crypto -mtune=cortex-a72"
export CXXFLAGS="$CFLAGS"

# Platform-specific paths
path=(
    /usr/local/bin
    /usr/bin
    /bin
    $path
)

# ARM Linux specific aliases
alias cpu_freq="cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq"
alias cpu_temp="cat /sys/class/thermal/thermal_zone*/temp"
alias mem_info="free -h"

# Setup platform-specific configurations
setup_arm_linux() {
    local CONFIG_DIR="$HOME/.config"
    local TEMPLATE_DIR="$ZMETA/templates/linux-arm"

    if [[ ! -d "$CONFIG_DIR" ]]; then
        echo "Setting up ARM Linux configuration..."
        mkdir -p "$CONFIG_DIR"
        [[ -d "$TEMPLATE_DIR" ]] && cp -r "$TEMPLATE_DIR"/* "$CONFIG_DIR/"
    fi
}

# Call setup functions
setup_arm_linux
