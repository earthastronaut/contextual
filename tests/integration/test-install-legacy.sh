#!/bin/bash

# Unit tests for install.sh script
# Run with: bash tests/install.sh

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$TEST_DIR")"
INSTALL_SCRIPT="$PROJECT_ROOT/scripts/install.sh"
TEST_DIR="$PROJECT_ROOT/test-scenarios"

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

# Function to print test results
print_test_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$result" == "PASS" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name: $message"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $test_name: $message"
    fi
}

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Create a clean test directory
    local test_project_dir="$TEST_DIR/test-$test_name"
    rm -rf "$test_project_dir" 2>/dev/null || true
    
    # Run the test command
    if eval "$test_command" >/dev/null 2>&1; then
        local actual_exit_code=$?
        if [[ $actual_exit_code -eq $expected_exit_code ]]; then
            print_test_result "$test_name" "PASS" "Exit code $actual_exit_code as expected"
        else
            print_test_result "$test_name" "FAIL" "Expected exit code $expected_exit_code, got $actual_exit_code"
        fi
    else
        local actual_exit_code=$?
        if [[ $actual_exit_code -eq $expected_exit_code ]]; then
            print_test_result "$test_name" "PASS" "Exit code $actual_exit_code as expected"
        else
            print_test_result "$test_name" "FAIL" "Expected exit code $expected_exit_code, got $actual_exit_code"
        fi
    fi
    
    # Cleanup
    rm -rf "$test_project_dir" 2>/dev/null || true
}

# Function to test file existence
test_file_exists() {
    local test_name="$1"
    local file_path="$2"
    local should_exist="${3:-true}"
    
    if [[ "$should_exist" == "true" ]]; then
        if [[ -f "$file_path" ]]; then
            print_test_result "$test_name" "PASS" "File exists: $file_path"
        else
            print_test_result "$test_name" "FAIL" "File missing: $file_path"
        fi
    else
        if [[ ! -f "$file_path" ]]; then
            print_test_result "$test_name" "PASS" "File does not exist: $file_path"
        else
            print_test_result "$test_name" "FAIL" "File should not exist: $file_path"
        fi
    fi
}

# Function to test directory structure
test_directory_structure() {
    local test_name="$1"
    local project_dir="$2"
    local contextual_target="${3:-.contextual}"
    
    local target_dir="$project_dir/$contextual_target"
    
    # Test main directories
    local required_dirs=("$target_dir" "$target_dir/context" "$target_dir/commands" "$project_dir/.cursor" "$project_dir/.cursor/commands")
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            print_test_result "$test_name" "PASS" "Directory exists: $dir"
        else
            print_test_result "$test_name" "FAIL" "Directory missing: $dir"
        fi
    done
}

# Function to test help functionality
test_help() {
    local test_name="help_functionality"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    if "$INSTALL_SCRIPT" --help 2>/dev/null | grep -q "Usage:"; then
        print_test_result "$test_name" "PASS" "Help output contains usage information"
    else
        print_test_result "$test_name" "FAIL" "Help output missing or incorrect"
    fi
}

# Function to test error handling
test_error_handling() {
    local test_name="error_handling"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Test missing project root (with empty input to avoid interactive prompt)
    if echo "" | "$INSTALL_SCRIPT" 2>/dev/null; then
        print_test_result "$test_name" "FAIL" "Script should fail with empty project name"
    else
        print_test_result "$test_name" "PASS" "Script fails with empty project name (as expected)"
    fi
    
    # Test invalid option
    if ! "$INSTALL_SCRIPT" --invalid-option 2>/dev/null; then
        print_test_result "$test_name" "PASS" "Script fails with invalid option (as expected)"
    else
        print_test_result "$test_name" "FAIL" "Script should fail with invalid option"
    fi
}

# Function to test new project installation
test_new_project() {
    local test_name="new_project_installation"
    local project_dir="$TEST_DIR/test-new-project"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with output capture for debugging
    local install_output
    if install_output=$("$INSTALL_SCRIPT"  "$project_dir" 2>&1); then
        # Test directory structure
        test_directory_structure "$test_name" "$project_dir"
        
        # Test specific files
        # Check for config.yaml
        if [[ -f "$project_dir/.contextual/config.yaml" ]]; then
            print_test_result "$test_name" "PASS" "config.yaml exists"
        else
            print_test_result "$test_name" "FAIL" ".contextual/config.yaml not found"
        fi
        test_file_exists "$test_name" "$project_dir/.cursor/commands/specify.md"
        test_file_exists "$test_name" "$project_dir/.cursor/commands/implement.md"
        
        print_test_result "$test_name" "PASS" "New project installation completed successfully"
    else
        print_test_result "$test_name" "FAIL" "New project installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test existing project update
test_existing_project() {
    local test_name="existing_project_update"
    local project_dir="$TEST_DIR/test-existing-project"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Create existing project with context
    mkdir -p "$project_dir/.contextual/context"
    echo "# Existing Context" > "$project_dir/.contextual/context/existing.md"
    
    # Run installation with output capture for debugging
    local install_output
    if install_output=$("$INSTALL_SCRIPT"  "$project_dir" 2>&1); then
        # Test that existing context was preserved
        if [[ -f "$project_dir/.contextual/context/existing.md" ]]; then
            print_test_result "$test_name" "PASS" "Existing context file preserved"
        else
            print_test_result "$test_name" "FAIL" "Existing context file was overwritten"
        fi
        
        # Test directory structure
        test_directory_structure "$test_name" "$project_dir"
        
        print_test_result "$test_name" "PASS" "Existing project update completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Existing project update failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test custom contextual root
test_custom_contextual_root() {
    local test_name="custom_contextual_root"
    local project_dir="$TEST_DIR/test-custom-root"
    local custom_root=".dev-tools"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with custom contextual root
    local install_output
    if install_output=$("$INSTALL_SCRIPT"  "$project_dir" --contextual-root "$custom_root" 2>&1); then
        # Test that custom root was used
        if [[ -d "$project_dir/$custom_root" ]]; then
            print_test_result "$test_name" "PASS" "Custom contextual root directory created"
        else
            print_test_result "$test_name" "FAIL" "Custom contextual root directory not created"
        fi
        
        # Test directory structure with custom root
        test_directory_structure "$test_name" "$project_dir" "$custom_root"
        
        print_test_result "$test_name" "PASS" "Custom contextual root installation completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Custom contextual root installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test different agents
test_different_agents() {
    local test_name="different_agents"
    local project_dir="$TEST_DIR/test-different-agents"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Test cursor agent (default)
    local install_output
    if install_output=$("$INSTALL_SCRIPT"  "$project_dir" --agent cursor 2>&1); then
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Cursor agent structure created"
        else
            print_test_result "$test_name" "FAIL" "Cursor agent structure not created"
        fi
    else
        print_test_result "$test_name" "FAIL" "Cursor agent installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Main test runner
main() {
    echo -e "${BLUE}Running install.sh unit tests...${NC}"
    echo "=================================="
    
    # Ensure test directory exists
    mkdir -p "$TEST_DIR"
    
    # Run all tests
    test_help
    test_error_handling
    test_new_project
    test_existing_project
    test_custom_contextual_root
    test_different_agents
    
    # Print summary
    echo ""
    echo "=================================="
    echo -e "${BLUE}Test Summary:${NC}"
    echo "Tests run: $TESTS_RUN"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed.${NC}"
        exit 1
    fi
}

# Run main function
main "$@"
