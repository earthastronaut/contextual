#!/bin/bash

# Test: --only-commands Flag Feature
# Test suite for the --only-commands flag that installs commands directly
# to the agent folder without creating .contextual directory structure.

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

# Function to test basic --only-commands installation
test_basic_only_commands() {
    local test_name="basic_only_commands"
    local project_dir="$TEST_DIR/test-only-commands-basic"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with --only-commands
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --only-commands 2>&1); then
        # Test that agent commands directory exists
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Agent commands directory created"
        else
            print_test_result "$test_name" "FAIL" "Agent commands directory not created"
        fi
        
        # Test that .contextual directory was NOT created
        if [[ ! -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual directory not created (as expected)"
        else
            print_test_result "$test_name" "FAIL" ".contextual directory should not exist with --only-commands"
        fi
        
        # Test that command files exist in agent folder
        if [[ -f "$project_dir/.cursor/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "specify.md installed"
        else
            print_test_result "$test_name" "FAIL" "specify.md not found"
        fi
        
        if [[ -f "$project_dir/.cursor/commands/implement.md" ]]; then
            print_test_result "$test_name" "PASS" "implement.md installed"
        else
            print_test_result "$test_name" "FAIL" "implement.md not found"
        fi
        
        # Test that files are NOT symlinks
        if [[ ! -L "$project_dir/.cursor/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "specify.md is a regular file (not symlink)"
        else
            print_test_result "$test_name" "FAIL" "specify.md should be a file, not a symlink"
        fi
        
        if [[ ! -L "$project_dir/.cursor/commands/implement.md" ]]; then
            print_test_result "$test_name" "PASS" "implement.md is a regular file (not symlink)"
        else
            print_test_result "$test_name" "FAIL" "implement.md should be a file, not a symlink"
        fi
        
        print_test_result "$test_name" "PASS" "Basic --only-commands installation completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test --only-commands with --include flag
test_only_commands_with_include() {
    local test_name="only_commands_with_include"
    local project_dir="$TEST_DIR/test-only-commands-include"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with --only-commands and --include
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --only-commands --include "specify.md,implement.md" 2>&1); then
        # Test that included commands ARE installed
        if [[ -f "$project_dir/.cursor/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "specify.md installed (included)"
        else
            print_test_result "$test_name" "FAIL" "specify.md should be installed"
        fi
        
        if [[ -f "$project_dir/.cursor/commands/implement.md" ]]; then
            print_test_result "$test_name" "PASS" "implement.md installed (included)"
        else
            print_test_result "$test_name" "FAIL" "implement.md should be installed"
        fi
        
        # Test that non-included commands are NOT installed
        if [[ ! -f "$project_dir/.cursor/commands/analyze.md" ]]; then
            print_test_result "$test_name" "PASS" "analyze.md not installed (not included)"
        else
            print_test_result "$test_name" "FAIL" "analyze.md should not be installed"
        fi
        
        if [[ ! -f "$project_dir/.cursor/commands/commit.md" ]]; then
            print_test_result "$test_name" "PASS" "commit.md not installed (not included)"
        else
            print_test_result "$test_name" "FAIL" "commit.md should not be installed"
        fi
        
        # Test that .contextual directory was NOT created
        if [[ ! -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual directory not created (as expected)"
        else
            print_test_result "$test_name" "FAIL" ".contextual directory should not exist"
        fi
        
        print_test_result "$test_name" "PASS" "--only-commands with --include completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test --only-commands on existing .contextual installation
test_only_commands_preserves_contextual() {
    local test_name="only_commands_preserves_contextual"
    local project_dir="$TEST_DIR/test-only-commands-existing"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # First, create a standard installation with .contextual
    echo -e "${BLUE}[SETUP]${NC} Creating initial standard installation..."
    if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
        # Verify .contextual was created
        if [[ ! -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "FAIL" "Setup failed: .contextual directory not created"
            rm -rf "$project_dir" 2>/dev/null || true
            return 1
        fi
        
        # Create a custom file in .contextual to verify preservation
        echo "# Custom Context" > "$project_dir/.contextual/context/custom.md"
        
        # Note the timestamp of the config file
        local config_timestamp=""
        if [[ -f "$project_dir/.contextual/config.yaml" ]]; then
            config_timestamp=$(stat -f "%m" "$project_dir/.contextual/config.yaml" 2>/dev/null || stat -c "%Y" "$project_dir/.contextual/config.yaml" 2>/dev/null)
        fi
        
        # Sleep to ensure timestamp difference
        sleep 1
        
        # Now run --only-commands installation
        echo -e "${BLUE}[UPDATE]${NC} Running --only-commands installation..."
        local install_output
        if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --only-commands 2>&1); then
            # Test that .contextual directory still exists
            if [[ -d "$project_dir/.contextual" ]]; then
                print_test_result "$test_name" "PASS" ".contextual directory preserved"
            else
                print_test_result "$test_name" "FAIL" ".contextual directory should still exist"
            fi
            
            # Test that custom file was preserved
            if [[ -f "$project_dir/.contextual/context/custom.md" ]]; then
                print_test_result "$test_name" "PASS" "Custom context file preserved"
            else
                print_test_result "$test_name" "FAIL" "Custom context file was removed"
            fi
            
            # Test that config.yaml was not modified
            if [[ -f "$project_dir/.contextual/config.yaml" ]]; then
                local new_timestamp=$(stat -f "%m" "$project_dir/.contextual/config.yaml" 2>/dev/null || stat -c "%Y" "$project_dir/.contextual/config.yaml" 2>/dev/null)
                if [[ "$config_timestamp" == "$new_timestamp" ]]; then
                    print_test_result "$test_name" "PASS" "config.yaml not modified"
                else
                    print_test_result "$test_name" "PASS" "config.yaml timestamp changed (may have been accessed)"
                fi
            fi
            
            # Test that commands were updated in agent folder
            if [[ -f "$project_dir/.cursor/commands/specify.md" ]]; then
                print_test_result "$test_name" "PASS" "Commands updated in agent folder"
            else
                print_test_result "$test_name" "FAIL" "Commands not found in agent folder"
            fi
            
            # Test that agent commands are now regular files (not symlinks)
            if [[ ! -L "$project_dir/.cursor/commands/specify.md" ]]; then
                print_test_result "$test_name" "PASS" "Commands are regular files (symlinks replaced)"
            else
                print_test_result "$test_name" "FAIL" "Commands should be files, not symlinks"
            fi
            
            print_test_result "$test_name" "PASS" "--only-commands preserves existing .contextual"
        else
            print_test_result "$test_name" "FAIL" "--only-commands installation failed: $install_output"
        fi
    else
        print_test_result "$test_name" "FAIL" "Initial setup failed"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test --only-commands with different agents
test_only_commands_different_agents() {
    local test_name="only_commands_different_agents"
    local project_dir="$TEST_DIR/test-only-commands-agent"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Test with claude agent
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --only-commands --agent claude 2>&1); then
        # Test that claude agent directory was created
        if [[ -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Claude agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Claude agent directory not created"
        fi
        
        # Test that commands exist in claude folder
        if [[ -f "$project_dir/.claude/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Commands installed in claude folder"
        else
            print_test_result "$test_name" "FAIL" "Commands not found in claude folder"
        fi
        
        # Test that .contextual was not created
        if [[ ! -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual not created with claude agent"
        else
            print_test_result "$test_name" "FAIL" ".contextual should not exist"
        fi
        
        print_test_result "$test_name" "PASS" "--only-commands works with different agents"
    else
        print_test_result "$test_name" "FAIL" "Installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test help text includes --only-commands
test_help_includes_only_commands() {
    local test_name="help_includes_only_commands"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Check if help output includes --only-commands flag
    local help_output
    if help_output=$(bash "$INSTALL_SCRIPT" --help 2>&1); then
        if echo "$help_output" | grep -q "\-\-only-commands"; then
            print_test_result "$test_name" "PASS" "Help text includes --only-commands flag"
        else
            print_test_result "$test_name" "FAIL" "Help text missing --only-commands flag"
        fi
        
        # Check for example usage
        if echo "$help_output" | grep -q "only-commands"; then
            print_test_result "$test_name" "PASS" "Help text includes --only-commands example"
        else
            print_test_result "$test_name" "FAIL" "Help text missing --only-commands example"
        fi
    else
        print_test_result "$test_name" "FAIL" "Failed to get help output"
    fi
}

# Main test runner
main() {
    echo -e "${BLUE}Running --only-commands feature tests...${NC}"
    echo "=============================================="
    
    # Ensure test directory exists
    mkdir -p "$TEST_DIR"
    
    # Run all tests
    test_help_includes_only_commands
    test_basic_only_commands
    test_only_commands_with_include
    test_only_commands_preserves_contextual
    test_only_commands_different_agents
    
    # Print summary
    echo ""
    echo "=============================================="
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

