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
        # Step 1: Ensure the library directory exists
        sudo mkdir -p "$LIB_DIR" || error_exit "Failed to create $LIB_DIR"

        # Step 2: Copy scripts and set executable permissions
        for script in jcat lib/"$JCAT_DIR"/read_file.sh lib/"$JCAT_DIR"/read_std_input.sh lib/"$JCAT_DIR"/concatenate_files.sh; do
            if ! sudo cp "$script" "$BIN_DIR/"; then
                error_exit "Error: $script not found or failed to copy."
            fi
            echo "Copied $script to $BIN_DIR/"

            # Check file permissions before changing
            echo "Before chmod: $(ls -l "$BIN_DIR/$(basename "$script")")"

            sudo chmod +x "$BIN_DIR/$(basename "$script")"
            echo "Set executable permission for $BIN_DIR/$(basename "$script")"

            # Check file permissions after changing
            echo "After chmod: $(ls -l "$BIN_DIR/$(basename "$script")")"
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
