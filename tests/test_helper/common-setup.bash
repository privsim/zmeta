#!/usr/bin/env bash

_common_setup() {
    # Get the directory where this common-setup.bash file is located
    local dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    
    # Load bats helper libraries using relative paths
    load "${dir}/bats-support/load"
    load "${dir}/bats-assert/load"
    load "${dir}/bats-file/load"
    
    # Set up project root path
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
    
    # Save original environment
    OLD_HOME="$HOME"
    OLD_PATH="$PATH"
    OLD_HOSTNAME="$(hostname)"
}

# Create test home directory with required structure
create_test_home() {
    TEST_TEMP_DIR="$(mktemp -d)"
    mkdir -p "${TEST_TEMP_DIR}/home/.zmeta"/{hosts/{platforms/{_core,darwin-arm64,linux-x86_64,linux-aarch64},hardware},bin,functions,lib,log}
    export HOME="${TEST_TEMP_DIR}/home"
    export TEST_TEMP_DIR
}

# Mock platform detection
mock_platform() {
    local os="$1"
    local arch="$2"
    
    # Create a mock .zshenv that sets the platform directly
    cat > "$HOME/.zmeta/.zshenv" << EOF
export ZMETA="\$HOME/.zmeta"
export ZMETA_PLATFORM="${os,,}-${arch}"
export ZMETA_HARDWARE="\$HOSTNAME"

# Source core initialization
[ -f "\$ZMETA/hosts/platforms/_core/init.zsh" ] && . "\$ZMETA/hosts/platforms/_core/init.zsh"

# Source platform specific initialization
[ -f "\$ZMETA/hosts/platforms/\$ZMETA_PLATFORM/init.zsh" ] && . "\$ZMETA/hosts/platforms/\$ZMETA_PLATFORM/init.zsh"

# Add zmeta bin to PATH
export PATH="\$ZMETA/bin:\$PATH"
EOF

    # Create init files
    echo "export CORE_INIT_RAN=true" > "$HOME/.zmeta/hosts/platforms/_core/init.zsh"
    
    # Only create platform init file if it's a supported platform
    if [[ "${os,,}" == "darwin" || "${os,,}" == "linux" ]]; then
        echo "export PLATFORM_INIT_RAN=true" > "$HOME/.zmeta/hosts/platforms/${os,,}-${arch}/init.zsh"
    fi
}

# Mock hostname
mock_hostname() {
    local name="$1"
    export HOSTNAME="$name"
    # Create hardware directory if it doesn't exist
    mkdir -p "$HOME/.zmeta/hosts/hardware/$name"
}

# Helper to source a file
source_zsh_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return 1
    fi
    # Source the file directly since we're using bash-compatible syntax now
    source "$file"
}

# Helper to check if a string contains a substring
contains() {
    local string="$1"
    local substring="$2"
    [[ "$string" == *"$substring"* ]]
}

# Clean up after each test
teardown() {
    # Restore original environment
    export HOME="$OLD_HOME"
    export PATH="$OLD_PATH"
    export HOSTNAME="$OLD_HOSTNAME"
    
    # Unset test variables
    unset CORE_INIT_RAN
    unset PLATFORM_INIT_RAN
    unset ZMETA
    unset ZMETA_PLATFORM
    unset ZMETA_HARDWARE
    unset TEST_PERSIST_VAR
    unset TEMP_VAR
    unset TEST_VAR
    
    # Remove temporary directory if it exists
    if [ -n "$TEST_TEMP_DIR" ] && [ -d "$TEST_TEMP_DIR" ]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}