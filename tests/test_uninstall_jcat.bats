#!/usr/bin/env bats

setup() {
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    # Mock directories
    mkdir -p "$TEST_DIR/usr/bin" "$TEST_DIR/usr/lib/jcat" "$TEST_DIR/usr/share/man/man1"
    # Create mock executable and man page
    touch "$TEST_DIR/usr/bin/jcat"                 # Mock jcat executable
    touch "$TEST_DIR/usr/share/man/man1/jcat.1"    # Mock jcat man page
}

teardown() {
    # Clean up the temporary directory after tests
    rm -rf "$TEST_DIR"
}

@test "Uninstall jcat" {
    # Run the uninstallation script with "y" as input
    run bash uninstall_jcat.sh "$TEST_DIR" <<< "y"

    # Check if the jcat executable was removed
    [ ! -f "$TEST_DIR/usr/bin/jcat" ]
    # Check if the jcat library directory was removed
    [ ! -d "$TEST_DIR/usr/lib/jcat" ]
    # Check if the jcat man page was removed
    [ ! -f "$TEST_DIR/usr/share/man/man1/jcat.1" ]
}

@test "Abort uninstallation on 'n'" {
    # Run the uninstallation script with "n" as input
    run bash uninstall_jcat.sh "$TEST_DIR" <<< "n"

    # Check if the output confirms uninstallation was aborted
    [[ "$output" == *"Uninstallation aborted."* ]]
}

@test "Handle invalid input" {
    # Run the uninstallation script with invalid input
    run bash uninstall_jcat.sh "$TEST_DIR" <<< "x"

    # Check if the output confirms invalid input
    [[ "$output" == *"Invalid input. Please enter 'y' or 'n'."* ]]
}
