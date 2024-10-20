#!/bin/bash

# Function to display usage information
display_usage() {
    echo "Usage: $0 [ - | -n | -b ]"
    echo "Provide a dash (-) to read from standard input."
    echo "Provide -n to add line numbering to all lines including blank lines."
    echo "Provide -b to add line numbering to non-blank lines only."
}

# Check if at least one argument is provided
if [[ $# -eq 0 ]]; then
    display_usage
    exit 1
fi

# Check the first argument
case "$1" in
    "-")
        # Read from standard input
        while IFS= read -r line; do
            echo "$line"
        done
        ;;
    "-n")
        # Read from standard input with line numbering
        nl -ba
        ;;
    "-b")
        # Read from standard input with line numbering on non-blank lines
        nl -bt
        ;;
    *)
        display_usage
        exit 1
        ;;
esac

# Exit successfully
exit 0
