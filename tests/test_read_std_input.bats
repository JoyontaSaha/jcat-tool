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

  run bash -c "printf \"$input\" | lib/jcat/read_std_input.sh -n"
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

# Test reading from standard input with line numbering on non-blank lines
@test "with -b argument" {
  input="Line 1

Line 3"
  expected="     1	Line 1
       
     2	Line 3"

  run bash -c "printf \"$input\" | lib/jcat/read_std_input.sh -b"
  printf "Output:\n%s\n" "$output"
  printf "Expected:\n%s\n" "$expected"
  [ "$status" -eq 0 ]
  # Create temporary files for expected and actual output
  expected_file=$(mktemp)
  output_file=$(mktemp)

  # Write expected and actual output to temporary files
  printf "%s" "$expected" > "$expected_file"
  printf "%s" "$output" > "$output_file"

  # Compare the two files
  if ! diff "$output_file" "$expected_file"; then
    printf "Output does not match expected.\n"
    exit 1
  fi

  # Clean up temporary files
  rm -f "$expected_file" "$output_file"
}

# Test usage message
@test "usage message" {
    run bash lib/jcat/read_std_input.sh
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: "* ]]
}

