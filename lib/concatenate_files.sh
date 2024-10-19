#!/bin/bash

# Check if at least one file argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <file1> [<file2> ...]"
  exit 1
fi

# Initialize a flag to track if any valid files are found
valid_file_found=false

# Iterate over the file arguments
for file in "$@"; do
  # Check if the file exists and is readable
  if [ ! -f "$file" ]; then
    echo "jcat::Error: $file does not exist."
    continue  # Skip to the next file
  fi

  if [ ! -r "$file" ]; then
    echo "jcat::Error: $file is not a readable file."
    continue  # Skip to the next file
  fi

  # If the file is valid, set the flag to true
  valid_file_found=true
  
  # Concatenate the file contents to stdout
  while IFS= read -r line; do
    echo "$line"
  done < "$file"
done

# Optional: Exit with status 1 if no valid files were found
if [ "$valid_file_found" = false ]; then
  #echo "No valid files were provided."
  exit 1
fi

# Exit successfully
exit 0
