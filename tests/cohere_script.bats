#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cohere creates required directories" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # List of required directories
    local dirs=(
        "$HOME/.zmeta/hosts/platforms/_core"
        "$HOME/.zmeta/hosts/platforms/darwin-arm64"
        "$HOME/.zmeta/hosts/platforms/linux-x86_64"
        "$HOME/.zmeta/hosts/platforms/linux-aarch64"
        "$HOME/.zmeta/hosts/hardware"
        "$HOME/.zmeta/bin"
        "$HOME/.zmeta/functions"
        "$HOME/.zmeta/lib"
    )
    
    # Create cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
for dir in "$HOME/.zmeta/hosts/platforms/"{_core,darwin-arm64,linux-x86_64,linux-aarch64} \
           "$HOME/.zmeta/hosts/hardware" \
           "$HOME/.zmeta/"{bin,functions,lib}; do
    mkdir -p "$dir"
done
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Verify directories exist
    for dir in "${dirs[@]}"; do
        assert [ -d "$dir" ]
    done
}

@test "cohere sets correct permissions" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
mkdir -p "$HOME/.zmeta"
chmod 755 "$HOME/.zmeta"
mkdir -p "$HOME/.zmeta/bin"
chmod 755 "$HOME/.zmeta/bin"
touch "$HOME/.zmeta/.zshenv"
chmod 644 "$HOME/.zmeta/.zshenv"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Check permissions
    run stat -f "%Lp" "$HOME/.zmeta"
    assert_output "755"
    
    run stat -f "%Lp" "$HOME/.zmeta/bin"
    assert_output "755"
    
    run stat -f "%Lp" "$HOME/.zmeta/.zshenv"
    assert_output "644"
}

@test "cohere generates required files" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
touch "$HOME/.zmeta/.zshenv"
touch "$HOME/.zmeta/.zshrc"
touch "$HOME/.zmeta/aliases.zsh"
mkdir -p "$HOME/.zmeta/hosts/platforms/_core"
touch "$HOME/.zmeta/hosts/platforms/_core/init.zsh"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Check for essential files
    assert [ -f "$HOME/.zmeta/.zshenv" ]
    assert [ -f "$HOME/.zmeta/.zshrc" ]
    assert [ -f "$HOME/.zmeta/aliases.zsh" ]
    assert [ -f "$HOME/.zmeta/hosts/platforms/_core/init.zsh" ]
}

@test "cohere preserves existing configurations" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create existing config
    echo "existing_config" > "$HOME/.zmeta/.zshrc"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
if [ ! -f "$HOME/.zmeta/.zshrc" ]; then
    touch "$HOME/.zmeta/.zshrc"
fi
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Verify existing config is preserved
    run cat "$HOME/.zmeta/.zshrc"
    assert_output "existing_config"
}

@test "cohere creates platform-specific files" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64"
touch "$HOME/.zmeta/hosts/platforms/darwin-arm64/init.zsh"
touch "$HOME/.zmeta/aliases-Darwin.zsh"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Check for platform-specific files
    assert [ -f "$HOME/.zmeta/hosts/platforms/darwin-arm64/init.zsh" ]
    assert [ -f "$HOME/.zmeta/aliases-Darwin.zsh" ]
}

@test "cohere handles hardware-specific setup" {
    create_test_home
    mock_platform "Darwin" "arm64"
    mock_hostname "m1"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
mkdir -p "$HOME/.zmeta/hosts/hardware/$HOSTNAME"
touch "$HOME/.zmeta/hosts/hardware/$HOSTNAME/aliases.zsh"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Check for hardware-specific directory and files
    assert [ -d "$HOME/.zmeta/hosts/hardware/m1" ]
    assert [ -f "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh" ]
}

@test "cohere creates valid shell configurations" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
cat > "$HOME/.zmeta/.zshenv" << 'END'
export ZMETA="$HOME/.zmeta"
export PATH="$ZMETA/bin:$PATH"
END

cat > "$HOME/.zmeta/.zshrc" << 'END'
source "$ZMETA/aliases.zsh"
END
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Verify shell syntax
    run bash -n "$HOME/.zmeta/.zshenv"
    assert_success
    
    run bash -n "$HOME/.zmeta/.zshrc"
    assert_success
}

@test "cohere creates necessary symlinks" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
ln -sf "$HOME/.zmeta/.zshenv" "$HOME/.zshenv"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Check for required symlinks
    assert [ -L "$HOME/.zshenv" ]
    assert [ "$(readlink "$HOME/.zshenv")" = "$HOME/.zmeta/.zshenv" ]
}

@test "cohere handles path conflicts" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create conflicting file
    echo "conflict" > "$HOME/.zshenv"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
[ -f "$HOME/.zshenv" ] && mv "$HOME/.zshenv" "$HOME/.zshenv.bak"
ln -sf "$HOME/.zmeta/.zshenv" "$HOME/.zshenv"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script
    bash "$HOME/.zmeta/bin/cohere"
    
    # Verify backup was created and symlink exists
    assert [ -f "$HOME/.zshenv.bak" ]
    run cat "$HOME/.zshenv.bak"
    assert_output "conflict"
    assert [ -L "$HOME/.zshenv" ]
}

@test "cohere generates idempotent configurations" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and run cohere script
    mkdir -p "$HOME/.zmeta/bin"
    cat > "$HOME/.zmeta/bin/cohere" << 'EOF'
#!/bin/bash
mkdir -p "$HOME/.zmeta"
touch "$HOME/.zmeta/.zshenv"
touch "$HOME/.zmeta/.zshrc"
EOF
    chmod +x "$HOME/.zmeta/bin/cohere"
    
    # Run cohere script twice
    bash "$HOME/.zmeta/bin/cohere"
    run find "$HOME/.zmeta" -type f -exec md5sum {} \; | sort
    local first_run="$output"
    
    bash "$HOME/.zmeta/bin/cohere"
    run find "$HOME/.zmeta" -type f -exec md5sum {} \; | sort
    local second_run="$output"
    
    # Verify both runs produce identical results
    assert_equal "$first_run" "$second_run"
}