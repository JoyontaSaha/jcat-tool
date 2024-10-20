#!/bin/bash

# jcat - A simple file concatenation tool

# Check if at least one file argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <file1> [<file2> ...]"
  exit 1
fi

# Initialize a flag to track if any valid files are found
valid_file_found=false

# Function to handle errors
handle_error() {
  local file="$1"
  local message="$2"
  echo "jcat::Error: $message"
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
  cat "$file"  # Concatenate the file contents to stdout
done

# Optional: Exit with status 1 if no valid files were found
if ! $valid_file_found; then
  echo "jcat::Error: No valid files were provided."
  exit 1
fi

# Exit successfully
exit 0
