#!/usr/bin/env bats

# Create a temporary test directory
setup() {
    mkdir -p /tmp/concatenate_files_test
    echo "This is a test file." > /tmp/concatenate_files_test/valid_file.txt
    echo "Another line in the test file." >> /tmp/concatenate_files_test/valid_file.txt
    touch /tmp/concatenate_files_test/unreadable_file.txt
    chmod -r /tmp/concatenate_files_test/unreadable_file.txt  # Make it unreadable
}

teardown() {
    rm -rf /tmp/concatenate_files_test
}

# Test with no arguments
@test "No arguments provided" {
    run bash lib/concatenate_files.sh
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: "* ]]
}

# Test with a valid file
@test "Valid file provided" {
    run bash lib/concatenate_files.sh /tmp/concatenate_files_test/valid_file.txt
    [ "$status" -eq 0 ]
    [ "$output" = "This is a test file.
Another line in the test file." ]
}

# Test with a non-existent file
@test "Non-existent file provided" {
    run bash lib/concatenate_files.sh /tmp/concatenate_files_test/non_existent_file.txt
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: /tmp/concatenate_files_test/non_existent_file.txt does not exist."* ]]
}

# Test with an unreadable file
@test "Unreadable file provided" {
    run bash lib/concatenate_files.sh /tmp/concatenate_files_test/unreadable_file.txt
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: /tmp/concatenate_files_test/unreadable_file.txt is not a readable file."* ]]
}

# Test with multiple files including valid and invalid ones
@test "Multiple files with valid and invalid" {
    run bash lib/concatenate_files.sh /tmp/concatenate_files_test/valid_file.txt /tmp/concatenate_files_test/non_existent_file.txt
    [ "$status" -eq 0 ]
    [[ "$output" =~ This\ is\ a\ test\ file. ]]
    [[ "$output" =~ Another\ line\ in\ the\ test\ file. ]]
    [[ "$output" =~ Error: ]]
}

# Test with multiple files where all are invalid
@test "Multiple invalid files" {
    run bash lib/concatenate_files.sh /tmp/concatenate_files_test/non_existent_file.txt /tmp/concatenate_files_test/unreadable_file.txt
    [ "$status" -eq 1 ]
    [[ "$output" =~ Error:.*does\ not\ exist. ]]
    [[ "$output" =~ Error:.*is\ not\ a\ readable\ file. ]]
}
