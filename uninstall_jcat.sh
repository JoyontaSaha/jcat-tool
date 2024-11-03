#!/usr/bin/env bash

# Constants for directory paths
readonly JCAT="jcat"
readonly BIN_DIR="/usr/bin/$JCAT"  # replace by user's OS bin dir path
readonly LIB_DIR="/usr/lib/$JCAT"  # replace by user's OS lib dir path
readonly MAN_DIR="/usr/share/man/man1"  # replace by user's OS man dir path
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
    printf "%s\n" "$1"
    exit 1
}

# Ask for user input to proceed with uninstallation
read -p "Do you want to proceed with the uninstallation of jcat? (y/n): " choice
choice=$(printf "%s" "$choice" | tr '[:upper:]' '[:lower:]')  # Convert choice to lowercase

if [[ "$choice" == "y" ]]; then
    # Step 1: Remove the jcat executable from the bin directory
    if [ -f "$BIN_DIR" ]; then
        printf "Attempting to remove %s...\n" "$BIN_DIR"
        sudo rm "$BIN_DIR" && printf "Removed %s\n" "$BIN_DIR" || error_exit "Failed to remove $BIN_DIR."
    else
        printf "%s not found.\n" "$BIN_DIR"
    fi

    # Step 2: Remove the jcat directory from the library
    if [ -d "$LIB_DIR" ]; then
        printf "Attempting to remove %s...\n" "$LIB_DIR"
        sudo rm -r "$LIB_DIR" && printf "Removed %s\n" "$LIB_DIR" || error_exit "Failed to remove $LIB_DIR."
    else
        printf "%s not found.\n" "$LIB_DIR"
    fi

    # Step 3: Remove the man page
    if [ -f "$MAN_FILE" ]; then
        printf "Attempting to remove %s...\n" "$MAN_FILE"
        sudo rm "$MAN_FILE" && printf "Removed %s\n" "$MAN_FILE" || error_exit "Failed to remove $MAN_FILE."
    else
        printf "%s not found.\n" "$MAN_FILE"
    fi

    # Step 4: Update the man database
    sudo mandb
    printf "Uninstallation complete.\n"
elif [[ "$choice" == "n" ]]; then
    printf "Uninstallation aborted.\n"
else
    error_exit "Invalid input. Please enter 'y' or 'n'."
fi

# Exit successfully
exit 0

