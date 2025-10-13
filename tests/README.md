# Test Suite for Contextual Development Tools

This directory contains comprehensive tests for the contextual development tools project.

## Quick Start

Run all tests with a single command:

```bash
./contextual test           # Run all tests
./contextual test --list    # List all test categories
./contextual test --verbose # Run with detailed output
```

## Test Structure

All tests are organized into categories and run through a unified test runner that provides consolidated reporting.

### Test Files

- **`run-tests.sh`** - Unified test runner (run all tests)

- **`unit/`** - Unit tests directory
  - **`test-print-utils.sh`** - Tests for print-utils.sh
  - **`test-branch-utils.sh`** - Tests for branch-utils.sh
  - **`test-analysis-utils.sh`** - Tests for analysis-utils.sh
  - **`test-env-utils.sh`** - Tests for env-utils.sh
  - **`test-config-utils.sh`** - Tests for config-utils.sh
  
- **`integration/`** - Integration tests directory
  - **`test-simple.sh`** - Basic install script functionality tests
  - **`test-install.sh`** - Comprehensive install script tests
  - **`test-contextual-scripts.sh`** - Tests for contextual workflow scripts
  - **`test-install-legacy.sh`** - Original unit tests (legacy)
  
- **`utils/`** - Test utilities directory
  - **`test-framework.sh`** - Bash unit testing framework

### Test Categories

1. **Install Script Tests** (`simple-test.sh`, `install-test.sh`)
   - Help functionality
   - Error handling
   - New project installation
   - Existing project updates
   - Custom contextual root installation
   - Agent-specific structure creation
   - Argument parsing

2. **Contextual Scripts Tests** (`contextual-scripts-test.sh`)
   - Script existence and executability
   - Script syntax validation
   - Script sourcing without errors
   - Directory structure validation
   - Cursor command files validation

3. **Unit Tests** (`unit/`)
   - **Print Utils** - Tests for output formatting functions
   - **Branch Utils** - Tests for branch naming and feature management
   - **Analysis Utils** - Tests for project analysis utilities
   - **Env Utils** - Tests for environment validation
   - **Config Utils** - Tests for configuration management
   - Each test suite validates individual function behavior
   - Includes mock testing and edge case coverage

## Usage

### Running All Tests (Recommended)

The unified test runner consolidates all test categories and provides comprehensive reporting:

```bash
# Run all tests (unit + integration)
./contextual test

# Alternative: run directly from tests directory
./tests/run-tests.sh

# Run with detailed output
./contextual test --verbose

# Run quietly (errors only)
./contextual test --quiet
```

### Listing Available Tests

```bash
# List all test categories and individual tests
./contextual test --list
```

### Running Specific Test Categories

```bash
# Run a specific unit test
bash tests/unit/test-print-utils.sh
bash tests/unit/test-branch-utils.sh

# Run a specific integration test
bash tests/integration/test-simple.sh
bash tests/integration/test-install.sh
```

### Cleanup

```bash
# Clean up test artifacts
./contextual test --cleanup
```

### Getting Help

```bash
# Show help information
./contextual test --help
```

## Test Framework

The test suite includes a custom bash unit testing framework (`utils/test-framework.sh`) that provides:

### Testing Utilities

- **`init_test_suite(name)`** - Initialize a test suite with a name
- **`assert_equals(expected, actual, message)`** - Assert two values are equal
- **`assert_not_empty(value, message)`** - Assert a value is not empty
- **`assert_empty(value, message)`** - Assert a value is empty
- **`assert_success(message, command...)`** - Assert a command succeeds
- **`assert_failure(message, command...)`** - Assert a command fails
- **`assert_file_exists(path, message)`** - Assert a file exists
- **`assert_dir_exists(path, message)`** - Assert a directory exists
- **`assert_contains(haystack, needle, message)`** - Assert string contains substring
- **`print_test_summary()`** - Print test results summary
- **`create_test_dir()`** - Create temporary test directory
- **`cleanup_test_dir(path)`** - Clean up test directory

### Test Structure

Each unit test file follows this structure:

```bash
#!/bin/bash
set -euo pipefail

# Source test framework
source "path/to/test-framework.sh"

# Source module under test
source "path/to/module.sh"

# Test functions
test_feature_name() {
    local result=$(function_to_test "input")
    assert_equals "expected" "$result" "Test description"
}

# Main test runner
main() {
    init_test_suite "Test Suite Name"
    test_feature_name
    print_test_summary
    exit $?
}

main "$@"
```

## Test Features

### Unified Test Runner

The consolidated test framework (`./contextual test`) provides:

- **Category-based Organization**: Tests organized into logical categories (Unit Tests, Integration Tests)
- **Consolidated Reporting**: Single summary showing all test categories and overall results
- **Flexible Output**: Verbose, normal, and quiet modes for different use cases
- **Fast Execution**: Parallel test execution where possible
- **Automatic Cleanup**: Cleans up test artifacts after execution

