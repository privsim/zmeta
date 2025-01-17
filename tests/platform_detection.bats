#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "detect darwin-arm64 platform" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Source the platform detection logic
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert platform was correctly detected
    assert [ "$ZMETA_PLATFORM" = "darwin-arm64" ]
    assert [ -f "$HOME/.zmeta/hosts/platforms/darwin-arm64/init.zsh" ]
}

@test "detect linux-x86_64 platform" {
    create_test_home
    mock_platform "Linux" "x86_64"
    
    # Source the platform detection logic
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert platform was correctly detected
    assert [ "$ZMETA_PLATFORM" = "linux-x86_64" ]
    assert [ -f "$HOME/.zmeta/hosts/platforms/linux-x86_64/init.zsh" ]
}

@test "detect linux-aarch64 platform" {
    create_test_home
    mock_platform "Linux" "aarch64"
    
    # Source the platform detection logic
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert platform was correctly detected
    assert [ "$ZMETA_PLATFORM" = "linux-aarch64" ]
    assert [ -f "$HOME/.zmeta/hosts/platforms/linux-aarch64/init.zsh" ]
}

@test "fail gracefully for unsupported platform" {
    create_test_home
    mock_platform "SunOS" "sparc"
    
    # Source the platform detection logic
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert platform detection failed gracefully
    assert [ "$ZMETA_PLATFORM" = "sunos-sparc" ]
    assert [ ! -f "$HOME/.zmeta/hosts/platforms/$ZMETA_PLATFORM/init.zsh" ]
}

@test "core initialization runs before platform specific" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Source the initialization
    source_zsh_file "$HOME/.zmeta/.zshenv"
    
    # Assert initialization order
    assert [ "$CORE_INIT_RAN" = "true" ]
    assert [ "$PLATFORM_INIT_RAN" = "true" ]
}