# Test Suite for Contextual Development Tools

This directory contains comprehensive tests for the contextual development tools project.

## Test Structure

### Test Files

- **`run-tests.sh`** - Main test runner script
- **`simple-test.sh`** - Basic install script functionality tests
- **`install-test.sh`** - Comprehensive install script tests
- **`contextual-scripts-test.sh`** - Tests for contextual workflow scripts
- **`install.sh`** - Original unit tests (legacy)

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

## Usage

### Running All Tests

```bash
# Run all tests
./run-tests.sh

# Run all tests with verbose output
./run-tests.sh --verbose

# Run all tests quietly (minimal output)
./run-tests.sh --quiet
```

### Running Specific Tests

```bash
# Run a specific test
./run-tests.sh simple-test

# Run another specific test
./run-tests.sh install-test
```

### Listing Available Tests

```bash
# List all available tests
./run-tests.sh --list
```

### Getting Help

```bash
# Show help information
./run-tests.sh --help
```

### Cleanup

```bash
# Clean up test artifacts manually
./run-tests.sh --cleanup
```

## Test Features

### Comprehensive Coverage
- **Install Script**: Tests all major functionality including argument parsing, project creation, file copying, and error handling
- **Contextual Scripts**: Validates all workflow scripts and utility functions
- **Directory Structure**: Ensures proper project structure is maintained
- **Error Handling**: Tests various error conditions and edge cases

### Test Output
- **Colored Output**: Easy-to-read test results with color coding
- **Progress Tracking**: Real-time test execution progress
- **Detailed Results**: Comprehensive test summaries with pass/fail counts
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
