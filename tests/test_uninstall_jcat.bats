@test "Uninstall jcat" {
    # Run the uninstallation script with "y" as input
    run bash uninstall_jcat.sh "$TEST_DIR" <<< "y"

    # Log output for debugging
    echo "Output: $output"

    # Check if the jcat executable was removed
    [ ! -f "$TEST_DIR/usr/bin/jcat" ]
    # Check if the jcat library directory was removed
    [ ! -d "$TEST_DIR/usr/lib/jcat" ]
    # Check if the jcat man page was removed
    [ ! -f "$TEST_DIR/usr/share/man/man1/jcat.1" ]
}
