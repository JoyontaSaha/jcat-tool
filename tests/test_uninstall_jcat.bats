# In the BATS setup function, set up the mock directories and files
setup() {
    TEST_DIR=$(mktemp -d)
    mkdir -p "$TEST_DIR/usr/bin" "$TEST_DIR/usr/lib/jcat" "$TEST_DIR/usr/share/man/man1"

    touch "$TEST_DIR/usr/bin/jcat"               # Mock jcat executable
    touch "$TEST_DIR/usr/lib/jcat/read_file.sh"  # Mock jcat library file
    touch "$TEST_DIR/usr/share/man/man1/jcat.1"  # Mock jcat man page
}

@test "Uninstall jcat" {
    # Run the uninstallation script and pass TEST_DIR as an argument
    run bash uninstall_jcat.sh "$TEST_DIR" <<< "y"

    # Check if files are removed as expected
    [ ! -f "$TEST_DIR/usr/bin/jcat" ]            # Verify executable removal
    [ ! -d "$TEST_DIR/usr/lib/jcat" ]            # Verify library directory removal
    [ ! -f "$TEST_DIR/usr/share/man/man1/jcat.1" ]  # Verify man page removal
}
