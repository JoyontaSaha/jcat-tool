#!/bin/bash

# Check if at least one file argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <file1> [<file2> ...]"
  exit 1
fi

# Iterate over the file arguments
for file in "$@"; do
  # Check if the file exists and is readable
  if [ ! -f "$file" ] || [ ! -r "$file" ]; then
    echo "Error: $file is not a readable file"
    exit 1
  fi

  # Concatenate the file contents to stdout
  while IFS= read -r line; do
    echo "$line"
  done < "$file"
done