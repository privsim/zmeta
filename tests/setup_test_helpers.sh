#!/bin/bash

# Create test helper directory if it doesn't exist
mkdir -p test_helper

# Initialize git submodules for bats helpers
git submodule add https://github.com/bats-core/bats-support test_helper/bats-support
git submodule add https://github.com/bats-core/bats-assert test_helper/bats-assert
git submodule add https://github.com/bats-core/bats-file test_helper/bats-file

# Initialize and update submodules
git submodule init
git submodule update

echo "Bats helper libraries have been set up as git submodules."
echo "You can now run the tests with: bats tests/*.bats"