#!/usr/bin/env bats
PATH=$PATH:/usr/bin

# Test reading from standard input
@test "read from standard input" {
    # Provide input via a here document
    run bash lib/jcat/read_std_input.sh - <<< "Hello, World!"
    
    # Assert the status is 0 (success)
    [ "$status" -eq 0 ]
    
    # Assert the output matches the input
    [ "$output" == "Hello, World!" ]
}

# Test without dash argument
@test "no dash argument" {
    run bash lib/jcat/read_std_input.sh
    
    # Assert the status is 0 (success)
    [ "$status" -eq 0 ]
    
    # Assert the output contains usage information
    [[ "$output" == *"Usage: "* ]]
}

# Test reading from standard input with line numbering
@test "with -n argument" {
  input="Line 1

Line 3"

expected_output="     1	Line 1
     2	
     3	Line 3"
   
  run bash lib/jcat/read_std_input.sh -n <<< "$input"

  printf "$output" > output_file.txt
  printf "$expected_output" > expected_output.txt

  diff ./output_file.txt  ./expected_output.txt
  
  [ "$status" -eq 0 ]
  [ $? -eq 0 ]
  
  rm output_file.txt expected_output.txt
}

# Test reading from standard input with line numbering on non-blank lines
@test "with -b argument" {
  input="Line 1

Line 3"

expected_output="     1	Line 1
       
     2	Line 3"
   
  run bash lib/jcat/read_std_input.sh -b <<< "$input"

  printf "$output" > output_file.txt
  printf "$expected_output" > expected_output.txt
   
  diff ./output_file.txt  ./expected_output.txt
  
  [ "$status" -eq 0 ]
  [ $? -eq 0 ]
  
  rm output_file.txt expected_output.txt
}

# Test usage message
@test "usage message" {
  # Run the script without any arguments
  run bash lib/jcat/read_std_input.sh

  # Assert the usage message is printed
  [[ "$output" == *"Usage: "* ]]
}

