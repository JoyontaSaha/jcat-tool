#!/bin/bash

# Check if at least one file argument is provided
if [ $# -eq 0 ]; then
  printf "Usage: %s <file1> [<file2> ...]\n" "$0"
  exit 1
fi

# Initialize a flag to track if any valid files are found
valid_file_found=false

# Function to handle errors
handle_error() {
  local file="$1"
  local message="$2"
  printf "jcat::Error: %s\n" "$message"
}

# Iterate over the file arguments
for file in "$@"; do
  # Check if the file exists and is readable
  if [ ! -e "$file" ]; then
    handle_error "$file" "does not exist."
    continue  # Skip to the next file
  fi

  if [ ! -r "$file" ]; then
    handle_error "$file" "is not a readable file."
    continue  # Skip to the next file
  fi

  # If the file is valid, set the flag to true and concatenate its contents
  valid_file_found=true
  # Use IFS to split the file contents into an array and then
  # loop through the array to print each line
  while IFS= read -r line; do
    printf "%s\n" "$line"
  done < "$file"
done

# Optional: Exit with status 1 if no valid files were found
if ! $valid_file_found; then
  printf "jcat::Error: No valid files were provided.\n"
  exit 1
fi

# Exit successfully
exit 0
