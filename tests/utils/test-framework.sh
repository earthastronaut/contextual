#!/bin/bash

# Bash Unit Testing Framework
# Provides utilities for testing bash functions in isolation

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test suite name
TEST_SUITE_NAME=""

# ============================================================================
# Core Test Functions
# ============================================================================

# Initialize a test suite
# Args:
#   $1 - Test suite name
init_test_suite() {
    TEST_SUITE_NAME="$1"
    TESTS_RUN=0
    TESTS_PASSED=0
    TESTS_FAILED=0
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Test Suite: $TEST_SUITE_NAME${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Assert that two values are equal
# Args:
#   $1 - Expected value
#   $2 - Actual value
#   $3 - Test name
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$expected" == "$actual" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Expected: ${YELLOW}$expected${NC}"
        echo -e "  Actual:   ${YELLOW}$actual${NC}"
        return 1
    fi
}

# Assert that a value is not empty
# Args:
#   $1 - Value to check
#   $2 - Test name
assert_not_empty() {
    local value="$1"
    local test_name="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ -n "$value" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Expected non-empty value, got empty"
        return 1
    fi
}

# Assert that a value is empty
# Args:
#   $1 - Value to check
#   $2 - Test name
assert_empty() {
    local value="$1"
    local test_name="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ -z "$value" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Expected empty value, got: ${YELLOW}$value${NC}"
        return 1
    fi
}

# Assert that a command succeeds (returns 0)
# Args:
#   $1 - Test name
#   $@ - Command to run
assert_success() {
    local test_name="$1"
    shift
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if "$@" &>/dev/null; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Command failed: ${YELLOW}$*${NC}"
        return 1
    fi
}

# Assert that a command fails (returns non-zero)
# Args:
#   $1 - Test name
#   $@ - Command to run
assert_failure() {
    local test_name="$1"
    shift
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if ! "$@" &>/dev/null; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Expected command to fail, but it succeeded: ${YELLOW}$*${NC}"
        return 1
    fi
}

# Assert that a file exists
# Args:
#   $1 - File path
#   $2 - Test name
assert_file_exists() {
    local file_path="$1"
    local test_name="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ -f "$file_path" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  File not found: ${YELLOW}$file_path${NC}"
        return 1
    fi
}

# Assert that a directory exists
# Args:
#   $1 - Directory path
#   $2 - Test name
assert_dir_exists() {
    local dir_path="$1"
    local test_name="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ -d "$dir_path" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Directory not found: ${YELLOW}$dir_path${NC}"
        return 1
    fi
}

# Assert that a string contains a substring
# Args:
#   $1 - Haystack (string to search in)
#   $2 - Needle (substring to find)
#   $3 - Test name
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$haystack" == *"$needle"* ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  String does not contain substring"
        echo -e "  String:    ${YELLOW}$haystack${NC}"
        echo -e "  Substring: ${YELLOW}$needle${NC}"
        return 1
    fi
}

# Print test summary
print_test_summary() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Test Summary: $TEST_SUITE_NAME${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo "Tests run:    $TESTS_RUN"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
        return 0
    else
        local success_rate=$((TESTS_PASSED * 100 / TESTS_RUN))
        echo -e "${RED}✗ Some tests failed (${success_rate}% success rate)${NC}"
        return 1
    fi
}

# ============================================================================
# Test Environment Setup/Teardown
# ============================================================================

# Create a temporary test directory
# Returns the path to the test directory
create_test_dir() {
    local test_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'test')
    echo "$test_dir"
}

# Clean up a test directory
# Args:
#   $1 - Test directory path
cleanup_test_dir() {
    local test_dir="$1"
    if [[ -n "$test_dir" && -d "$test_dir" ]]; then
        rm -rf "$test_dir"
    fi
}

# Array of test files
# Args:
#   $1 - Folder to search for files starting with "test-"
# Returns: Sorted array of test file paths (one per line)
get_test_files() {
    local folder="$1"
    if [[ -d "$folder" ]]; then
        find "$folder" -type f -name "test-*.sh" | sort
    fi
}


# ============================================================================
# Exports
# ============================================================================

export -f init_test_suite
export -f assert_equals
export -f assert_not_empty
export -f assert_empty
export -f assert_success
export -f assert_failure
export -f assert_file_exists
export -f assert_dir_exists
export -f assert_contains
export -f print_test_summary
export -f create_test_dir
export -f cleanup_test_dir
export -f get_test_files

