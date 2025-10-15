#!/bin/bash

# Test: Core Functionality Testing
# Tests for core functionality documented in README.md and implemented in install.sh
# Verifies that the system provides all documented features and capabilities

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$TEST_DIR")"
INSTALL_SCRIPT="$PROJECT_ROOT/scripts/install.sh"
README="$PROJECT_ROOT/README.md"
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

# Function to test documented file structure
test_documented_structure() {
    local test_name="documented_structure"
    local project_dir="$TEST_DIR/test-structure"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation
    if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
        # Test structure documented in README:
        # {agent}/commands/      # AI commands linked from .contextual/commands/
        # .contextual/          # Configuration and utilities
        # |-- commands/         # AI commands (/specify, /implement, etc.)
        # |-- config.yaml       # Configuration file
        # |-- context/          # Global context storage
        
        # Test .cursor/commands/ (default agent)
        if [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" ".cursor/commands directory exists"
        else
            print_test_result "$test_name" "FAIL" ".cursor/commands directory missing"
        fi
        
        # Test .contextual/ directory
        if [[ -d "$project_dir/.contextual" ]]; then
            print_test_result "$test_name" "PASS" ".contextual directory exists"
        else
            print_test_result "$test_name" "FAIL" ".contextual directory missing"
        fi
        
        # Test .contextual/commands/
        if [[ -d "$project_dir/.contextual/commands" ]]; then
            print_test_result "$test_name" "PASS" ".contextual/commands directory exists"
        else
            print_test_result "$test_name" "FAIL" ".contextual/commands directory missing"
        fi
        
        # Test .contextual/config.yaml
        if [[ -f "$project_dir/.contextual/config.yaml" ]]; then
            print_test_result "$test_name" "PASS" ".contextual/config.yaml file exists"
        else
            print_test_result "$test_name" "FAIL" ".contextual/config.yaml file missing"
        fi
        
        # Test .contextual/context/
        if [[ -d "$project_dir/.contextual/context" ]]; then
            print_test_result "$test_name" "PASS" ".contextual/context directory exists"
        else
            print_test_result "$test_name" "FAIL" ".contextual/context directory missing"
        fi
    else
        print_test_result "$test_name" "FAIL" "Installation failed"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test documented commands exist
test_documented_commands() {
    local test_name="documented_commands"
    local project_dir="$TEST_DIR/test-commands"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation
    if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
        # Test core commands documented in README
        local documented_commands=("specify.md" "implement.md" "commit.md" "merge.md" "contextualize.md" "clarify.md" "plan.md" "analyze.md" "task.md")
        
        for cmd in "${documented_commands[@]}"; do
            # Check if command exists in .contextual/commands/
            if [[ -f "$project_dir/.contextual/commands/$cmd" ]]; then
                print_test_result "$test_name" "PASS" "Command $cmd exists in .contextual/commands"
            else
                print_test_result "$test_name" "FAIL" "Command $cmd missing from .contextual/commands"
            fi
            
            # Check if symlink exists in .cursor/commands/
            if [[ -L "$project_dir/.cursor/commands/$cmd" ]]; then
                print_test_result "$test_name" "PASS" "Symlink for $cmd exists in .cursor/commands"
            else
                print_test_result "$test_name" "FAIL" "Symlink for $cmd missing from .cursor/commands"
            fi
        done
    else
        print_test_result "$test_name" "FAIL" "Installation failed"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test supported agents
test_supported_agents() {
    local test_name="supported_agents"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Test agents documented in README: cursor, claude, gemini, copilot, windsurf, roo, auggie, q
    local documented_agents=("cursor" "claude" "gemini" "copilot" "windsurf" "roo" "auggie" "q")
    
    for agent in "${documented_agents[@]}"; do
        local project_dir="$TEST_DIR/test-agent-$agent"
        rm -rf "$project_dir" 2>/dev/null || true
        
        # Try to install with this agent
        if bash "$INSTALL_SCRIPT" "$project_dir" --agent "$agent" >/dev/null 2>&1; then
            print_test_result "$test_name" "PASS" "Agent $agent installation succeeded"
            
            # Verify agent-specific directory was created
            local agent_folder=""
            case "$agent" in
                "cursor") agent_folder=".cursor/commands" ;;
                "claude") agent_folder=".claude/commands" ;;
                "gemini") agent_folder=".gemini/commands" ;;
                "copilot") agent_folder=".github/copilot/commands" ;;
                "windsurf") agent_folder=".windsurf/commands" ;;
                "roo") agent_folder=".roo/commands" ;;
                "auggie") agent_folder=".augment/commands" ;;
                "q") agent_folder=".amazonq/commands" ;;
            esac
            
            if [[ -d "$project_dir/$agent_folder" ]]; then
                print_test_result "$test_name" "PASS" "Agent $agent directory created: $agent_folder"
            else
                print_test_result "$test_name" "FAIL" "Agent $agent directory missing: $agent_folder"
            fi
        else
            print_test_result "$test_name" "FAIL" "Agent $agent installation failed"
        fi
        
        # Cleanup
        rm -rf "$project_dir" 2>/dev/null || true
    done
}

