#!/bin/bash

# Test: Contextual Scripts Functionality
# Tests the contextual development workflow scripts including specify.sh, implement.sh,
# and other utility scripts to ensure they work correctly.

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONTEXTUAL_ROOT="$PROJECT_ROOT/.contextual"
SCRIPTS_DIR="$CONTEXTUAL_ROOT/scripts/bash"

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

# Function to test script existence and executability
test_script_exists() {
    local test_name="$1"
    local script_path="$2"
    
    if [[ -f "$script_path" ]]; then
        if [[ -x "$script_path" ]]; then
            print_test_result "$test_name" "PASS" "Script exists and is executable: $script_path"
        else
            print_test_result "$test_name" "FAIL" "Script exists but is not executable: $script_path"
        fi
    else
        print_test_result "$test_name" "FAIL" "Script not found: $script_path"
    fi
}

# Function to test script syntax
test_script_syntax() {
    local test_name="$1"
    local script_path="$2"
    
    if [[ -f "$script_path" ]]; then
        if bash -n "$script_path" 2>/dev/null; then
            print_test_result "$test_name" "PASS" "Script syntax is valid: $script_path"
        else
            print_test_result "$test_name" "FAIL" "Script has syntax errors: $script_path"
        fi
    else
        print_test_result "$test_name" "FAIL" "Script not found: $script_path"
    fi
}

# Function to test specify.sh script
test_specify_script() {
    local test_name="specify_script"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    local specify_script="$SCRIPTS_DIR/specify.sh"
    
    # Test script exists and is executable
    test_script_exists "specify_exists" "$specify_script"
    
    # Test script syntax
    test_script_syntax "specify_syntax" "$specify_script"
    
    # Test script can be sourced without errors
    if bash -c "source '$specify_script' 2>/dev/null"; then
        print_test_result "specify_source" "PASS" "Script can be sourced without errors"
    else
        print_test_result "specify_source" "FAIL" "Script has errors when sourced"
    fi
}

# Function to test implement.sh script
test_implement_script() {
    local test_name="implement_script"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    local implement_script="$SCRIPTS_DIR/implement.sh"
    
    # Test script exists and is executable
    test_script_exists "implement_exists" "$implement_script"
    
    # Test script syntax
    test_script_syntax "implement_syntax" "$implement_script"
    
    # Test script can be sourced without errors
    if bash -c "source '$implement_script' 2>/dev/null"; then
        print_test_result "implement_source" "PASS" "Script can be sourced without errors"
    else
        print_test_result "implement_source" "FAIL" "Script has errors when sourced"
    fi
}

# Function to test utility scripts
test_utility_scripts() {
    local test_name="utility_scripts"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    local utils_dir="$SCRIPTS_DIR/utils"
    local utility_scripts=(
        "branch-utils.sh"
        "config-utils.sh"
        "env-utils.sh"
        "print-utils.sh"
    )
    
    for script in "${utility_scripts[@]}"; do
        local script_path="$utils_dir/$script"
        
        # Test script exists and is executable
        test_script_exists "util_${script}_exists" "$script_path"
        
        # Test script syntax
        test_script_syntax "util_${script}_syntax" "$script_path"
        
        # Test script can be sourced without errors
        if bash -c "source '$script_path' 2>/dev/null"; then
            print_test_result "util_${script}_source" "PASS" "Utility script can be sourced: $script"
        else
            print_test_result "util_${script}_source" "FAIL" "Utility script has errors when sourced: $script"
        fi
    done
}

# Function to test other scripts
test_other_scripts() {
    local test_name="other_scripts"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    local other_scripts=(
        "analyze.sh"
        "clarify.sh"
        "folder-analyzer.sh"
        "plan.sh"
    )
    
    for script in "${other_scripts[@]}"; do
        local script_path="$SCRIPTS_DIR/$script"
        
        if [[ -f "$script_path" ]]; then
            # Test script exists and is executable
            test_script_exists "other_${script}_exists" "$script_path"
            
            # Test script syntax
            test_script_syntax "other_${script}_syntax" "$script_path"
        else
            print_test_result "other_${script}_exists" "PASS" "Optional script not present: $script"
        fi
    done
}

# Function to test contextual directory structure
test_contextual_structure() {
    local test_name="contextual_structure"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Test main contextual directory
    if [[ -d "$CONTEXTUAL_ROOT" ]]; then
        print_test_result "contextual_root" "PASS" "Contextual root directory exists"
    else
        print_test_result "contextual_root" "FAIL" "Contextual root directory missing"
    fi
    
    # Test scripts directory
    if [[ -d "$SCRIPTS_DIR" ]]; then
        print_test_result "scripts_dir" "PASS" "Scripts directory exists"
    else
        print_test_result "scripts_dir" "FAIL" "Scripts directory missing"
    fi
    
    # Test context directory
    if [[ -d "$CONTEXTUAL_ROOT/context" ]]; then
        print_test_result "context_dir" "PASS" "Context directory exists"
    else
        print_test_result "context_dir" "FAIL" "Context directory missing"
    fi
    
    # Test templates directory
    if [[ -d "$CONTEXTUAL_ROOT/templates" ]]; then
        print_test_result "templates_dir" "PASS" "Templates directory exists"
    else
        print_test_result "templates_dir" "FAIL" "Templates directory missing"
    fi
}

# Function to test cursor commands
test_cursor_commands() {
    local test_name="cursor_commands"
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    local cursor_commands_dir="$PROJECT_ROOT/.cursor/commands"
    local command_files=(
        "analyze.md"
        "clarify.md"
        "contextualize.md"
        "implement.md"
        "plan.md"
        "specify.md"
        "tasks.md"
    )
    
    # Test cursor commands directory
    if [[ -d "$cursor_commands_dir" ]]; then
        print_test_result "cursor_commands_dir" "PASS" "Cursor commands directory exists"
    else
        print_test_result "cursor_commands_dir" "FAIL" "Cursor commands directory missing"
    fi
    
    # Test command files
    for command_file in "${command_files[@]}"; do
        local file_path="$cursor_commands_dir/$command_file"
        
        if [[ -f "$file_path" ]]; then
            print_test_result "cursor_${command_file}" "PASS" "Command file exists: $command_file"
        else
            print_test_result "cursor_${command_file}" "FAIL" "Command file missing: $command_file"
        fi
    done
}

# Main test runner
main() {
    echo -e "${BLUE}Running contextual scripts tests...${NC}"
    echo "====================================="
    
    # Run all tests
    test_contextual_structure
    test_specify_script
    test_implement_script
    test_utility_scripts
    test_other_scripts
    test_cursor_commands
    
    # Print summary
    echo ""
    echo "====================================="
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
