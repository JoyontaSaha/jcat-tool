#!/bin/bash

# Default directories
BIN_DIR="/usr/bin"  # replace by user's OS bin dir path
JCAT_DIR="jcat"
LIB_DIR="/usr/lib/$JCAT_DIR"
MAN_DIR="/usr/share/man/man1"

# If a base directory is provided, override the default paths
if [[ -n "$1" ]]; then
    BASE_DIR="$1"
    BIN_DIR="$BASE_DIR/bin"
    LIB_DIR="$BASE_DIR/lib/$JCAT_DIR"
    MAN_DIR="$BASE_DIR/share/man/man1"
    # MKDIR_LIB='mkdir -p'
#else
    # MKDIR_LIB='mkdir'
fi

# Function to display error messages and exit
error_exit() {
    echo "$1"
    exit 1
}

# Ask for user input to proceed with installation
read -p "Do you want to proceed with the installation? (y/n): " choice
choice="${choice,,}"  # Convert choice to lowercase

case "$choice" in
    "y")
        
        # Step 0: Copy bin/jcat script to BIN_DIR and set executable permissions
        if ! sudo cp "bin/jcat" "$BIN_DIR/"; then
            error_exit "Error: jcat not found or failed to copy."
        fi
        echo "Copied jcat to $BIN_DIR/"

        # Check file permissions before changing
        echo "Before chmod: $(ls -l "$BIN_DIR/jcat")"

        sudo chmod +x "$BIN_DIR/jcat"
        echo "Set executable permission for $BIN_DIR/jcat"
        
        # Step 1: Ensure the library directory exists
        sudo mkdir -p "$LIB_DIR" || error_exit "Failed to create $LIB_DIR"

        # Step 2: Copy all files from lib/jcat to LIB_DIR and set executable permissions
        for file in lib/"$JCAT_DIR"/*; do
            if ! sudo cp "$file" "$LIB_DIR/"; then
                error_exit "Error: $file not found or failed to copy."
            fi
            echo "Copied $file to $LIB_DIR/"

            # Check file permissions before changing
            echo "Before chmod: $(ls -l "$LIB_DIR/$(basename "$file")")"

            sudo chmod +x "$LIB_DIR/$(basename "$file")"
            echo "Set executable permission for $LIB_DIR/$(basename "$file")"

            # Check file permissions after changing
            echo "After chmod: $(ls -l "$LIB_DIR/$(basename "$file")")"
        done

        # Step 6: Copy jcat.1 to the man directory
        if ! sudo cp jcat.1 "$MAN_DIR/"; then
            error_exit "Error: jcat.1 not found or failed to copy."
        fi

        # Step 7: Update the man database if the man page exists
        if [ -f "$MAN_DIR/jcat.1" ]; then
            sudo mandb
        else
            echo "Man page not found; skipping mandb update."
        fi

        echo "Installation complete."
        ;;
    "n")
        echo "Installation aborted."
        ;;
    *)
        echo "Invalid input. Please enter 'y' or 'n'."
        exit 1
        ;;
esac

# Exit successfully
exit 0
