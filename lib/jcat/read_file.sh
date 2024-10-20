#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "jcat::Error: File '$1' does not exist."
  exit 1
fi

# Check if the file is readable
if [ ! -r "$1" ]; then
  echo "jcat::Error: File '$1' is not readable."
  exit 1
fi

# Assign the first argument to the variable FILENAME
FILENAME=$1

# Read and print the file line by line
while IFS= read -r line; do
  echo "$line"
done < "$FILENAME"
