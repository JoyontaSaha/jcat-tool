#!/bin/bash

# Check if the first argument is a dash (-)
if [[ "$1" == "-" ]]; then
    # Read from standard input
    while IFS= read -r line; do
        echo "$line"
    done
else
    echo "Usage: $0 -"
    echo "Provide a dash (-) to read from standard input."
fi