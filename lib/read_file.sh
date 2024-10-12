#!/bin/bash

# Function: Display usage information
usage() {
    echo "Usage: $0 <file-path>"
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Error: Invalid number of arguments."
    usage
fi

FILE_PATH="$1"

# Check if the file exists
if [ ! -e "$FILE_PATH" ]; then
    echo "Error: File does not exist."
    exit 1
fi

# Check if the file is readable
if [ ! -r "$FILE_PATH" ]; then
    echo "Error: File is not readable."
    exit 1
fi

# Output the content of the file
while IFS= read -r line; do
    echo "$line"
done < "$FILE_PATH"