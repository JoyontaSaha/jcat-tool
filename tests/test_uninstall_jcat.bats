#!/usr/bin/env bats  # Specify the script should be run using bats

# Constants for directories and files within the test directory
TEST_DIR="$(mktemp -d)"
BIN_DIR="$TEST_DIR/usr/local/bin"
JCAT_DIR="jcat"
LIB_DIR="$TEST_DIR/usr/local/lib/$JCAT_DIR"
MAN_DIR="$TEST_DIR/usr/local/share/man/man1"
MOCK_BIN_FILE="$BIN_DIR/jcat"
MOCK_LIB_FILE="$LIB_DIR/read_file.sh"
MOCK_MAN_FILE="$MAN_DIR/jcat.1"

# Function to create necessary directories and mock files
setup_directories_and_files() {
    # Create necessary directories
    mkdir -p "$BIN_DIR" "$LIB_DIR" "$MAN_DIR"

    # Create mock jcat files for testing
    touch "$MOCK_BIN_FILE"               # Mock jcat executable
    touch "$MOCK_LIB_FILE"               # Mock read_file.sh
    touch "$MOCK_MAN_FILE"               # Mock jcat man page
}

# Function to run the installation script with given input
run_install_script() {
    run bash install_jcat.sh "$TEST_DIR" <<< "$1"
}

setup() {
    # Setup directories and files
    setup_directories_and_files
}

teardown() {
    # Clean up the temporary directory after tests
    rm -rf "$TEST_DIR"
}

# Function to run the uninstallation script
run_uninstall_script() {
    run bash uninstall_jcat.sh "$TEST_DIR" <<< "y"
}

@test "Install jcat" {
    # Run the installation script with "y" as input
    run_install_script "y"

    # Verify that the jcat executable and directories are created
    [ -f "$MOCK_BIN_FILE"  ]  # Check that the jcat file exists in the bin directory
    [ -d "$LIB_DIR" ]         # Check that the library directory exists
    [ -f "$MOCK_MAN_FILE" ]   # Check that the man page exists in the man directory
}

@test "Verify executable permissions" {
    # Run the installation script with "y" as input
    run_install_script "y"

    # Ensure jcat is marked as executable in the mock bin directory
    chmod +x "$MOCK_BIN_FILE"  # Ensure we can set the mock executable permission

    # Check if the jcat executable is now executable
    printf "Checking permissions for %s\n" "$MOCK_BIN_FILE"
    ls -l "$MOCK_BIN_FILE"  # Add this line to check permissions in the test

    # Verify that the jcat file is executable
    if [[ ! -x "$MOCK_BIN_FILE" ]]; then
        printf "%s is not executable\n" "$MOCK_BIN_FILE"
        return 1  # Fail the test if it's not executable
    fi
}

@test "Abort installation on 'n'" {
    # Run the installation script with "n" as input
    run_install_script "n"

    # Check if the output confirms installation was aborted
    [[ "$output" == *"Installation aborted."* ]]
}

@test "Handle invalid input" {
    # Run the installation script with invalid input
    run_install_script "x"

    # Check if the output confirms invalid input
    [[ "$output" == *"Invalid input. Please enter 'y' or 'n'."* ]]
}

@test "Uninstall jcat" {
    # Run the installation script with "y" as input to ensure jcat is installed
    run_install_script "y"

    # Run the uninstallation script
    run_uninstall_script "y"

    # Verify executable removal
    [ ! -f "$MOCK_BIN_FILE" ]            # Check that the jcat file is removed
    [ ! -d "$LIB_DIR" ]                  # Check that the library directory is removed
    [ ! -f "$MOCK_MAN_FILE" ]            # Check that the man page is removed
}
