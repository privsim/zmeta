#!/bin/bash

# Create output directory if it doesn't exist
mkdir -p tests/output

# Run tests and capture output
bats --formatter tap13 "$@" | tee tests/output/test_results.tap

# Also save detailed output with timing
bats --timing --print-output-on-failure "$@" > tests/output/test_details.log 2>&1

# Create a summary file
{
    echo "Test Run Summary"
    echo "================"
    echo "Time: $(date)"
    echo
    echo "Results:"
    grep -E "^# (ok|not ok)" tests/output/test_results.tap | sed 's/^# //'
    echo
    echo "Failed Tests:"
    grep -B2 -A2 "not ok" tests/output/test_details.log || echo "All tests passed!"
} > tests/output/summary.txt

# The test output files will be available at:
# - tests/output/test_results.tap (TAP13 format)
# - tests/output/test_details.log (Detailed output with timing)
# - tests/output/summary.txt (Human-readable summary)