# ZMETA Test Suite

This test suite provides comprehensive testing for the ZMETA dotfiles management system using bats-core.

## Prerequisites

The test suite uses the following bats helper libraries as git submodules:
- bats-support
- bats-assert
- bats-file

## Setup

1. Initialize and update the submodules:
```bash
cd ~/.zmeta
git submodule add https://github.com/bats-core/bats-support tests/test_helper/bats-support
git submodule add https://github.com/bats-core/bats-assert tests/test_helper/bats-assert
git submodule add https://github.com/bats-core/bats-file tests/test_helper/bats-file
git submodule init
git submodule update
```

## Running Tests

The test suite includes a custom test runner that captures and formats test output:

```bash
# Run all tests
./tests/run_tests.sh tests/*.bats

# Run specific test file
./tests/run_tests.sh tests/platform_detection.bats
```

Test results are saved in the following locations:
- `tests/output/test_results.tap` - TAP13 format output
- `tests/output/test_details.log` - Detailed output with timing
- `tests/output/summary.txt` - Human-readable summary

You can also run tests directly with bats:
```bash
# Run all tests
bats tests/*.bats

# Run specific test file
bats tests/platform_detection.bats

# Run with detailed output
bats --print-output-on-failure tests/*.bats
```

## Test Structure

```
tests/
├── test_helper/
│   ├── common-setup.bash    # Common test utilities and setup
│   ├── bats-support/        # Submodule
│   ├── bats-assert/        # Submodule
│   └── bats-file/          # Submodule
├── output/                 # Test results directory
│   ├── test_results.tap    # TAP13 format output
│   ├── test_details.log    # Detailed output with timing
│   └── summary.txt        # Human-readable summary
├── run_tests.sh           # Custom test runner
├── platform_detection.bats # Tests for OS/architecture detection
├── hardware_detection.bats # Tests for hostname-based config
├── environment_setup.bats  # Tests for PATH and env management
├── essence_copying.bats    # Tests for config inheritance
├── cohere_script.bats     # Tests for directory/file generation
└── alias_management.bats  # Tests for alias handling
```

## Test Coverage

1. Platform Detection (`platform_detection.bats`)
   - OS and architecture detection
   - Platform-specific initialization
   - Core initialization order

2. Hardware Detection (`hardware_detection.bats`)
   - Hostname-based configuration
   - Hardware-specific aliases
   - Config isolation

3. Environment Setup (`environment_setup.bats`)
   - PATH management and deduplication
   - XDG directory configuration
   - Environment variable persistence

4. Essence Copying (`essence_copying.bats`)
   - Configuration inheritance
   - Permission preservation
   - Directory structure validation

5. Cohere Script (`cohere_script.bats`)
   - Directory creation
   - File generation
   - Symlink management
   - Conflict handling

6. Alias Management (`alias_management.bats`)
   - Global and platform-specific aliases
   - Conflict resolution
   - Syntax validation

## Test Helper Functions

The test suite provides several helper functions in `test_helper/common-setup.bash`:

### Setup and Teardown
- `_common_setup`: Loads bats helper libraries and sets up the test environment
- `create_test_home`: Creates an isolated test environment with required directory structure
- `teardown`: Cleans up temporary files and directories after each test

### Mocking Functions
- `mock_platform`: Sets up a mock platform environment (OS and architecture)
- `mock_hostname`: Sets up a mock hostname environment
- `source_zsh_file`: Sources a zsh file in a bash-compatible way
- `contains`: Helper function to check if a string contains a substring

Example:
```bash
@test "example test" {
    create_test_home
    mock_platform "Darwin" "arm64"
    mock_hostname "m1"
    
    # Test implementation
}
```

## Best Practices

When adding new tests:

1. Use the provided helper functions
2. Create isolated test environments
3. Clean up after tests
4. Test both success and failure cases
5. Verify file permissions and ownership
6. Check for path conflicts
7. Validate configuration syntax
8. Test edge cases

## Debugging Tests

For debugging:

1. Check the test output files:
```bash
# View test results in TAP13 format
cat tests/output/test_results.tap

# View detailed output with timing
cat tests/output/test_details.log

# View human-readable summary
cat tests/output/summary.txt
```

2. Add debug output in tests:
```bash
echo "# Debug: variable=$variable" >&3
```

3. Run tests with timing information:
```bash
./tests/run_tests.sh --timing tests/*.bats
```

4. Run specific tests:
```bash
./tests/run_tests.sh tests/specific_test.bats -f "test name"