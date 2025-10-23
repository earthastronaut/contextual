#!/bin/bash

# Test: Multiagent Install Support
# Test suite for the multiagent install functionality that supports multiple agents
# via both comma-separated syntax and multiple flag syntax.

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

# Function to test comma-separated agent syntax
test_comma_separated_agents() {
    local test_name="comma_separated_agents"
    local project_dir="$TEST_DIR/test-comma-agents"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with comma-separated agents
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor,claude --only-commands 2>&1); then
        # Test that both agent directories exist
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Cursor agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Cursor agent directory not created"
        fi
        
        if [[ -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Claude agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Claude agent directory not created"
        fi
        
        # Test that command files exist in both agent folders
        if [[ -f "$project_dir/.cursor/commands/specify.md" && -f "$project_dir/.claude/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Command files installed in both agent folders"
        else
            print_test_result "$test_name" "FAIL" "Command files not found in both agent folders"
        fi
        
        # Test that .contextual directory was NOT created (--only-commands mode)
        if [[ ! -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual directory not created (--only-commands mode)"
        else
            print_test_result "$test_name" "FAIL" ".contextual directory should not exist with --only-commands"
        fi
        
        # Test that output shows both agents
        if echo "$install_output" | grep -q "Agents: cursor claude"; then
            print_test_result "$test_name" "PASS" "Output shows both agents"
        else
            print_test_result "$test_name" "FAIL" "Output does not show both agents"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Installation failed with exit code $?"
        echo "Install output: $install_output"
    fi
}

# Function to test multiple flag agent syntax
test_multiple_flag_agents() {
    local test_name="multiple_flag_agents"
    local project_dir="$TEST_DIR/test-multiple-flags"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with multiple --agent flags
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor --agent claude --only-commands 2>&1); then
        # Test that both agent directories exist
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Cursor agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Cursor agent directory not created"
        fi
        
        if [[ -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Claude agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Claude agent directory not created"
        fi
        
        # Test that command files exist in both agent folders
        if [[ -f "$project_dir/.cursor/commands/specify.md" && -f "$project_dir/.claude/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Command files installed in both agent folders"
        else
            print_test_result "$test_name" "FAIL" "Command files not found in both agent folders"
        fi
        
        # Test that output shows both agents
        if echo "$install_output" | grep -q "Agents: cursor claude"; then
            print_test_result "$test_name" "PASS" "Output shows both agents"
        else
            print_test_result "$test_name" "FAIL" "Output does not show both agents"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Installation failed with exit code $?"
        echo "Install output: $install_output"
    fi
}

# Function to test multiagent with command filtering
test_multiagent_with_filtering() {
    local test_name="multiagent_with_filtering"
    local project_dir="$TEST_DIR/test-multiagent-filtering"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with multiagent and command filtering
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor,claude --include specify.md,implement.md --only-commands 2>&1); then
        # Test that both agent directories exist
        if [[ -d "$project_dir/.cursor/commands" && -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Both agent directories created"
        else
            print_test_result "$test_name" "FAIL" "Agent directories not created"
        fi
        
        # Test that only specified commands are installed
        if [[ -f "$project_dir/.cursor/commands/specify.md" && -f "$project_dir/.cursor/commands/implement.md" ]]; then
            print_test_result "$test_name" "PASS" "Specified commands installed in cursor folder"
        else
            print_test_result "$test_name" "FAIL" "Specified commands not found in cursor folder"
        fi
        
        if [[ -f "$project_dir/.claude/commands/specify.md" && -f "$project_dir/.claude/commands/implement.md" ]]; then
            print_test_result "$test_name" "PASS" "Specified commands installed in claude folder"
        else
            print_test_result "$test_name" "FAIL" "Specified commands not found in claude folder"
        fi
        
        # Test that other commands are NOT installed
        if [[ ! -f "$project_dir/.cursor/commands/commit.md" && ! -f "$project_dir/.claude/commands/commit.md" ]]; then
            print_test_result "$test_name" "PASS" "Non-specified commands not installed"
        else
            print_test_result "$test_name" "FAIL" "Non-specified commands should not be installed"
        fi
        
        # Test that output shows command filtering
        if echo "$install_output" | grep -q "Including only: specify.md,implement.md"; then
            print_test_result "$test_name" "PASS" "Output shows command filtering"
        else
            print_test_result "$test_name" "FAIL" "Output does not show command filtering"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Installation failed with exit code $?"
        echo "Install output: $install_output"
    fi
}

# Function to test multiagent standard installation (not --only-commands)
test_multiagent_standard_installation() {
    local test_name="multiagent_standard_installation"
    local project_dir="$TEST_DIR/test-multiagent-standard"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run standard installation with multiagent
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor,claude 2>&1); then
        # Test that .contextual directory exists
        if [[ -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual directory created"
        else
            print_test_result "$test_name" "FAIL" ".contextual directory not created"
        fi
        
        # Test that both agent directories exist
        if [[ -d "$project_dir/.cursor/commands" && -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Both agent directories created"
        else
            print_test_result "$test_name" "FAIL" "Agent directories not created"
        fi
        
        # Test that symlinks exist in agent folders
        if [[ -L "$project_dir/.cursor/commands/specify.md" && -L "$project_dir/.claude/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Symlinks created in both agent folders"
        else
            print_test_result "$test_name" "FAIL" "Symlinks not created in agent folders"
        fi
        
        # Test that symlinks point to .contextual/commands
        if [[ "$(readlink "$project_dir/.cursor/commands/specify.md")" == "../../.contextual/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Cursor symlinks point to correct location"
        else
            print_test_result "$test_name" "FAIL" "Cursor symlinks point to wrong location"
        fi
        
        if [[ "$(readlink "$project_dir/.claude/commands/specify.md")" == "../../.contextual/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Claude symlinks point to correct location"
        else
            print_test_result "$test_name" "FAIL" "Claude symlinks point to wrong location"
        fi
        
        # Test that output shows both agents
        if echo "$install_output" | grep -q "Agents: cursor claude"; then
            print_test_result "$test_name" "PASS" "Output shows both agents"
        else
            print_test_result "$test_name" "FAIL" "Output does not show both agents"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Installation failed with exit code $?"
        echo "Install output: $install_output"
    fi
}

# Function to test backward compatibility with single agent
test_single_agent_backward_compatibility() {
    local test_name="single_agent_backward_compatibility"
    local project_dir="$TEST_DIR/test-single-agent"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with single agent (backward compatibility)
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor --only-commands 2>&1); then
        # Test that only cursor directory exists
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Cursor agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Cursor agent directory not created"
        fi
        
        # Test that claude directory does NOT exist
        if [[ ! -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Claude agent directory not created (single agent mode)"
        else
            print_test_result "$test_name" "FAIL" "Claude agent directory should not exist in single agent mode"
        fi
        
        # Test that command files exist
        if [[ -f "$project_dir/.cursor/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Command files installed"
        else
            print_test_result "$test_name" "FAIL" "Command files not found"
        fi
        
        # Test that output shows single agent
        if echo "$install_output" | grep -q "Agents: cursor"; then
            print_test_result "$test_name" "PASS" "Output shows single agent"
        else
            print_test_result "$test_name" "FAIL" "Output does not show single agent correctly"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Installation failed with exit code $?"
        echo "Install output: $install_output"
    fi
}

# Function to test default agent behavior (no --agent flag)
test_default_agent_behavior() {
    local test_name="default_agent_behavior"
    local project_dir="$TEST_DIR/test-default-agent"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation without --agent flag (should use default)
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --only-commands 2>&1); then
        # Test that only cursor directory exists (default agent)
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Default cursor agent directory created"
        else
            print_test_result "$test_name" "FAIL" "Default cursor agent directory not created"
        fi
        
        # Test that other agent directories do NOT exist
        if [[ ! -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "Non-default agent directories not created"
        else
            print_test_result "$test_name" "FAIL" "Non-default agent directories should not exist"
        fi
        
        # Test that command files exist
        if [[ -f "$project_dir/.cursor/commands/specify.md" ]]; then
            print_test_result "$test_name" "PASS" "Command files installed for default agent"
        else
            print_test_result "$test_name" "FAIL" "Command files not found for default agent"
        fi
        
        # Test that output shows default agent
        if echo "$install_output" | grep -q "Agents: cursor"; then
            print_test_result "$test_name" "PASS" "Output shows default agent"
        else
            print_test_result "$test_name" "FAIL" "Output does not show default agent correctly"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Installation failed with exit code $?"
        echo "Install output: $install_output"
    fi
}

# Function to test error handling for invalid agents
test_invalid_agent_error_handling() {
    local test_name="invalid_agent_error_handling"
    local project_dir="$TEST_DIR/test-invalid-agent"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with invalid agent (should fail)
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent invalidagent --only-commands 2>&1); then
        print_test_result "$test_name" "FAIL" "Installation should have failed with invalid agent"
    else
        # Test that error message mentions invalid agent
        if echo "$install_output" | grep -q "Unsupported agent: invalidagent"; then
            print_test_result "$test_name" "PASS" "Error message mentions invalid agent"
        else
            print_test_result "$test_name" "FAIL" "Error message does not mention invalid agent"
        fi
        
        # Test that supported agents are listed
        if echo "$install_output" | grep -q "Supported agents:"; then
            print_test_result "$test_name" "PASS" "Error message lists supported agents"
        else
            print_test_result "$test_name" "FAIL" "Error message does not list supported agents"
        fi
        
        # Test that no directories were created
        if [[ ! -d "$project_dir/.cursor/commands" && ! -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "No agent directories created on error"
        else
            print_test_result "$test_name" "FAIL" "Agent directories should not be created on error"
        fi
    fi
}

# Function to test mixed valid and invalid agents
test_mixed_valid_invalid_agents() {
    local test_name="mixed_valid_invalid_agents"
    local project_dir="$TEST_DIR/test-mixed-agents"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with mixed valid and invalid agents (should fail)
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor,invalidagent --only-commands 2>&1); then
        print_test_result "$test_name" "FAIL" "Installation should have failed with mixed agents"
    else
        # Test that error message mentions invalid agent
        if echo "$install_output" | grep -q "Unsupported agent: invalidagent"; then
            print_test_result "$test_name" "PASS" "Error message mentions invalid agent"
        else
            print_test_result "$test_name" "FAIL" "Error message does not mention invalid agent"
        fi
        
        # Test that no directories were created
        if [[ ! -d "$project_dir/.cursor/commands" && ! -d "$project_dir/.claude/commands" ]]; then
            print_test_result "$test_name" "PASS" "No agent directories created on error"
        else
            print_test_result "$test_name" "FAIL" "Agent directories should not be created on error"
        fi
    fi
}

# Function to test help output includes multiagent syntax
test_help_output_multiagent() {
    local test_name="help_output_multiagent"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Get help output
    local help_output
    if help_output=$(bash "$INSTALL_SCRIPT" --help 2>&1); then
        # Test that help shows multiagent syntax
        if echo "$help_output" | grep -q "AI agent(s) to configure"; then
            print_test_result "$test_name" "PASS" "Help shows multiagent description"
        else
            print_test_result "$test_name" "FAIL" "Help does not show multiagent description"
        fi
        
        # Test that help shows comma-separated example
        if echo "$help_output" | grep -q "cursor,claude"; then
            print_test_result "$test_name" "PASS" "Help shows comma-separated example"
        else
            print_test_result "$test_name" "FAIL" "Help does not show comma-separated example"
        fi
        
        # Test that help shows multiple flag example
        if echo "$help_output" | grep -q "cursor --agent claude"; then
            print_test_result "$test_name" "PASS" "Help shows multiple flag example"
        else
            print_test_result "$test_name" "FAIL" "Help does not show multiple flag example"
        fi
        
    else
        print_test_result "$test_name" "FAIL" "Help command failed"
    fi
}

# Main test execution
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Multiagent Install Support Test Suite${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    # Run all tests
    test_comma_separated_agents
    echo ""
    
    test_multiple_flag_agents
    echo ""
    
    test_multiagent_with_filtering
    echo ""
    
    test_multiagent_standard_installation
    echo ""
    
    test_single_agent_backward_compatibility
    echo ""
    
    test_default_agent_behavior
    echo ""
    
    test_invalid_agent_error_handling
    echo ""
    
    test_mixed_valid_invalid_agents
    echo ""
    
    test_help_output_multiagent
    echo ""
    
    # Print summary
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "Tests run: $TESTS_RUN"
    echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    fi
}

# Run main function
main "$@"