# Function to test install options
test_install_options() {
    local test_name="install_options"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Test documented install options from README:
    # contextual install /path/to/project
    # contextual install /path/to/project --agent cursor --contextual-root .dev-tools
    
    # Test basic install
    local project_dir="$TEST_DIR/test-basic-install"
    rm -rf "$project_dir" 2>/dev/null || true
    
    if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
        print_test_result "$test_name" "PASS" "Basic install works"
    else
        print_test_result "$test_name" "FAIL" "Basic install failed"
    fi
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Test install with --agent option
    project_dir="$TEST_DIR/test-agent-option"
    rm -rf "$project_dir" 2>/dev/null || true
    
    if bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor >/dev/null 2>&1; then
        print_test_result "$test_name" "PASS" "Install with --agent option works"
    else
        print_test_result "$test_name" "FAIL" "Install with --agent option failed"
    fi
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Test install with --contextual-root option
    project_dir="$TEST_DIR/test-contextual-root-option"
    rm -rf "$project_dir" 2>/dev/null || true
    
    if bash "$INSTALL_SCRIPT" "$project_dir" --contextual-root .dev-tools >/dev/null 2>&1; then
        if [[ -d "$project_dir/.dev-tools" ]]; then
            print_test_result "$test_name" "PASS" "Install with --contextual-root option works"
        else
            print_test_result "$test_name" "FAIL" "Install with --contextual-root option failed to create directory"
        fi
    else
        print_test_result "$test_name" "FAIL" "Install with --contextual-root option failed"
    fi
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Test install with multiple options
    project_dir="$TEST_DIR/test-multiple-options"
    rm -rf "$project_dir" 2>/dev/null || true
    
    if bash "$INSTALL_SCRIPT" "$project_dir" --agent cursor --contextual-root .custom >/dev/null 2>&1; then
        if [[ -d "$project_dir/.custom" ]] && [[ -d "$project_dir/.cursor/commands" ]]; then
            print_test_result "$test_name" "PASS" "Install with multiple options works"
        else
            print_test_result "$test_name" "FAIL" "Install with multiple options failed"
        fi
    else
        print_test_result "$test_name" "FAIL" "Install with multiple options failed"
    fi
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Test install with --include option (new feature)
    project_dir="$TEST_DIR/test-include-option"
    rm -rf "$project_dir" 2>/dev/null || true
    
    if bash "$INSTALL_SCRIPT" "$project_dir" --include "specify.md,implement.md,commit.md" >/dev/null 2>&1; then
        if [[ -f "$project_dir/.contextual/commands/specify.md" ]] && [[ -f "$project_dir/.contextual/commands/implement.md" ]] && [[ -f "$project_dir/.contextual/commands/commit.md" ]]; then
            if [[ ! -f "$project_dir/.contextual/commands/analyze.md" ]] && [[ ! -f "$project_dir/.contextual/commands/plan.md" ]]; then
                print_test_result "$test_name" "PASS" "Install with --include option works"
            else
                print_test_result "$test_name" "FAIL" "Install with --include option failed to filter commands"
            fi
        else
            print_test_result "$test_name" "FAIL" "Install with --include option failed to include specified commands"
        fi
    else
        print_test_result "$test_name" "FAIL" "Install with --include option failed"
    fi
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test configuration file
test_configuration_file() {
    local test_name="configuration_file"
    local project_dir="$TEST_DIR/test-config"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Run installation
    if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
        # Test that config.yaml exists and is readable
        if [[ -f "$project_dir/.contextual/config.yaml" ]]; then
            print_test_result "$test_name" "PASS" "config.yaml exists"
            
            # Test that config.yaml contains expected keys
            if grep -q "SPECS_DIR:" "$project_dir/.contextual/config.yaml"; then
                print_test_result "$test_name" "PASS" "config.yaml contains SPECS_DIR"
            else
                print_test_result "$test_name" "FAIL" "config.yaml missing SPECS_DIR"
            fi
            
            if grep -q "MAIN_BRANCH:" "$project_dir/.contextual/config.yaml"; then
                print_test_result "$test_name" "PASS" "config.yaml contains MAIN_BRANCH"
            else
                print_test_result "$test_name" "FAIL" "config.yaml missing MAIN_BRANCH"
            fi
        else
            print_test_result "$test_name" "FAIL" "config.yaml missing"
        fi
    else
        print_test_result "$test_name" "FAIL" "Installation failed"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test preservation of existing files (documented feature)
test_file_preservation() {
    local test_name="file_preservation"
    local project_dir="$TEST_DIR/test-preservation"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Clean up any existing test directory
    rm -rf "$project_dir" 2>/dev/null || true
    
    # Create initial installation
    if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
        # Create custom context file
        echo "# Custom Context" > "$project_dir/.contextual/context/custom.md"
        
        # Create custom config
        echo "custom_key: custom_value" >> "$project_dir/.contextual/config.yaml"
        
        # Store original config content
        local original_config=$(cat "$project_dir/.contextual/config.yaml")
        
        # Run installation again (update)
        if bash "$INSTALL_SCRIPT" "$project_dir" >/dev/null 2>&1; then
            # Test that custom context file is preserved
            if [[ -f "$project_dir/.contextual/context/custom.md" ]]; then
                if grep -q "# Custom Context" "$project_dir/.contextual/context/custom.md"; then
                    print_test_result "$test_name" "PASS" "Custom context file preserved during update"
                else
                    print_test_result "$test_name" "FAIL" "Custom context file content changed"
                fi
            else
                print_test_result "$test_name" "FAIL" "Custom context file was removed"
            fi
            
            # Test that config.yaml is preserved
            local updated_config=$(cat "$project_dir/.contextual/config.yaml")
            if [[ "$original_config" == "$updated_config" ]]; then
                print_test_result "$test_name" "PASS" "config.yaml preserved during update"
            else
                print_test_result "$test_name" "FAIL" "config.yaml was modified"
            fi
        else
            print_test_result "$test_name" "FAIL" "Update installation failed"
        fi
    else
        print_test_result "$test_name" "FAIL" "Initial installation failed"
    fi
    
    # Cleanup
    rm -rf "$project_dir" 2>/dev/null || true
}

# Function to test help documentation
test_help_documentation() {
    local test_name="help_documentation"
    
    echo -e "${BLUE}[TEST]${NC} Running: $test_name"
    
    # Test that --help flag works
    local help_output=$(bash "$INSTALL_SCRIPT" --help 2>&1 || true)
    
    if echo "$help_output" | grep -q "Usage:"; then
        print_test_result "$test_name" "PASS" "Help shows usage information"
    else
        print_test_result "$test_name" "FAIL" "Help missing usage information"
    fi
    
    if echo "$help_output" | grep -q "OPTIONS:"; then
        print_test_result "$test_name" "PASS" "Help shows options"
    else
        print_test_result "$test_name" "FAIL" "Help missing options"
    fi
    
    if echo "$help_output" | grep -q "EXAMPLES:"; then
        print_test_result "$test_name" "PASS" "Help shows examples"
    else
        print_test_result "$test_name" "FAIL" "Help missing examples"
    fi
    
    # Test that help documents all supported agents
    local documented_agents=("cursor" "claude" "gemini" "copilot" "windsurf" "roo" "auggie" "q")
    for agent in "${documented_agents[@]}"; do
        if echo "$help_output" | grep -q "$agent"; then
            print_test_result "$test_name" "PASS" "Help documents agent: $agent"
        else
            print_test_result "$test_name" "FAIL" "Help missing agent: $agent"
        fi
    done
    
    # Test that help documents --include option
    if echo "$help_output" | grep -q "\-\-include"; then
        print_test_result "$test_name" "PASS" "Help documents --include option"
    else
        print_test_result "$test_name" "FAIL" "Help missing --include option"
    fi
}

# Main test runner
main() {
    echo -e "${BLUE}Running core functionality tests...${NC}"
    echo "=============================================="
    
    # Ensure test directory exists
    mkdir -p "$TEST_DIR"
    
    # Run all tests
    test_documented_structure
    test_documented_commands
    test_supported_agents
    test_install_options
    test_configuration_file
    test_file_preservation
    test_help_documentation
    
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

