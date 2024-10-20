#!/usr/bin/env bats

# Test reading a valid file
@test "Reading a valid file" {
    echo "Hello, World!" > testfile.txt
    run bash lib/jcat/read_file.sh testfile.txt
    echo "Script output: $output"
    echo "Exit status: $status"
    [ "$status" -eq 0 ]
    [ "$output" = "Hello, World!" ]
    rm testfile.txt
}

# Test handling of non-existent file
@test "Handling non-existent file" {
    run lib/jcat/read_file.sh non_existent_file.txt
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: File 'non_existent_file.txt' does not exist."* ]]
}

# Test handling of permission-denied file
@test "Handling permission-denied file" {
    touch testfile.txt
    chmod -r testfile.txt
    run lib/jcat/read_file.sh testfile.txt
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: File 'testfile.txt' is not readable."* ]]
    rm testfile.txt
}

# Test invalid number of arguments
@test "Invalid number of arguments" {
    run lib/jcat/read_file.sh
    [ "$status" -eq 1 ]
    [[ "$output" =~ Usage: ]]
}