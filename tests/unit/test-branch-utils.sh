#!/bin/bash

# Unit tests for branch-utils.sh

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEST_UTILS_DIR="$SCRIPT_DIR/../utils"

# Source the test framework
source "$TEST_UTILS_DIR/test-framework.sh"

# Source the module under test
source "$PROJECT_ROOT/.contextual/scripts/bash/utils/branch-utils.sh"

# ============================================================================
# Test Functions
# ============================================================================

test_sanitize_feature_name_lowercase() {
    local result=$(sanitize_feature_name "Test Feature")
    assert_equals "test-feature" "$result" "Converts to lowercase and replaces spaces"
}

test_sanitize_feature_name_special_chars() {
    local result=$(sanitize_feature_name "Feature@Name#123")
    assert_equals "feature-name-123" "$result" "Replaces special characters with hyphens"
}

test_sanitize_feature_name_multiple_hyphens() {
    local result=$(sanitize_feature_name "Test   Feature")
    assert_equals "test-feature" "$result" "Converts multiple spaces to single hyphen"
}

test_sanitize_feature_name_alphanumeric() {
    # Test with clean alphanumeric input
    local result=$(sanitize_feature_name "Test123Feature456")
    assert_equals "test123feature456" "$result" "Handles alphanumeric strings"
}

test_sanitize_feature_name_numbers() {
    local result=$(sanitize_feature_name "Feature-123-Test")
    assert_equals "feature-123-test" "$result" "Preserves numbers in feature name"
}

test_get_current_feature_name_not_feature_branch() {
    # Mock git command to return non-feature branch
    git() {
        if [[ "$1" == "branch" && "$2" == "--show-current" ]]; then
            echo "main"
        fi
    }
    export -f git
    
    local result=$(get_current_feature_name)
    assert_empty "$result" "Returns empty for non-feature branch"
    
    unset -f git
}

test_get_current_feature_name_feature_branch() {
    # Mock git command to return feature branch
    git() {
        if [[ "$1" == "branch" && "$2" == "--show-current" ]]; then
            echo "feature/test-feature-name"
        fi
    }
    export -f git
    
    local result=$(get_current_feature_name)
    assert_equals "test-feature-name" "$result" "Extracts feature name from branch"
    
    unset -f git
}

test_is_feature_branch_true() {
    # Mock git command to return feature branch
    git() {
        if [[ "$1" == "branch" && "$2" == "--show-current" ]]; then
            echo "feature/test-feature"
        fi
    }
    export -f git
    
    assert_success "Returns success for feature branch" is_feature_branch
    
    unset -f git
}

test_is_feature_branch_false() {
    # Mock git command to return non-feature branch
    git() {
        if [[ "$1" == "branch" && "$2" == "--show-current" ]]; then
            echo "main"
        fi
    }
    export -f git
    
    assert_failure "Returns failure for non-feature branch" is_feature_branch
    
    unset -f git
}

test_get_feature_dir() {
    # Mock get_current_feature_name
    get_current_feature_name() {
        echo "0001-test-feature"
    }
    export -f get_current_feature_name
    
    local result=$(get_feature_dir)
    assert_equals "specs/0001-test-feature" "$result" "Returns correct feature directory path"
    
    unset -f get_current_feature_name
}

test_get_feature_dir_no_feature() {
    # Mock get_current_feature_name to return empty
    get_current_feature_name() {
        echo ""
    }
    export -f get_current_feature_name
    
    local result=$(get_feature_dir)
    assert_empty "$result" "Returns empty when not on feature branch"
    
    unset -f get_current_feature_name
}

test_get_feature_context_file() {
    # Mock get_feature_dir
    get_feature_dir() {
        echo "specs/0001-test-feature"
    }
    export -f get_feature_dir
    
    local result=$(get_feature_context_file)
    assert_equals "specs/0001-test-feature/context.md" "$result" "Returns correct context file path"
    
    unset -f get_feature_dir
}

test_functions_are_callable() {
    # Test that functions are defined and callable
    assert_success "sanitize_feature_name is callable" bash -c "source $PROJECT_ROOT/.contextual/scripts/bash/utils/branch-utils.sh && type sanitize_feature_name"
    assert_success "get_current_feature_name is callable" bash -c "source $PROJECT_ROOT/.contextual/scripts/bash/utils/branch-utils.sh && type get_current_feature_name"
    assert_success "is_feature_branch is callable" bash -c "source $PROJECT_ROOT/.contextual/scripts/bash/utils/branch-utils.sh && type is_feature_branch"
    assert_success "get_feature_dir is callable" bash -c "source $PROJECT_ROOT/.contextual/scripts/bash/utils/branch-utils.sh && type get_feature_dir"
    assert_success "get_feature_context_file is callable" bash -c "source $PROJECT_ROOT/.contextual/scripts/bash/utils/branch-utils.sh && type get_feature_context_file"
}

# ============================================================================
# Main Test Runner
# ============================================================================

main() {
    init_test_suite "Branch Utils Tests"
    
    test_sanitize_feature_name_lowercase
    test_sanitize_feature_name_special_chars
    test_sanitize_feature_name_multiple_hyphens
    test_sanitize_feature_name_alphanumeric
    test_sanitize_feature_name_numbers
    test_get_current_feature_name_not_feature_branch
    test_get_current_feature_name_feature_branch
    test_is_feature_branch_true
    test_is_feature_branch_false
    test_get_feature_dir
    test_get_feature_dir_no_feature
    test_get_feature_context_file
    test_functions_are_callable
    
    print_test_summary
    exit $?
}

# Run tests
main "$@"

