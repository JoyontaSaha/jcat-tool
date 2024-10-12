#!/usr/bin/env bats

# Test concatenation of multiple files
@test "concatenate multiple files" {
  # Create some sample files
  echo "Hello" > file1.txt
  echo "World" > file2.txt
  echo " Foo" > file3.txt

  # Run the script with multiple file arguments
  run bash lib/concatenate_files.sh file1.txt file2.txt file3.txt

  # Assert the output is the concatenation of the file contents
  [ "$output" == "Hello
World
 Foo" ]  # Adjust this if the script outputs an extra newline

  # Clean up the sample files
  rm file1.txt file2.txt file3.txt
}

# Test with no file arguments
@test "no file arguments" {
  run bash lib/concatenate_files.sh

  # Assert the usage message is printed
  [[ "$output" == *"Usage: "* ]]
}

# Test with a non-readable file
@test "non-readable file" {
  touch file4.txt
  chmod 000 file4.txt

  run bash lib/concatenate_files.sh file4.txt

  # Assert an error message is printed
  [[ "$output" == *"Error: file4.txt is not a readable file"* ]]
}