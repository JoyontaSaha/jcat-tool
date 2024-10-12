#!/usr/bin/env bats

# Test reading from standard input
@test "read from standard input" {
    # Provide input via a here document
    run bash lib/read_std_input.sh - <<< "Hello, World!"
    
    # Assert the status is 0 (success)
    [ "$status" -eq 0 ]
    
    # Assert the output matches the input
    [ "$output" == "Hello, World!" ]
}

# Test without dash argument
@test "no dash argument" {
    run bash lib/read_std_input.sh
    
    # Assert the status is 0 (success)
    [ "$status" -eq 0 ]
    
    # Assert the output contains usage information
    [[ "$output" == *"Usage: "* ]]
}