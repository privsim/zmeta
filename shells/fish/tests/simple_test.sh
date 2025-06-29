#!/usr/bin/env bash
# Simplified test runner to debug the hanging issue

set -euo pipefail

ZMETA_DIR="$HOME/.zmeta"
FISH_CONFIG_DIR="$HOME/.config/fish"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🐟 Simple Fish Test Runner"
echo "=========================="

# Test 1: Fish installed
echo ""
info "1. Testing if fish is installed..."
if command -v fish >/dev/null 2>&1; then
    success "Fish is installed: $(which fish)"
else
    error "Fish is not installed"
    exit 1
fi

# Test 2: Configuration installed
echo ""
info "2. Testing configuration..."
if [ -L "$FISH_CONFIG_DIR/config.fish" ]; then
    success "Config files are symlinked"
else
    error "Config files not properly installed"
    exit 1
fi

# Test 3: Basic fish execution
echo ""
info "3. Testing basic fish execution..."
if timeout 10s fish -c "echo 'Fish works'" | grep -q "Fish works"; then
    success "Fish executes correctly"
else
    error "Fish execution failed"
    exit 1
fi

# Test 4: Abbreviations loaded
echo ""
info "4. Testing abbreviations..."
abbr_count=$(timeout 10s fish -c "abbr -l | wc -l" 2>/dev/null | tr -d ' ' || echo "0")
if [ "$abbr_count" -gt 0 ]; then
    success "Abbreviations loaded: $abbr_count"
else
    error "No abbreviations loaded"
    exit 1
fi

# Test 5: Fish-specific test suite
echo ""
info "5. Running fish test suite..."
if timeout 30s fish "$ZMETA_DIR/shells/fish/tests/test_fish_config.fish" >/dev/null 2>&1; then
    success "Fish test suite passed"
else
    error "Fish test suite failed or timed out"
    exit 1
fi

echo ""
echo "=========================="
success "🎉 All tests passed!"
