#!/bin/bash

# Default directories
BIN_DIR="/usr/bin"  # replace by user's OS bin dir path
JCAT_DIR="jcat"
LIB_DIR="/usr/lib/$JCAT_DIR"  # Fixed directory creation
MAN_DIR="/usr/share/man/man1"

# If a base directory is provided, override the default paths for mock test case execution
if [ -n "$1" ]; then
    BASE_DIR="$1"
    BIN_DIR="$BASE_DIR/bin"
    LIB_DIR="$BASE_DIR/lib/$JCAT_DIR"
    MAN_DIR="$BASE_DIR/share/man/man1"
fi

# Ask for user input to proceed with installation
read -p "Do you want to proceed with the installation? (y/n): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')  # Convert choice to lowercase

if [ "$choice" = "y" ]; then
    # Step 1: Ensure the library directory exists
    if [ -d "$BASE_DIR" ]; then
        sudo mkdir -p "$LIB_DIR" || { echo "Failed to create $LIB_DIR"; exit 1; }
    else
        sudo mkdir "$LIB_DIR" || { echo "Failed to create $LIB_DIR"; exit 1; }
    fi

    # Step 2: Copy jcat to the bin directory and make it executable
    if ! sudo cp bin/jcat "$BIN_DIR/"; then
        echo "Error: bin/jcat not found or failed to copy."
        exit 1
    fi
    sudo chmod +x "$BIN_DIR/jcat"

    # Step 3: Copy read_file.sh to the library directory and make it executable
    if ! sudo cp lib/"$JCAT_DIR"/read_file.sh "$LIB_DIR/"; then
        echo "Error: read_file.sh not found or failed to copy."
        exit 1
    fi
    sudo chmod +x "$LIB_DIR/read_file.sh"

    # Step 4: Copy read_std_input.sh to the library directory and make it executable
    if ! sudo cp lib/"$JCAT_DIR"/read_std_input.sh "$LIB_DIR/"; then
        echo "Error: read_std_input.sh not found or failed to copy."
        exit 1
    fi
    sudo chmod +x "$LIB_DIR/read_std_input.sh"

    # Step 5: Copy concatenate_files.sh to the library directory and make it executable
    if ! sudo cp lib/"$JCAT_DIR"/concatenate_files.sh "$LIB_DIR/"; then
        echo "Error: concatenate_files.sh not found or failed to copy."
        exit 1
    fi
    sudo chmod +x "$LIB_DIR/concatenate_files.sh"

    # Step 6: Copy jcat.1 to the man directory
    if ! sudo cp jcat.1 "$MAN_DIR/"; then
        echo "Error: jcat.1 not found or failed to copy."
        exit 1
    fi

    # Step 7: Update the man database if the man page exists
    if [ -f "$MAN_DIR/jcat.1" ]; then
        sudo mandb
    else
        echo "Man page not found; skipping mandb update."
    fi

    echo "Installation complete."
elif [ "$choice" = "n" ]; then 
    echo "Installation aborted."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
