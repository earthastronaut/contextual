#!/bin/bash

# Unit tests for config-utils.sh

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEST_UTILS_DIR="$SCRIPT_DIR/../utils"

# Source the test framework
source "$TEST_UTILS_DIR/test-framework.sh"

# ============================================================================
# Test Functions
# ============================================================================

test_config_variables_are_set() {
    # Source config-utils in a subshell to isolate environment
    (
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        # Test that key configuration variables are set
        assert_not_empty "$GIT_REPO_ROOT" "GIT_REPO_ROOT is set"
        assert_not_empty "$CONTEXTUAL_ROOT" "CONTEXTUAL_ROOT is set"
        assert_not_empty "$SPECS_DIR" "SPECS_DIR is set"
        assert_not_empty "$MAIN_BRANCH" "MAIN_BRANCH is set"
    )
}

test_config_defaults() {
    # Test default values (in clean environment)
    (
        unset CONTEXTUAL_CONTEXTUAL_ROOT
        unset CONTEXTUAL_SPECS_DIR
        unset CONTEXTUAL_MAIN_BRANCH
        
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        assert_equals ".contextual" "$CONTEXTUAL_ROOT" "Default CONTEXTUAL_ROOT"
        assert_equals "specs" "$SPECS_DIR" "Default SPECS_DIR"
        assert_equals "main" "$MAIN_BRANCH" "Default MAIN_BRANCH"
    )
}

test_config_environment_overrides() {
    # Test that environment variables override defaults
    (
        export CONTEXTUAL_SPECS_DIR="custom-specs"
        export CONTEXTUAL_MAIN_BRANCH="master"
        
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        assert_equals "custom-specs" "$SPECS_DIR" "SPECS_DIR overridden by environment"
        assert_equals "master" "$MAIN_BRANCH" "MAIN_BRANCH overridden by environment"
    )
}

test_get_context_files() {
    (
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        # Test that function exists and is callable
        assert_success "get_context_files is callable" type get_context_files
        
        # Test that it returns something (or nothing if no context files)
        local result=$(get_context_files)
        # Just verify it runs without error - result may be empty or contain files
        assert_success "get_context_files executes successfully" get_context_files
    )
}

test_refresh_context() {
    (
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        # Test that function exists and is callable
        assert_success "refresh_context is callable" type refresh_context
        
        # Test that it runs without error
        assert_success "refresh_context executes successfully" refresh_context
        
        # After refresh, CONTEXT should be set (even if empty)
        # This is now set by the script itself
        if [[ "${CONTEXT+set}" == "set" ]]; then
            echo "  ✓ CONTEXT variable is set after refresh"
        else
            echo "  ✗ CONTEXT variable not set after refresh"
            return 1
        fi
    )
}

test_show_config() {
    (
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        # Test that function exists and is callable
        assert_success "show_config is callable" type show_config
        
        # Test that it produces output
        local output=$(show_config 2>&1)
        assert_not_empty "$output" "show_config produces output"
        assert_contains "$output" "Current Configuration:" "Output contains header"
        assert_contains "$output" "GIT_REPO_ROOT:" "Output contains GIT_REPO_ROOT"
        assert_contains "$output" "CONTEXTUAL_ROOT:" "Output contains CONTEXTUAL_ROOT"
    )
}

test_functions_are_callable() {
    (
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        # Test that functions are defined and callable
        assert_success "get_context_files is callable" type get_context_files
        assert_success "refresh_context is callable" type refresh_context
        assert_success "show_config is callable" type show_config
    )
}

test_load_config_overrides() {
    # Create a temporary config file
    local test_dir=$(create_test_dir)
    local config_file="$test_dir/.contextual/config"
    mkdir -p "$test_dir/.contextual"
    
    # Write custom config
    cat > "$config_file" << 'EOF'
SPECS_DIR="test-specs"
MAIN_BRANCH="develop"
EOF
    
    # Test loading config file
    (
        cd "$test_dir"
        export CONTEXTUAL_CONFIG_FILE="$config_file"
        source "$PROJECT_ROOT/.contextual/scripts/bash/utils/config-utils.sh"
        
        assert_equals "test-specs" "$SPECS_DIR" "Config file overrides SPECS_DIR"
        assert_equals "develop" "$MAIN_BRANCH" "Config file overrides MAIN_BRANCH"
    )
    
    cleanup_test_dir "$test_dir"
}

# ============================================================================
# Main Test Runner
# ============================================================================

main() {
    init_test_suite "Config Utils Tests"
    
    test_config_variables_are_set
    test_config_defaults
    test_config_environment_overrides
    test_get_context_files
    test_refresh_context
    test_show_config
    test_functions_are_callable
    test_load_config_overrides
    
    print_test_summary
    exit $?
}

# Run tests
main "$@"

