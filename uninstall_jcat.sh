#!/usr/bin/env bash

# Constants for directory paths
readonly JCAT="jcat"
readonly BIN_DIR="/usr/bin/$JCAT"
readonly LIB_DIR="/usr/lib/$JCAT"
readonly MAN_DIR="/usr/share/man/man1"
readonly MAN_FILE="$MAN_DIR/jcat.1"

# Allow BASE_DIR for testing purposes
if [ -n "$1" ]; then
    BASE_DIR="$1"
    BIN_DIR="$BASE_DIR/usr/bin/$JCAT"
    LIB_DIR="$BASE_DIR/usr/lib/$JCAT"
    MAN_DIR="$BASE_DIR/usr/share/man/man1"
    MAN_FILE="$MAN_DIR/jcat.1"
fi

# Function to display a message and exit with status
function error_exit() {
    echo "$1"
    exit 1
}

# Ask for user input to proceed with uninstallation
read -p "Do you want to proceed with the uninstallation of jcat? (y/n): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')  # Convert choice to lowercase

if [[ "$choice" == "y" ]]; then
    # Step 1: Remove the jcat executable from the bin directory
    if [ -f "$BIN_DIR" ]; then
        echo "Attempting to remove $BIN_DIR..."
        sudo rm "$BIN_DIR" && echo "Removed $BIN_DIR" || error_exit "Failed to remove $BIN_DIR."
    else
        echo "$BIN_DIR not found."
    fi

    # Step 2: Remove the jcat directory from the library
    if [ -d "$LIB_DIR" ]; then
        echo "Attempting to remove $LIB_DIR..."
        sudo rm -r "$LIB_DIR" && echo "Removed $LIB_DIR" || error_exit "Failed to remove $LIB_DIR."
    else
        echo "$LIB_DIR not found."
    fi

    # Step 3: Remove the man page
    if [ -f "$MAN_FILE" ]; then
        echo "Attempting to remove $MAN_FILE..."
        sudo rm "$MAN_FILE" && echo "Removed $MAN_FILE" || error_exit "Failed to remove $MAN_FILE."
    else
        echo "$MAN_FILE not found."
    fi

    # Step 4: Update the man database
    sudo mandb
    echo "Uninstallation complete."
elif [[ "$choice" == "n" ]]; then
    echo "Uninstallation aborted."
else
    error_exit "Invalid input. Please enter 'y' or 'n'."
fi

# Exit successfully
exit 0
