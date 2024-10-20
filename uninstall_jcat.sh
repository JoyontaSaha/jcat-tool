#!/bin/bash

# Define directories
JCAT="jcat"
BIN_DIR="/usr/bin/$JCAT"           # Real installation path
LIB_DIR="/usr/lib/$JCAT"            # Real installation path
MAN_DIR="/usr/share/man/man1"       # Real installation path
MAN_FILE="$MAN_DIR/jcat.1"          # Correctly define the man file

# Allow BASE_DIR for testing
if [ -n "$1" ]; then
    BASE_DIR="$1"
    BIN_DIR="$BASE_DIR/usr/bin/jcat"  
    LIB_DIR="$BASE_DIR/usr/lib/jcat"   
    MAN_DIR="$BASE_DIR/usr/share/man/man1"
    MAN_FILE="$MAN_DIR/jcat.1"
fi

# Ask for user input to proceed with uninstallation
read -p "Do you want to proceed with the uninstallation of jcat? (y/n): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')  # Convert choice to lowercase

if [ "$choice" = "y" ]; then
    # Step 1: Remove the jcat executable from the bin directory
    if [ -f "$BIN_DIR" ]; then
        sudo rm "$BIN_DIR" && echo "Removed $BIN_DIR" || { echo "Failed to remove $BIN_DIR."; exit 1; }
    else
        echo "$BIN_DIR not found."
    fi

    # Step 2: Remove the jcat directory from the library
    if [ -d "$LIB_DIR" ]; then
        sudo rm -r "$LIB_DIR" && echo "Removed $LIB_DIR" || { echo "Failed to remove $LIB_DIR."; exit 1; }
    else
        echo "$LIB_DIR not found."
    fi

    # Step 3: Remove the man page
    if [ -f "$MAN_FILE" ]; then
        sudo rm "$MAN_FILE" && echo "Removed $MAN_FILE" || { echo "Failed to remove $MAN_FILE."; exit 1; }
    else
        echo "$MAN_FILE not found."
    fi

    # Step 4: Update the man database
    sudo mandb
    echo "Uninstallation complete."
elif [ "$choice" = "n" ]; then
    echo "Uninstallation aborted."
else
    echo "Invalid input. Please enter 'y' or 'n'."
    exit 1  # Exit on invalid input
fi
