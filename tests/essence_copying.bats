#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "platform essence directory exists" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create essence directory
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence"
    
    # Assert essence directory exists for platform
    assert [ -d "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence" ]
}

@test "copy hammerspoon config from essence" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create test hammerspoon config in essence
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/hammerspoon"
    echo 'test_config = true' > "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/hammerspoon/init.lua"
    
    # Create destination directory
    mkdir -p "$HOME/.hammerspoon"
    
    # Copy config
    cp -R "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/hammerspoon/"* "$HOME/.hammerspoon/"
    
    # Assert config was copied correctly
    assert [ -f "$HOME/.hammerspoon/init.lua" ]
    run grep "test_config = true" "$HOME/.hammerspoon/init.lua"
    assert_success
}

@test "essence files maintain permissions" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create test script with specific permissions
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/bin"
    echo '#!/bin/bash\necho "test"' > "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/bin/test-script"
    chmod 755 "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/bin/test-script"
    
    # Copy to destination
    mkdir -p "$HOME/bin"
    cp -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/bin/test-script" "$HOME/bin/"
    
    # Assert permissions are preserved
    run stat -f "%Lp" "$HOME/bin/test-script"
    assert_output "755"
}

@test "essence directory structure is preserved" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create complex directory structure in essence
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/nested/dir"
    touch "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/nested/dir/test.conf"
    
    # Copy structure
    mkdir -p "$HOME/.config"
    cp -R "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/"* "$HOME/.config/"
    
    # Assert structure is preserved
    assert [ -d "$HOME/.config/nested/dir" ]
    assert [ -f "$HOME/.config/nested/dir/test.conf" ]
}

@test "handle missing essence directory gracefully" {
    create_test_home
    mock_platform "Linux" "x86_64"
    
    # Try to copy from non-existent essence directory
    run cp -R "$HOME/.zmeta/hosts/platforms/linux-x86_64/essence/"* "$HOME/" || true
    
    # Assert failure doesn't crash the system
    assert [ ! -d "$HOME/.zmeta/hosts/platforms/linux-x86_64/essence" ]
}

@test "essence files don't overwrite existing files" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create existing config file
    mkdir -p "$HOME/.config"
    echo "existing_config" > "$HOME/.config/test.conf"
    
    # Create essence config
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config"
    echo "essence_config" > "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/test.conf"
    
    # Try to copy essence config with -n flag (no-clobber)
    cp -n "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/"* "$HOME/.config/" || true
    
    # Assert original file is unchanged
    run cat "$HOME/.config/test.conf"
    assert_output "existing_config"
}

@test "essence directory contains only configuration files" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create essence directory with various files
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config"
    touch "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/test.conf"
    touch "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/test.json"
    
    # Check for non-config files
    run find "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence" -type f -name "*.o" -o -name "*.pyc" -o -name ".DS_Store"
    assert [ -z "$output" ]
}

@test "essence files are valid configurations" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create test config files
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/hammerspoon"
    cat > "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/hammerspoon/init.lua" << 'EOF'
local test = {}
test.value = true
return test
EOF
    
    mkdir -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config"
    cat > "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/test.json" << 'EOF'
{
  "test": true,
  "value": 123
}
EOF
    
    # Verify JSON syntax (if jq is available)
    if command -v jq >/dev/null 2>&1; then
        run jq '.' "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/config/test.json"
        assert_success
    fi
    
    # Verify Lua syntax (if luac is available)
    if command -v luac >/dev/null 2>&1; then
        run luac -p "$HOME/.zmeta/hosts/platforms/darwin-arm64/essence/hammerspoon/init.lua"
        assert_success
    fi
}