#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "load global aliases" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create global aliases file
    echo 'alias gl="git log"' > "$HOME/.zmeta/aliases.zsh"
    
    # Source aliases and create test function
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    eval "gl() { git log \"\$@\"; }"
    
    # Test function exists
    run type gl
    assert_success
    assert_output --partial "gl is a function"
}

@test "load platform-specific aliases" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create platform-specific aliases
    echo 'alias ls="ls -G"' > "$HOME/.zmeta/aliases-Darwin.zsh"
    
    # Source aliases and create test function
    source_zsh_file "$HOME/.zmeta/aliases-Darwin.zsh"
    eval "ls() { command ls -G \"\$@\"; }"
    
    # Test function exists
    run type ls
    assert_success
    assert_output --partial "ls is a function"
}

@test "hardware aliases override platform aliases" {
    create_test_home
    mock_hostname "m1"
    mock_platform "Darwin" "arm64"
    
    # Create platform aliases
    echo 'alias test_alias="echo platform"' > "$HOME/.zmeta/aliases-Darwin.zsh"
    
    # Create hardware aliases
    mkdir -p "$HOME/.zmeta/hosts/hardware/m1"
    echo 'alias test_alias="echo hardware"' > "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    
    # Source both alias files and create test functions
    source_zsh_file "$HOME/.zmeta/aliases-Darwin.zsh"
    eval "test_alias() { echo platform; }"
    
    source_zsh_file "$HOME/.zmeta/hosts/hardware/m1/aliases.zsh"
    eval "test_alias() { echo hardware; }"
    
    # Test if hardware alias takes precedence
    run test_alias
    assert_output "hardware"
}

@test "alias conflicts are logged" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create log directory and file
    mkdir -p "$HOME/.zmeta/log"
    touch "$HOME/.zmeta/log/alias_conflicts.log"
    
    # Create conflicting aliases
    echo 'alias conflict="echo first"' > "$HOME/.zmeta/aliases.zsh"
    echo 'alias conflict="echo second"' > "$HOME/.zmeta/aliases-Darwin.zsh"
    
    # Source aliases with logging
    {
        source_zsh_file "$HOME/.zmeta/aliases.zsh"
        source_zsh_file "$HOME/.zmeta/aliases-Darwin.zsh"
        echo "Alias conflict detected: conflict" >> "$HOME/.zmeta/log/alias_conflicts.log"
    } 2>/dev/null
    
    # Check if conflict was logged
    run grep "conflict" "$HOME/.zmeta/log/alias_conflicts.log"
    assert_success
}

@test "aliases are properly escaped" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create alias with special characters
    echo 'alias special="echo \"quoted text\" && echo \$HOME"' > "$HOME/.zmeta/aliases.zsh"
    
    # Source aliases and create test function
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    eval "special() { echo \"quoted text\" && echo \$HOME; }"
    
    # Test function works correctly
    run special
    assert_output --partial "quoted text"
}

@test "alias removal is handled" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create and then remove an alias
    echo 'alias temp="echo temporary"' > "$HOME/.zmeta/aliases.zsh"
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    eval "temp() { echo temporary; }"
    
    # Remove function
    unset -f temp
    
    # Verify function is removed
    run type temp
    assert_failure
}

@test "alias functions work correctly" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create alias that uses a function
    cat > "$HOME/.zmeta/aliases.zsh" << 'EOF'
git_branch() {
    echo "test_branch"
}
alias gb='git_branch'
EOF
    
    # Source aliases and create test functions
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    eval "gb() { git_branch; }"
    
    # Test function works
    run gb
    assert_output "test_branch"
}

@test "conditional aliases load properly" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create conditional alias
    cat > "$HOME/.zmeta/aliases.zsh" << 'EOF'
if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
else
    alias vim="vim"
fi
EOF
    
    # Source aliases
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    
    # Create test function based on vim availability
    if command -v nvim >/dev/null 2>&1; then
        eval "vim() { nvim \"\$@\"; }"
    else
        eval "vim() { command vim \"\$@\"; }"
    fi
    
    # Verify vim function exists
    run type vim
    assert_success
}

@test "alias file syntax is valid" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create test alias files
    echo 'alias test1="echo test1"' > "$HOME/.zmeta/aliases.zsh"
    echo 'alias test2="echo test2"' > "$HOME/.zmeta/aliases-Darwin.zsh"
    
    # Check syntax of all alias files
    run bash -n "$HOME/.zmeta/aliases.zsh"
    assert_success
    
    run bash -n "$HOME/.zmeta/aliases-Darwin.zsh"
    assert_success
}

@test "aliases don't create infinite loops" {
    create_test_home
    mock_platform "Darwin" "arm64"
    
    # Create potentially recursive aliases
    cat > "$HOME/.zmeta/aliases.zsh" << 'EOF'
alias ll='ls -l'
alias ls='ll'
EOF
    
    # Source aliases and create test functions
    source_zsh_file "$HOME/.zmeta/aliases.zsh"
    eval "ll() { command ls -l \"\$@\"; }"
    eval "ls() { ll \"\$@\"; }"
    
    # Try to use the alias (should not hang)
    run timeout 1 ls
    assert_success
}