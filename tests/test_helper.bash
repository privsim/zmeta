#!/usr/bin/env bash

# Load bats test helpers
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'
load '/usr/local/lib/bats-file/load.bash'

# Set up ZMETA environment variable
ZMETA="${BATS_TEST_DIRNAME}/.."
export ZMETA

# Create a temporary test directory
setup() {
    TEST_TEMP_DIR="$(mktemp -d)"
    export TEST_TEMP_DIR
    
    # Save original environment
    OLD_HOME="$HOME"
    OLD_HOSTNAME="$(hostname)"
    OLD_UNAME="$(uname)"
    OLD_UNAME_M="$(uname -m)"
}

# Clean up after each test
teardown() {
    # Restore original environment
    export HOME="$OLD_HOME"
    export HOSTNAME="$OLD_HOSTNAME"
    
    # Remove temporary directory
    rm -rf "$TEST_TEMP_DIR"
}

# Mock platform detection
mock_platform() {
    local os="$1"
    local arch="$2"
    
    function uname() {
        if [[ "$1" == "-m" ]]; then
            echo "$arch"
        else
            echo "$os"
        fi
    }
    export -f uname
}

# Mock hostname
mock_hostname() {
    local name="$1"
    function hostname() {
        echo "$name"
    }
    export -f hostname
    export HOSTNAME="$name"
}

# Create test home directory with required structure
create_test_home() {
    mkdir -p "${TEST_TEMP_DIR}/home/.zmeta"
    export HOME="${TEST_TEMP_DIR}/home"
}

# Helper to source a zsh file in bash context
source_zsh_file() {
    local file="$1"
    # Convert zsh syntax to bash compatible syntax
    sed 's/\[\[ /test /g; s/ \]\]//g' "$file" | source /dev/stdin
}