#!/bin/bash

# Function to print error messages and exit with status
print_error() {
    printf "jcat::Error: %s\n" "$1"
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    print_error "Usage: $0 <filename>"
fi

# Assign the first argument to the variable FILENAME
FILENAME="$1"

# Check if the file exists
if [ ! -f "$FILENAME" ]; then
    print_error "File '$FILENAME' does not exist."
fi

# Check if the file is readable
if [ ! -r "$FILENAME" ]; then
    print_error "File '$FILENAME' is not readable."
fi

# Read and print the file line by line
while IFS= read -r line; do
    printf "%s\n" "$line"
done < "$FILENAME"

# Exit successfully
exit 0
