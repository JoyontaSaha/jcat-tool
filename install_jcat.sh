#!/usr/bin/env bash

# Set BASE_DIR for testing or use default paths
BASE_DIR="${1:-}"
BIN_DIR="${BASE_DIR}/usr/local/bin"
LIB_DIR="${BASE_DIR}/usr/local/lib/jcat"
MAN_DIR="${BASE_DIR}/usr/local/share/man/man1"

# Function to display error messages and exit
error_exit() {
    printf "%s\n" "$1"  # Print the error message passed as an argument
    exit 1              # Exit the script with status 1
}

# Function to create directory if it does not exist
create_dir() {
    if [ ! -d "$1" ]; then
        sudo mkdir -p "$1" || error_exit "Failed to create $1"
        printf "Created directory %s\n" "$1"
    fi
}

# Function to copy files and set executable permissions
copy_and_set_permissions() {
    local source_file=$1
    local target_dir=$2

    # Check if the source is a directory
    if [ -d "$source_file" ]; then
        sudo cp -r "$source_file" "$target_dir/" || error_exit "Error: $source_file not found or failed to copy."
        printf "Copied directory %s to %s/\n" "$source_file" "$target_dir"
    else
        sudo cp "$source_file" "$target_dir/" || error_exit "Error: $source_file not found or failed to copy."
        printf "Copied file %s to %s/\n" "$source_file" "$target_dir"
        
        local target_file="$target_dir/$(basename "$source_file")"
        
        # Check file permissions before changing
        printf "Before chmod: %s\n" "$(ls -l "$target_file")"
        
        sudo chmod +x "$target_file"
        printf "Set executable permission for %s\n" "$target_file"
        
        # Check file permissions after changing
        printf "After chmod: %s\n" "$(ls -l "$target_file")"
    fi
}

# Function to update the MANPATH environment variable
update_manpath() {
    if [[ -z "$MANPATH" ]]; then  # If MANPATH is empty
        export MANPATH="/usr/local/share/man"
    else
        export MANPATH="/usr/local/share/man:$MANPATH"  # Append /usr/local/share/man to MANPATH
    fi
    printf "MANPATH updated to: %s\n" "$MANPATH"  # Inform user of the updated MANPATH
}

# Ask for user input to proceed with installation
read -p "Do you want to proceed with the installation? (y/n): " choice
choice="${choice,,}"  # Convert choice to lowercase

case "$choice" in
    "y")
        # Step 1: Copy bin/jcat script to BIN_DIR and set executable permissions
        copy_and_set_permissions "bin/jcat" "$BIN_DIR"

        # Step 2: Ensure the library directory exists
        create_dir "$LIB_DIR"

        # Step 3: Copy all files from lib/jcat to LIB_DIR and set executable permissions
        for file in lib/jcat/*; do  # Loop through each file in the lib/jcat directory
            copy_and_set_permissions "$file" "$LIB_DIR"
        done

        # Step 4: Ensure the man directory exists
        create_dir "$MAN_DIR"

        # Step 5: Copy jcat.1 to the man directory
        if ! sudo cp "jcat.1" "$MAN_DIR/"; then
            error_exit "Error: jcat.1 not found or failed to copy."
        fi
        printf "Copied jcat.1 to %s/\n" "$MAN_DIR"

        # Step 6: Update the man database if the man page exists
        if [ -f "$MAN_DIR/jcat.1" ]; then
            sudo mandb
        else
            printf "Man page not found; skipping mandb update.\n"
        fi

        # Update MANPATH
        update_manpath

        printf "Installation complete.\n"
        ;;
    "n")
        printf "Installation aborted.\n"
        ;;
    *)
        printf "Invalid input. Please enter 'y' or 'n'.\n"
        exit 1
        ;;
esac

# Exit successfully
exit 0
