#!/usr/bin/env bats
PATH=$PATH:/usr/bin

# Test reading from standard input
@test "read from standard input" {
    run bash lib/jcat/read_std_input.sh - <<< "Hello, World!"
    [ "$status" -eq 0 ]
    [ "$output" == "Hello, World!" ]
}

# Test usage message without arguments
@test "no dash argument" {
    run bash lib/jcat/read_std_input.sh
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: "* ]]
}

# Test reading from standard input with line numbering
@test "with -n argument" {
  input="Line 1

Line 3"
  expected="     1	Line 1
     2	
     3	Line 3"

  run bash -c "echo \"$input\" | lib/jcat/read_std_input.sh -n"
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

# Test reading from standard input with line numbering on non-blank lines
@test "with -b argument" {
  input="Line 1

Line 3"
  expected="     1	Line 1
       
     2	Line 3"

  run bash -c "echo \"$input\" | lib/jcat/read_std_input.sh -b"
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

# Test usage message
@test "usage message" {
    run bash lib/jcat/read_std_input.sh
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: "* ]]
}
