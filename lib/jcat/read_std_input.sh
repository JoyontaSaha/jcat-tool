#!/bin/bash

# Check if the first argument is a dash (-)
if [[ "$1" == "-" ]]; then
    # Read from standard input
    while IFS= read -r line; do
        echo "$line"
    done
elif [[ "$1" == "-n" ]]; then
    # Read from standard input with line numbering
    nl -ba
elif [[ "$1" == "-b" ]]; then
    # Read from standard input with line numbering on non-blank lines
    nl -bt
else
    echo "Usage: $0 [ - | -n | -b ]"
    echo "Provide a dash (-) to read from standard input."
    echo "Provide -n to add line numbering to all lines including blank lines."
    echo "Provide -b to add line numbering to all lines non-blank lines."
fi
