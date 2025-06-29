#!/usr/bin/env fish
# Test suite for zmeta fish configuration

function test_environment_setup
    echo "Testing environment setup..."
    
    # Test ZMETA variable is set
    if not set -q ZMETA
        echo "❌ ZMETA environment variable not set"
        return 1
    end
    echo "✅ ZMETA variable set to: $ZMETA"
    
    # Test basic environment variables
    if not set -q EDITOR
        echo "❌ EDITOR not set"
        return 1
    end
    echo "✅ EDITOR set to: $EDITOR"
    
    # Test PATH includes expected directories
    if not echo $PATH | grep -q "$HOME/.local/bin"
        echo "❌ ~/.local/bin not in PATH"
        return 1
    end
    echo "✅ ~/.local/bin in PATH"
    
    return 0
end

function test_aliases
    echo "Testing aliases..."
    
    # Test that abbreviations are loaded
    set -l expected_abbrs cp mv rm .. g gs ga gc
    
    for abbr in $expected_abbrs
        if not abbr -l | grep -q "^$abbr\$"
            echo "❌ Alias '$abbr' not found"
            return 1
        end
        echo "✅ Alias '$abbr' loaded"
    end
    
    return 0
end

function test_config_files
    echo "Testing configuration files..."
    
    # Test main config file exists and is symlinked
    if not test -L ~/.config/fish/config.fish
        echo "❌ config.fish is not a symlink"
        return 1
    end
    echo "✅ config.fish is properly symlinked"
    
    # Test aliases file exists and is symlinked
    if not test -L ~/.config/fish/conf.d/aliases.fish
        echo "❌ aliases.fish is not a symlink"
        return 1
    end
    echo "✅ aliases.fish is properly symlinked"
    
    # Test symlinks point to correct zmeta location
    set config_target (readlink ~/.config/fish/config.fish)
    if not string match -q "*zmeta/shells/fish/config/config.fish" $config_target
        echo "❌ config.fish symlink points to wrong location: $config_target"
        return 1
    end
    echo "✅ config.fish symlink points to zmeta"
    
    return 0
end

function test_no_loops
    echo "Testing for infinite loops..."
    
    # Test that fish can start and exit cleanly within timeout
    timeout 5s fish -c "echo 'Loop test successful'; exit 0" >/dev/null 2>&1
    set exit_code $status
    
    if test $exit_code -eq 124  # timeout exit code
        echo "❌ Fish shell appears to have infinite loop (timed out)"
        return 1
    else if test $exit_code -ne 0
        echo "❌ Fish shell exited with error code: $exit_code"
        return 1
    end
    echo "✅ No infinite loops detected"
    
    return 0
end

function test_basic_functionality
    echo "Testing basic functionality..."
    
    # Test command execution
    if not fish -c "echo 'test'" | grep -q "test"
        echo "❌ Basic command execution failed"
        return 1
    end
    echo "✅ Basic command execution works"
    
    # Test cd functionality
    set original_dir (pwd)
    if not fish -c "cd /tmp; pwd" | grep -q "/tmp"
        echo "❌ Directory navigation failed"
        return 1
    end
    echo "✅ Directory navigation works"
    
    return 0
end

function test_tools_integration
    echo "Testing tool integrations..."
    
    # Test starship integration (if available)
    if type -q starship
        # Check if starship init doesn't cause errors
        if not fish -c "starship init fish" >/dev/null 2>&1
            echo "❌ Starship integration has errors"
            return 1
        end
        echo "✅ Starship integration works"
    else
        echo "ℹ️  Starship not installed (optional)"
    end
    
    # Test direnv integration (if available)
    if type -q direnv
        if not fish -c "direnv hook fish" >/dev/null 2>&1
            echo "❌ Direnv integration has errors"
            return 1
        end
        echo "✅ Direnv integration works"
    else
        echo "ℹ️  Direnv not installed (optional)"
    end
    
    return 0
end

function run_all_tests
    echo "🐟 Running Fish Configuration Tests"
    echo "=================================="
    
    set -l tests test_environment_setup test_config_files test_aliases test_no_loops test_basic_functionality test_tools_integration
    set -l passed 0
    set -l failed 0
    
    for test_func in $tests
        echo ""
        if eval $test_func
            set passed (math $passed + 1)
        else
            set failed (math $failed + 1)
        end
    end
    
    echo ""
    echo "=================================="
    echo "Test Results:"
    echo "✅ Passed: $passed"
    echo "❌ Failed: $failed"
    echo "Total: "(math $passed + $failed)
    
    if test $failed -eq 0
        echo ""
        echo "🎉 All tests passed! Fish configuration is working correctly."
        return 0
    else
        echo ""
        echo "⚠️  Some tests failed. Please check the configuration."
        return 1
    end
end

# Run tests if script is executed directly
if test (basename (status current-filename)) = "test_fish_config.fish"
    run_all_tests
end
