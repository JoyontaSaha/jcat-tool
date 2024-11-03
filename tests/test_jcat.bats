#!/usr/bin/env bats

setup() {
  # Create temporary directory for test files
  TEST_DIR="$(mktemp -d)"
  export TEST_DIR
}

teardown() {
  # Clean up temporary directory
  rm -rf "$TEST_DIR"
}

@test "Display help message" {
  run bin/jcat --help
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "jcat - concatenate and print files" ]]
}

@test "Display version information" {
  run bin/jcat --version
  [ "$status" -eq 0 ]
  [[ "$output" == "jcat version 1.0.0" ]]
}

@test "Single file" {
  printf "Hello World!\n" > "$TEST_DIR/test_file.txt"
  run bin/jcat "$TEST_DIR/test_file.txt"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello World!" ]
}

@test "Multiple files" {
  printf "Hello\n" > "$TEST_DIR/test_file1.txt"
  printf "World!\n" > "$TEST_DIR/test_file2.txt"
  run bin/jcat "$TEST_DIR/test_file1.txt" "$TEST_DIR/test_file2.txt"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello
World!" ]
}

@test "Standard input" {
  run bash -c 'printf "Hello, World!\n" | bin/jcat -'
  [ "$status" -eq 0 ]
  [ "$output" = "Hello, World!" ]
}

@test "Standard input with -n option" {
  input="Line 1

Line 3"
  expected="     1	Line 1
     2	
     3	Line 3"

  run bash -c "printf \"$input\" | bin/jcat -n"
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

@test "Standard input with -b option" {
  input="Line 1

Line 3"
  expected="     1	Line 1
       
     2	Line 3"

  run bash -c "printf \"$input\" | bin/jcat -b"
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

@test "Non-existent file" {
  run bin/jcat "non_existent_file.txt"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Error: File 'non_existent_file.txt' does not exist."* ]]
}

@test "No arguments" {
  run bin/jcat
  [ "$status" -eq 1 ]
  [[ "$output" == *"jcat::Error: No arguments provided."* ]]
  [[ "$output" == *"Usage: "* ]]
}