### Comprehensive Coverage

- **Unit Tests** (tests/unit/): Fast, isolated tests for bash utility functions
  - Print utilities (output formatting)
  - Branch utilities (feature management)
  - Analysis utilities (project analysis)
  - Environment utilities (validation)
  - Configuration utilities (config management)
  - 97 individual test cases with mock support

- **Integration Tests** (tests/integration/): End-to-end tests for complete workflows
  - Install script functionality (test-install.sh)
  - Simple workflow tests (test-simple.sh)
  - Contextual scripts validation (test-contextual-scripts.sh)
  - Project setup and updates
  - Directory structure verification
  - 69+ individual test cases

### Test Output

- **Colored Output**: Easy-to-read test results with color coding
- **Category Tracking**: Shows pass/fail status per test category
- **Progress Tracking**: Real-time test execution with duration reporting
- **Final Summary**: Consolidated summary with success rate and total duration
- **Error Reporting**: Clear error messages for failed tests

### Test Isolation
- **Clean Environment**: Each test runs in isolation with clean directories
- **Automatic Cleanup**: Test artifacts are automatically cleaned up after each test and at the end
- **No Side Effects**: Tests don't interfere with each other or the main project
- **Manual Cleanup**: Option to manually clean up test artifacts with `--cleanup` flag

## Test Results

### Success Criteria
- All tests must pass for a successful test run
- 100% success rate indicates all functionality is working correctly
- Any test failures should be investigated and fixed

### Test Metrics
- **Total Tests**: Number of individual test cases executed
- **Passed**: Number of successful test cases
- **Failed**: Number of failed test cases
- **Success Rate**: Percentage of tests that passed

## Adding New Tests

### Creating a New Test File

1. Create a new `.sh` file in the `tests/` directory
2. Add a descriptive header comment explaining what the test does
3. Follow the existing test structure and patterns
4. Make the file executable: `chmod +x tests/your-test.sh`
5. The test runner will automatically discover and run your test

### Test File Structure

```bash
#!/bin/bash

# Test: Your Test Name
# Description of what this test validates

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Your test functions here

# Main test runner
main() {
    echo "Running your test..."
    # Your test logic here
}

# Run main function
main "$@"
```

### Test Best Practices

1. **Isolation**: Each test should be independent and not rely on other tests
2. **Cleanup**: Always clean up test artifacts and temporary files
3. **Clear Output**: Provide clear, descriptive test output
4. **Error Handling**: Test both success and failure scenarios
5. **Documentation**: Document what each test validates

## Continuous Integration

The test suite is designed to be easily integrated into CI/CD pipelines:

```bash
# Run tests in CI environment
./run-tests.sh --quiet
```

The test runner will exit with appropriate exit codes:
- `0`: All tests passed
- `1`: Some tests failed

## Cleanup System

The test runner includes a comprehensive cleanup system that automatically removes test artifacts:

### Automatic Cleanup
- **After Each Test**: Test artifacts are cleaned up after each individual test completes
- **After All Tests**: Final cleanup is performed after all tests complete
- **Comprehensive Coverage**: Removes all test directories, temporary files, and artifacts

### Manual Cleanup
You can manually clean up test artifacts at any time:

```bash
# Clean up all test artifacts
./run-tests.sh --cleanup
```

### What Gets Cleaned Up
- Test directories (`test-scenarios/`, `test-*`, etc.)
- Temporary files (`.test-*`, `*.tmp`, `*.temp`)
- Any test artifacts in subdirectories
- All test-related files and folders

### Cleanup Benefits
- **Clean Workspace**: Keeps the project directory clean
- **No Conflicts**: Prevents test artifacts from interfering with future tests
- **Storage Efficiency**: Removes unnecessary files and directories
- **CI/CD Ready**: Ensures clean state for automated testing

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure all test files are executable
   ```bash
   chmod +x tests/*.sh
   ```

2. **Script Not Found**: Make sure you're running from the project root
   ```bash
   cd /path/to/contextual
   ./run-tests.sh
   ```

3. **Test Failures**: Check the detailed output for specific error messages
   - Review the test output for clues about what failed
   - Check file permissions and paths
   - Verify that required dependencies are available

### Debug Mode

For debugging test issues, you can run individual tests with verbose output:

```bash
# Run a specific test with full output
bash tests/simple-test.sh
```

## Contributing

When adding new functionality to the project:

1. **Write Tests First**: Create tests for new features before implementing them
2. **Update Existing Tests**: Modify existing tests if behavior changes
3. **Test Edge Cases**: Include tests for error conditions and edge cases
4. **Document Changes**: Update this README if you add new test categories or patterns

## Test Dependencies

The test suite requires:
- Bash shell
- Standard Unix utilities (ls, mkdir, rm, etc.)
- The contextual development tools project structure
- Proper file permissions for script execution

No additional dependencies are required beyond what's needed for the main project.
