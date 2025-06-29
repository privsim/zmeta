#!/usr/bin/env bash
# Test runner for fish configuration - can be run from any shell

set -euo pipefail

ZMETA_DIR="$HOME/.zmeta"
FISH_CONFIG_DIR="$HOME/.config/fish"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

test_fish_installed() {
    info "Testing if fish is installed..."
    if ! command -v fish >/dev/null 2>&1; then
        error "Fish shell is not installed"
        return 1
    fi
    success "Fish shell is installed: $(which fish)"
    return 0
}

test_installation() {
    info "Testing installation..."
    
    # Check if config files exist and are symlinked
    if [ ! -L "$FISH_CONFIG_DIR/config.fish" ]; then
        error "config.fish is not a symlink or doesn't exist"
        return 1
    fi
    
    if [ ! -L "$FISH_CONFIG_DIR/conf.d/aliases.fish" ]; then
        error "aliases.fish is not a symlink or doesn't exist"
        return 1
    fi
    
    # Check symlinks point to zmeta
    local config_target=$(readlink "$FISH_CONFIG_DIR/config.fish")
    if [[ ! "$config_target" =~ zmeta/shells/fish/config/config.fish ]]; then
        error "config.fish symlink points to wrong location: $config_target"
        return 1
    fi
    
    success "Installation is correct - files are properly symlinked"
    return 0
}

test_no_infinite_loops() {
    info "Testing for infinite loops..."
    
    # Test that fish can start and exit within reasonable time
    if timeout 10s fish -c "echo 'No loops detected'; exit 0" >/dev/null 2>&1; then
        success "No infinite loops detected"
        return 0
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            error "Fish shell timed out - possible infinite loop"
        else
            error "Fish shell failed to start (exit code: $exit_code)"
        fi
        return 1
    fi
}

test_basic_functionality() {
    info "Testing basic functionality..."
    
    # Test command execution
    if ! fish -c "echo 'basic test'" | grep -q "basic test"; then
        error "Basic command execution failed"
        return 1
    fi
    
    # Test abbreviations are loaded
    local abbr_count=$(fish -c "abbr -l | wc -l" 2>/dev/null | tr -d ' ')
    if [ "$abbr_count" -eq 0 ]; then
        warning "No abbreviations loaded (this might be expected)"
    else
        success "Abbreviations loaded: $abbr_count"
    fi
    
    success "Basic functionality works"
    return 0
}

test_zmeta_integration() {
    info "Testing zmeta integration..."
    
    # Test ZMETA variable is set in fish
    if ! fish -c "echo \$ZMETA" | grep -q "zmeta"; then
        error "ZMETA variable not properly set in fish"
        return 1
    fi
    
    success "Zmeta integration works"
    return 0
}

run_fish_specific_tests() {
    info "Running fish-specific test suite..."
    
    if [ -f "$ZMETA_DIR/shells/fish/tests/test_fish_config.fish" ]; then
        timeout 45s fish "$ZMETA_DIR/shells/fish/tests/test_fish_config.fish"
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            error "Fish test suite timed out"
            return 1
        else
            return $exit_code
        fi
    else
        warning "Fish-specific test suite not found"
        return 0
    fi
}

run_all_tests() {
    echo "🐟 Testing Fish Configuration"
    echo "============================="
    
    local tests=(
        "test_fish_installed"
        "test_installation" 
        "test_no_infinite_loops"
        "test_basic_functionality"
        "test_zmeta_integration"
    )
    
    local passed=0
    local failed=0
    
    for test in "${tests[@]}"; do
        echo ""
        if $test; then
            ((passed++))
        else
            ((failed++))
        fi
    done
    
    echo ""
    echo "============================="
    echo "Summary:"
    echo "✅ Passed: $passed"
    echo "❌ Failed: $failed"
    echo "Total: $((passed + failed))"
    
    # Run fish-specific tests if basic tests pass
    if [ $failed -eq 0 ]; then
        echo ""
        echo "Running detailed fish tests..."
        if run_fish_specific_tests; then
            echo ""
            success "🎉 All tests passed! Fish configuration is working perfectly."
            return 0
        else
            failed=1
        fi
    fi
    
    if [ $failed -gt 0 ]; then
        echo ""
        error "Some tests failed. Please check the configuration."
        return 1
    fi
    
    return 0
}

# Show usage if no arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 [test_name|all]"
    echo ""
    echo "Available tests:"
    echo "  all                    - Run all tests"
    echo "  test_fish_installed    - Check if fish is installed"
    echo "  test_installation      - Check if configuration is installed"
    echo "  test_no_infinite_loops - Test for infinite loops"
    echo "  test_basic_functionality - Test basic fish functionality"
    echo "  test_zmeta_integration - Test zmeta integration"
    echo ""
    echo "Example: $0 all"
    exit 0
fi

# Run specific test or all tests
case "$1" in
    "all")
        run_all_tests
        ;;
    "test_fish_installed"|"test_installation"|"test_no_infinite_loops"|"test_basic_functionality"|"test_zmeta_integration")
        $1
        ;;
    *)
        error "Unknown test: $1"
        exit 1
        ;;
esac
