#!/bin/bash

# Test: Claude-Specific Install Script Testing
# Test suite for the install.sh script with Claude-specific command support
# Tests agent-specific command installation from .claude/commands/ directory

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

# Function to test file content
test_file_content() {
    local test_name="$1"
    local file_path="$2"
    local expected_content="$3"
    
    if [[ -f "$file_path" ]]; then
        if grep -q "$expected_content" "$file_path"; then
            print_test_result "$test_name" "PASS" "File contains expected content: $expected_content"
        else
            print_test_result "$test_name" "FAIL" "File missing expected content: $expected_content"
        fi
    else
        print_test_result "$test_name" "FAIL" "File does not exist: $file_path"
    fi
}

# Function to test Claude-specific commands installation
test_claude_specific_commands() {
    local test_name="claude_specific_commands"
    local project_dir="$TEST_DIR/test-claude-specific"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with Claude agent
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent claude 2>&1); then
        # Test that Claude-specific commands are installed
        test_file_exists "$test_name" "$project_dir/.claude/commands/specify.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/implement.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/commit.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/memory.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/conversation.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/error-handling.md"
        
        # Test that Claude-specific commands contain enhanced content
        test_file_content "$test_name" "$project_dir/.claude/commands/specify.md" "Claude's advanced reasoning"
        test_file_content "$test_name" "$project_dir/.claude/commands/implement.md" "Claude's advanced reasoning"
        test_file_content "$test_name" "$project_dir/.claude/commands/commit.md" "Claude's advanced reasoning"
        test_file_content "$test_name" "$project_dir/.claude/commands/memory.md" "memory capabilities"
        test_file_content "$test_name" "$project_dir/.claude/commands/conversation.md" "multi-turn conversations"
        test_file_content "$test_name" "$project_dir/.claude/commands/error-handling.md" "error handling and recovery"
        
        print_test_result "$test_name" "PASS" "Claude-specific commands installation completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Claude-specific commands installation failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test fallback to default commands
test_fallback_to_default_commands() {
    local test_name="fallback_to_default_commands"
    local project_dir="$TEST_DIR/test-fallback"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Temporarily rename .claude directory to test fallback
    local claude_dir="$PROJECT_ROOT/.claude"
    local claude_backup="$PROJECT_ROOT/.claude.backup"
    if [[ -d "$claude_dir" ]]; then
        mv "$claude_dir" "$claude_backup"
    fi
    
    # Run installation with Claude agent (should fallback to default commands)
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent claude 2>&1); then
        # Test that default commands are installed (fallback)
        test_file_exists "$test_name" "$project_dir/.claude/commands/specify.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/implement.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/commit.md"
        
        # Test that default commands do NOT contain Claude-specific content
        if grep -q "Claude's advanced reasoning" "$project_dir/.claude/commands/specify.md"; then
            print_test_result "$test_name" "FAIL" "Default commands should not contain Claude-specific content"
        else
            print_test_result "$test_name" "PASS" "Default commands do not contain Claude-specific content"
        fi
        
        print_test_result "$test_name" "PASS" "Fallback to default commands completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Fallback to default commands failed: $install_output"
    fi
    
    # Restore .claude directory
    if [[ -d "$claude_backup" ]]; then
        mv "$claude_backup" "$claude_dir"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test only-commands mode with Claude
test_only_commands_claude() {
    local test_name="only_commands_claude"
    local project_dir="$TEST_DIR/test-only-commands-claude"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation with only-commands mode and Claude agent
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent claude --only-commands 2>&1); then
        # Test that Claude-specific commands are installed directly
        test_file_exists "$test_name" "$project_dir/.claude/commands/specify.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/implement.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/commit.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/memory.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/conversation.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/error-handling.md"
        
        # Test that .contextual directory is NOT created in only-commands mode
        if [[ ! -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual directory not created in only-commands mode"
        else
            print_test_result "$test_name" "FAIL" ".contextual directory should not be created in only-commands mode"
        fi
        
        print_test_result "$test_name" "PASS" "Only-commands mode with Claude completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Only-commands mode with Claude failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test command inclusion with Claude-specific commands
test_command_inclusion_claude() {
    local test_name="command_inclusion_claude"
    local project_dir="$TEST_DIR/test-include-claude"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation including only specific Claude commands
    local install_output
    if install_output=$(bash "$INSTALL_SCRIPT" "$project_dir" --agent claude --include "specify.md,memory.md" 2>&1); then
        # Test that included commands ARE installed
        test_file_exists "$test_name" "$project_dir/.claude/commands/specify.md"
        test_file_exists "$test_name" "$project_dir/.claude/commands/memory.md"
        
        # Test that non-included commands are NOT installed
        test_file_exists "$test_name" "$project_dir/.claude/commands/implement.md" "false"
        test_file_exists "$test_name" "$project_dir/.claude/commands/commit.md" "false"
        test_file_exists "$test_name" "$project_dir/.claude/commands/conversation.md" "false"
        test_file_exists "$test_name" "$project_dir/.claude/commands/error-handling.md" "false"
        
        print_test_result "$test_name" "PASS" "Command inclusion with Claude-specific commands completed successfully"
    else
        print_test_result "$test_name" "FAIL" "Command inclusion with Claude-specific commands failed: $install_output"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Main test runner
main() {
    echo -e "${BLUE}Running Claude-specific install.sh tests...${NC}"
    echo "=============================================="
    
    # Ensure test directory exists
    mkdir -p "$TEST_DIR"
    
    # Run all tests
    test_claude_specific_commands
    test_fallback_to_default_commands
    test_only_commands_claude
    test_command_inclusion_claude
    
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
