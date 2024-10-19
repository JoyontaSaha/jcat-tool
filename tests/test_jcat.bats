#!/usr/bin/env bats


@test "Single file" {
  # Create a test file
  echo "Hello World!" > test_file.txt
  # Run jcat with the test file
  run bin/jcat test_file.txt
  # Check the output
  [ "$output" = "Hello World!" ]
  rm test_file.txt
}

@test "Multiple files" {
  # Create test files
  echo "Hello" > test_file1.txt
  echo "World!" > test_file2.txt
  # Run jcat with multiple files
  run bin/jcat test_file1.txt test_file2.txt
  # Check the output
  [ "$output" = "Hello
World!" ]
  rm test_file1.txt test_file2.txt
}

@test "Standard input" {
  run bash bin/jcat - <<< "Hello, World!"
    
  # Assert the status is 0 (success)
  [ "$status" -eq 0 ]
    
  # Assert the output matches the input
  [ "$output" == "Hello, World!" ]
}

@test "Standard input with -n option" {
  input="Line 1

Line 3"

expected_output="     1	Line 1
     2	
     3	Line 3"
   
  run bash bin/jcat -n <<< "$input"

  printf "$output" > output_file.txt
  printf "$expected_output" > expected_output.txt

  diff ./output_file.txt  ./expected_output.txt
  
  [ "$status" -eq 0 ]
  [ $? -eq 0 ]
  
  rm output_file.txt expected_output.txt
}

@test "Standard input with -b option" {
  input="Line 1

Line 3"

expected_output="     1	Line 1
       
     2	Line 3"
   
  run bash bin/jcat -b <<< "$input"

  printf "$output" > output_file.txt
  printf "$expected_output" > expected_output.txt
   
  diff ./output_file.txt  ./expected_output.txt
  
  [ "$status" -eq 0 ]
  [ $? -eq 0 ]
  
  rm output_file.txt expected_output.txt
}

@test "Non-existent file" {
  run bin/jcat non_existent_file.txt
  [ "$status" -eq 1 ]
  [[ "$output" == *"Error: File 'non_existent_file.txt' does not exist."* ]]
}

@test "No arguments" {
  # Run jcat with no arguments
  run bin/jcat
  # Check the output
  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage: "* ]]
}