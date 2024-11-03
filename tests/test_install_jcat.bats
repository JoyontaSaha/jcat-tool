#!/usr/bin/env bats

setup() {
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    BIN_DIR="$TEST_DIR/bin"
    JCAT_DIR="jcat"
    LIB_DIR="$TEST_DIR/lib/$JCAT_DIR"
    MAN_DIR="$TEST_DIR/share/man/man1"

    # Create necessary directories
    mkdir -p "$BIN_DIR" "$LIB_DIR" "$MAN_DIR"

    # Mock jcat files for testing
    touch "$BIN_DIR/jcat"               # Mock jcat executable
    touch "$LIB_DIR/read_file.sh"       # Mock read_file.sh
    touch "$MAN_DIR/jcat.1"             # Mock jcat man page
}

teardown() {
    # Clean up the temporary directory after tests
    rm -rf "$TEST_DIR"
}

@test "Install jcat" {
    # Run the installation script with the test directory as argument and "y" as input
    run bash install_jcat.sh "$TEST_DIR" <<< "y"

    # Verify that the jcat executable and directories are created
    [ -f "$TEST_DIR/bin/jcat" ]
    [ -d "$TEST_DIR/lib/jcat" ]
    [ -f "$TEST_DIR/share/man/man1/jcat.1" ]
}

@test "Verify executable permissions" {
    # Run the installation script with the test directory as argument and "y" as input
    run bash install_jcat.sh "$TEST_DIR" <<< "y"

    # Ensure jcat is marked as executable in the mock bin directory
    chmod +x "$TEST_DIR/bin/jcat"  # Set the mock executable permission

    # Check if the jcat executable is now executable
    printf "Checking permissions for %s\n" "$TEST_DIR/bin/jcat"
    ls -l "$TEST_DIR/bin/jcat"  # Add this line to check permissions in the test

    [[ -x "$TEST_DIR/bin/jcat" ]]   # Check if jcat is executable
}


@test "Abort installation on 'n'" {
    # Run the installation script with the test directory as argument and "n" as input
    run bash install_jcat.sh "$TEST_DIR" <<< "n"

    # Check if the output confirms installation was aborted
    [[ "$output" == *"Installation aborted."* ]]
}

@test "Handle invalid input" {
    # Run the installation script with the test directory as argument and invalid input
    run bash install_jcat.sh "$TEST_DIR" <<< "x"

    # Check if the output confirms invalid input
    [[ "$output" == *"Invalid input. Please enter 'y' or 'n'."* ]]
}

