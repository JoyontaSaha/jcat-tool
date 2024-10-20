#!/usr/bin/env bats

# Create a temporary test file for valid and permission-denied tests
setup() {
    echo "Hello, World!" > testfile.txt
    touch permission_denied_file.txt
    chmod 000 permission_denied_file.txt  # Make it unreadable
}

teardown() {
    rm -f testfile.txt permission_denied_file.txt
}

# Test reading a valid file
@test "Reading a valid file" {
    run bash lib/jcat/read_file.sh testfile.txt
    [ "$status" -eq 0 ]
    [ "$output" = "Hello, World!" ]
}

# Test handling of non-existent file
@test "Handling non-existent file" {
    run bash lib/jcat/read_file.sh non_existent_file.txt
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: File 'non_existent_file.txt' does not exist." ]]
}

# Test handling of permission-denied file
@test "Handling permission-denied file" {
    run bash lib/jcat/read_file.sh permission_denied_file.txt
    [ "$status" -eq 1 ]
    [[ "$output" =~ Error:\ File\ \'permission_denied_file.txt\'\ is\ not\ readable. ]]
}

# Test invalid number of arguments
@test "Invalid number of arguments" {
    run bash lib/jcat/read_file.sh
    [ "$status" -eq 1 ]
    [[ "$output" =~ Usage: ]]
}
