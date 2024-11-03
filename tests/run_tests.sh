#!/bin/bash

# Define the path to the Bats binary
BATS_BIN="./tests/bats/bin/bats"

# Array of helper test scripts
helper_tests=(
    "./tests/test_read_file.bats"
    "./tests/test_read_std_input.bats"
    "./tests/test_concatenate_files.bats"
    "./tests/test_install_jcat.bats"
    "./tests/test_uninstall_jcat.bats"
)

# Initialize counters for passed and failed tests
passed=0
failed=0

# Array to track failed tests
failed_tests=()

printf "\033[1;1;38;5;214m\033[4mRUNNING ALL TEST SCRIPTS FOR JCAT TOOL...\033[0m\n"

# Execute helper test scripts
for test in "${helper_tests[@]}"; do
    printf "Running helper test: %s\n" "$test"
    $BATS_BIN "$test"
    if [ $? -ne 0 ]; then
        failed=$((failed + 1))
        failed_tests+=("$test")
        printf "Test failed: %s\n" "$test"
    else
        passed=$((passed + 1))
    fi
done

# Run the main test script
printf "Running main test: ./tests/test_jcat.bats\n"
$BATS_BIN "./tests/test_jcat.bats"
if [ $? -ne 0 ]; then
    failed=$((failed + 1))
    failed_tests+=("./tests/test_jcat.bats")
    printf "Main test failed: ./tests/test_jcat.bats\n"
else
    passed=$((passed + 1))
fi

# Print summary of results
printf "\n\033[0;34mSummary of test results:\033[0m\n"
printf "\033[0;32m\xE2\x9C\x94 Passed tests: %d\n" "$passed"
printf "\033[0;31m\xE2\x9D\x8CFailed tests: %d\n" "$failed"

if [ "$failed" -eq 0 ]; then
    printf "\n\033[1;32m\xE2\x9C\x94 All tests passed successfully!\033[0m\n"
else
    printf "\033[1;31m\xE2\x9D\x8C Some tests failed.\033[0m\n"
    printf "\n\033[1;31mFailed tests:\033[0m\n"
    for failed_test in "${failed_tests[@]}"; do
        printf " - %s\n" "$failed_test"
    done
    exit 1
fi

