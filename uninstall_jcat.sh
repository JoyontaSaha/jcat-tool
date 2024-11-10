#!/usr/bin/env bash

# Set BASE_DIR for testing or use default paths
BASE_DIR="${1:-}"
BIN_DIR="${BASE_DIR}/usr/local/bin/jcat"
LIB_DIR="${BASE_DIR}/usr/local/lib/jcat"
MAN_FILE="${BASE_DIR}/usr/local/share/man/man1/jcat.1"

# Function to display a message and exit with status
function error_exit() {
    printf "%s\n" "$1"
    exit 1
}

# Function to attempt a file or directory removal
remove_item() {
    local item=$1
    local item_name=$2
    printf "Attempting to remove %s (%s)\n" "$item_name" "$item"
    if [ -e "$item" ]; then
        sudo rm -rf "$item" && printf "Removed %s\n" "$item_name" || error_exit "Failed to remove $item_name."
    else
        printf "%s not found, skipping.\n" "$item_name"
    fi
}

# Function to update the MANPATH environment variable
update_manpath() {
    if [[ -z "$MANPATH" ]]; then
        export MANPATH="/usr/local/share/man"
    else
        export MANPATH="/usr/local/share/man:$MANPATH"
    fi
    printf "MANPATH updated to: %s\n" "$MANPATH"
}

# Prompt user for confirmation
read -p "Do you want to proceed with the uninstallation of jcat? (y/n): " choice
choice=$(printf "%s" "$choice" | tr '[:upper:]' '[:lower:]')  # Normalize to lowercase

if [[ "$choice" == "y" ]]; then
    # Remove executable, library directory, and man page
    remove_item "$BIN_DIR" "jcat executable"
    remove_item "$LIB_DIR" "jcat library directory"
    remove_item "$MAN_FILE" "jcat man page"
    # Update MANPATH
    update_manpath
    printf "Uninstallation complete.\n"
else
    printf "Uninstallation aborted.\n"
    exit 0
fi
