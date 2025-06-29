#!/usr/bin/env bash
# Continuous Integration test for fish configuration
# Returns 0 for success, 1 for failure

set -euo pipefail

# Run simple tests with timeout and return appropriate exit code
if timeout 45s /Users/lclose/.zmeta/shells/fish/tests/simple_test.sh >/dev/null 2>&1; then
    echo "✅ Fish configuration tests: PASSED"
    exit 0
else
    local exit_code=$?
    echo "❌ Fish configuration tests: FAILED (exit code: $exit_code)"
    echo "Run for details: fish-manager test"
    echo "Or quick test:  fish-manager test-quick"
    exit 1
fi
