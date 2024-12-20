# jcat
`jcat` is a simple command-line utility that concatenates files and prints the result to the standard output. It allows for various options such as line numbering and reading from standard input.

*Special thanks to [Coding Challenges](https://codingchallenges.fyi/challenges/challenge-cat/).*
# Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Downloading Test Files](#downloading-test-files)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Features
- **Version Information**: Display the version of `jcat`.
- **Help Information**: Show help and usage instructions.
- **Single File Concatenation**: Concatenate a single file.
- **Multiple Files Concatenation**: Concatenate multiple files.
- **Read from Standard Input**: Read from standard input and print to standard output.
- **Line Numbering**: Number all output lines.
- **Number Lines Including Blank Lines**: Number lines including blank lines.
- **Number Lines Excluding Blank Lines**: Number lines excluding blank lines.

## Installation

### Following guide is for  Unix-like systems (Linux, macOS, etc.)

### From Source
To install `jcat` from source, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/JoyontaSaha/jcat-tool.git
   ```
2.  Move to the project's root directory:
      ```bash
      cd jcat-tool
      ```
3. Grant executable permision:
   ```bash
   sudo chmod +x install_jcat.sh uninstall_jcat.sh

   ```

4. Run the installation script:
   ```bash
   sudo bash install_jcat.sh
   ```

## Man Page
```bash
man jcat
```

## Usage
```bash
jcat [options] [files...]
```

## Download Sample Test Input Files

To test `jcat`, you can download sample quote files from the following URLs:

0. **Install jq**:
   ```bash
   sudo apt install jq
   ```

1. **First Test File**:
   ```bash
   curl "https://dummyjson.com/quotes?limit=10" | jq '.quotes | .[] | .quote' > test.txt
   ```

2. **Second Test File**:
   ```bash
   curl "https://dummyjson.com/quotes?limit=10&skip=10" | jq '.quotes | .[] | .quote' > test2.txt
   ```

After downloading, you should have two files: `test.txt` and `test2.txt`, containing quotes.

## Examples

### 1. Display Version Information
To display the version of `jcat`:
```bash
jcat -v
```
**Output**:
```
jcat version 1.0.0
```

### 2. Display Help Information
To show help and usage instructions:
```bash
jcat -h
```
**Output**:
```
Usage: jcat [OPTION]... [FILE]...
       jcat [OPTION] -
```

### 3. Concatenate a Single File
To read and display the contents of `test.txt`:
```bash
jcat test.txt
```
**Output** (sample quotes):
```
"Life isn’t about getting and having, it’s about giving and being."
"Whatever the mind of man can conceive and believe, it can achieve."
"Strive not to be a success, but rather to be of value."
...
```

### 4. Concatenate Multiple Files
To read and display the contents of both `test.txt` and `test2.txt`:
```bash
jcat test.txt test2.txt
```
**Output** (sample quotes from both files):
```
"Life isn’t about getting and having, it’s about giving and being."
"Whatever the mind of man can conceive and believe, it can achieve."
...
"We become what we think about."
"The mind is everything. What you think you become."
...
```

### 5. Read from Standard Input
To read from standard input and print to standard output:
```bash
head -n1 test.txt | jcat -
```
**Output**:
```
"Life isn’t about getting and having, it’s about giving and being."
```

### 6. Number All Output Lines
To number all output lines from the first three lines of `test.txt`:
```bash
head -n3 test.txt | jcat -n
```
**Output**:
```
1  "Life isn’t about getting and having, it’s about giving and being."
2  "Whatever the mind of man can conceive and believe, it can achieve."
3  "Strive not to be a success, but rather to be of value."
```

### 7. Number Lines Including Blank Lines
To number lines including blank lines:
```bash
sed G test.txt | jcat -n | head -n4
```
**Output**:
```
1  "Life isn’t about getting and having, it’s about giving and being."
2
3  "Whatever the mind of man can conceive and believe, it can achieve."
4
```

### 8. Number Lines Excluding Blank Lines
To number lines excluding blank lines:
```bash
sed G test.txt | jcat -b | head -n5
```
**Output**:
```
 1  "Life isn’t about getting and having, it’s about giving and being."
 2  "Whatever the mind of man can conceive and believe, it can achieve."
 3  "Strive not to be a success, but rather to be of value."
```


## Uninstallation

Run the uninstallation script from the project's root directory:
```bash
sudo bash uninstall_jcat.sh
```
## Automated Testing

To ensure `jcat` works correctly, you can run automated tests using Bats (Bash Automated Testing System).

### Setup Bats

Projects's root directory clone the Bats repository into your tests directory:

```bash
git clone https://github.com/bats-core/bats-core.git tests/bats
```

### End-to-End Tests

Run all end-to-end tests with the following script:

```bash
./tests/run_tests.sh
```

### Individual Script Tests

Execute tests for individual scripts using Bats:

```bash
bash ./tests/bats/bin/bats ./tests/test_jcat.bats
```

```bash
bash ./tests/bats/bin/bats ./tests/test_read_file.bats
```

```bash
bash ./tests/bats/bin/bats ./tests/test_read_std_input.bats
```

```bash
bash ./tests/bats/bin/bats ./tests/test_concatenate_files.bats
```

```bash
bash ./tests/bats/bin/bats ./tests/test_install_jcat.bats
```

```bash
bash ./tests/bats/bin/bats ./tests/test_uninstall_jcat.bats
```

## Contribute
Contributions are welcome!

## License
Free for all.
