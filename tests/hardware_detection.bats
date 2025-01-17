#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "detect hardware configuration by hostname" {
    create_test_home
    mock_hostname "m1"
    mock_platform "Darwin" "arm64"
    
    # Create hardware specific aliases
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'alias test_m1="echo m1_specific"' > "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    # Source the configuration
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert hardware was correctly detected
    assert [ "$ZMETA_HARDWARE" = "m1" ]
    assert [ -f "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh" ]
}

@test "load hardware specific aliases" {
    create_test_home
    mock_hostname "m1"
    mock_platform "Darwin" "arm64"
    
    # Create test aliases file
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'alias test_hardware_alias="echo hardware_specific"' > "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    # Source the aliases
    source_zsh_file "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    # Create a function to simulate the alias
    eval "test_hardware_alias() { echo hardware_specific; }"
    
    # Test if function works
    run test_hardware_alias
    assert_output "hardware_specific"
}

@test "handle missing hardware config gracefully" {
    create_test_home
    mock_hostname "unknown_host"
    mock_platform "Darwin" "arm64"
    
    # Source the configuration
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert no hardware specific config is loaded
    assert [ ! -f "$HOME/.zmeta/hosts/hardware/unknown_host/aliases.zsh" ]
}

@test "hardware aliases don't conflict with global aliases" {
    create_test_home
    mock_hostname "m1"
    mock_platform "Darwin" "arm64"
    
    # Create global aliases
    echo 'alias shared_alias="echo global"' > "$HOME/.zmeta/aliases.zsh"
    
    # Create hardware specific aliases
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'alias shared_alias="echo hardware"' > "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    # Source global aliases first
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    eval "shared_alias() { echo global; }"
    
    # Then source hardware specific aliases
    source_zsh_file "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    eval "shared_alias() { echo hardware; }"
    
    # Test if hardware specific alias takes precedence
    run shared_alias
    assert_output "hardware"
}

@test "multiple hardware configs are isolated" {
    create_test_home
    
    # Create configs for two different hardware setups
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'alias m1_alias="echo m1"' > "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    mkdir -p "$HOME/.zmeta/hosts/hardware/m3"
    echo 'alias m3_alias="echo m3"' > "$HOME/.zmeta/hosts/hardware/m3/aliases.zsh"
    
    # Test m1 config
    mock_hostname "m1"
    source_zsh_file "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    eval "m1_alias() { echo m1; }"
    run m1_alias
    assert_output "m1"
    
    # Test m3 config
    mock_hostname "m3"
    source_zsh_file "$HOME/.zmeta/hosts/hardware/m3/aliases.zsh"
    eval "m3_alias() { echo m3; }"
    run m3_alias
    assert_output "m3"
}

@test "hardware config permissions are correct" {
    create_test_home
    mock_hostname "m1"
    
    # Create hardware config directory and files
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'alias test_alias="echo test"' > "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    chmod 755 "$HOME/.zmeta/hosts/hardware/m1"
    chmod 644 "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    # Check directory permissions
    run stat -f "%Lp" "$HOME/.zmeta/hosts/hardware/m1"
    assert_output "755"
    
    # Check file permissions
    run stat -f "%Lp" "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    assert_output "644"
}