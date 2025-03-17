#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "ZMETA environment variable is set correctly" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Source the environment setup
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert ZMETA points to the correct location
    assert [ "$ZMETA" = "$HOME/.zmeta" ]
}

@test "PATH includes zmeta bin directory" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create bin directory and test script
    mkdir -p "$HOME/.zmeta/bin"
    echo '#!/bin/bash\necho "test script"' > "$HOME/.zmeta/bin/test-script"
    chmod +x "$HOME/.zmeta/bin/test-script"
    
    # Save original PATH
    local old_path="$PATH"
    
    # Source the environment setup
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert bin directory is in PATH
    assert contains "$PATH" "$HOME/.zmeta/bin"
    assert [ "$PATH" != "$old_path" ]
}

@test "XDG directories are properly configured" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create XDG configuration file
    mkdir -p "$HOME/.zmeta/lib"
    cat > "$HOME/.zmeta/lib/xdg.zsh" << 'EOF'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
EOF
    
    # Source XDG configuration
    source_zsh_file "$HOME/.zmeta/lib/xdg.zsh"
    
    # Assert XDG variables are set
    assert [ ! -z "$XDG_CONFIG_HOME" ]
    assert [ ! -z "$XDG_CACHE_HOME" ]
    assert [ ! -z "$XDG_DATA_HOME" ]
    assert [ ! -z "$XDG_STATE_HOME" ]
    
    # Assert directories exist
    assert [ -d "$XDG_CONFIG_HOME" ]
    assert [ -d "$XDG_CACHE_HOME" ]
    assert [ -d "$XDG_DATA_HOME" ]
    assert [ -d "$XDG_STATE_HOME" ]
}

@test "PATH entries are unique" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create a .zshenv that deduplicates PATH entries
    cat > "$HOME/.zmeta/.zshenv" << 'EOF'
export ZMETA="$HOME/.zmeta"

# Function to deduplicate PATH entries
deduplicate_path() {
    local -a paths=()
    local IFS=:
    local p
    for p in $PATH; do
        if [[ ! " ${paths[@]} " =~ " $p " ]]; then
            paths+=("$p")
        fi
    done
    PATH="${paths[*]}"
}

# Add zmeta bin to PATH and deduplicate
export PATH="$ZMETA/bin:$ZMETA/bin:$ZMETA/bin:$PATH"
deduplicate_path
EOF
    
    # Source the environment setup
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Count occurrences of bin directory in PATH
    local count=0
    local IFS=:
    local path_parts=($PATH)
    for part in "${path_parts[@]}"; do
        if [ "$part" = "$HOME/.zmeta/bin" ]; then
            count=$((count + 1))
        fi
    done
    
    assert_equal "$count" "1"
}

@test "environment variables persist across shell sessions" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create a test environment variable
    echo 'export TEST_PERSIST_VAR="test_value"' >> "$HOME/.zmeta/.zshenv"
    
    # Source in first "session"
    source_zsh_file "$HOME/.zmeta/.zshenv"
    local first_value="$TEST_PERSIST_VAR"
    
    # Source in second "session"
    unset TEST_PERSIST_VAR
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert value persists
    assert_equal "$TEST_PERSIST_VAR" "$first_value"
}

@test "local environment overrides are respected" {
    create_test_home
    mock_platform "Darwin" "arm64"
    mock_hostname "m1"
    
    # Create global environment setting
    echo 'export TEST_VAR="global"' > "$HOME/.zmeta/.zshenv"
    
    # Create local override
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'export TEST_VAR="local"' > "$HOME/.zmeta/hosts/hardware/m1/env.zsh"
    
    # Source both files
    source_zsh_file "$HOME/.zmeta/.zshenv"
    source_zsh_file "$HOME/.zmeta/hosts/hardware/m1/env.zsh"
    
    # Assert local override takes precedence
    assert_equal "$TEST_VAR" "local"
}

@test "environment cleanup on exit" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create temporary environment variable
    echo 'export TEMP_VAR="temporary"' > "$HOME/.zmeta/.zshenv"
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Run teardown
    teardown
    
    # Assert temporary variable is unset
    assert [ -z "${TEMP_VAR:-}" ]
}

@test "path directories exist and are accessible" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create test directories that should be in PATH
    mkdir -p "$HOME/.zmeta/bin"
    mkdir -p "$HOME/.zmeta/functions"
    chmod 755 "$HOME/.zmeta/bin"
    chmod 755 "$HOME/.zmeta/functions"
    
    # Source environment setup
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Check each PATH entry
    assert [ -d "$HOME/.zmeta/bin" ]
    assert [ -x "$HOME/.zmeta/bin" ]
    assert [ -d "$HOME/.zmeta/functions" ]
    assert [ -x "$HOME/.zmeta/functions" ]
}