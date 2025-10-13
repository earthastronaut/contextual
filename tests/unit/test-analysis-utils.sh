#!/bin/bash

# Unit tests for analysis-utils.sh

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEST_UTILS_DIR="$SCRIPT_DIR/../utils"

# Source the test framework
source "$TEST_UTILS_DIR/test-framework.sh"

# Mock CONTEXTUAL_ROOT
export CONTEXTUAL_ROOT="$PROJECT_ROOT/.contextual"

# Source the module under test
source "$PROJECT_ROOT/.contextual/scripts/bash/utils/analysis-utils.sh"

# ============================================================================
# Test Functions
# ============================================================================

test_get_analysis_types_for_depth_shallow() {
    local result=$(get_analysis_types_for_depth "shallow")
    assert_equals "structure" "$result" "Shallow depth returns structure only"
}

test_get_analysis_types_for_depth_standard() {
    local result=$(get_analysis_types_for_depth "standard")
    assert_equals "structure,components,architecture" "$result" "Standard depth returns correct types"
}

test_get_analysis_types_for_depth_deep() {
    local result=$(get_analysis_types_for_depth "deep")
    assert_equals "structure,components,architecture,dependencies,relationships,quality" "$result" "Deep depth returns all types"
}

test_get_analysis_types_for_depth_invalid() {
    local result=$(get_analysis_types_for_depth "invalid")
    assert_equals "structure,components,architecture" "$result" "Invalid depth defaults to standard"
}

test_normalize_analysis_depth_valid() {
    local result=$(normalize_analysis_depth "shallow")
    assert_equals "shallow" "$result" "Returns shallow as-is"
    
    result=$(normalize_analysis_depth "standard")
    assert_equals "standard" "$result" "Returns standard as-is"
    
    result=$(normalize_analysis_depth "deep")
    assert_equals "deep" "$result" "Returns deep as-is"
}

test_normalize_analysis_depth_invalid() {
    local result=$(normalize_analysis_depth "invalid")
    assert_equals "standard" "$result" "Invalid depth normalizes to standard"
    
    result=$(normalize_analysis_depth "")
    assert_equals "standard" "$result" "Empty depth normalizes to standard"
}

test_copy_analysis_templates_missing_args() {
    # Test with missing analysis_output_dir
    assert_failure "Fails with missing output dir" copy_analysis_templates "" "structure"
    
    # Test with missing analysis_types
    assert_failure "Fails with missing analysis types" copy_analysis_templates "/tmp/test" ""
}

test_copy_analysis_templates_invalid_templates_dir() {
    # Mock CONTEXTUAL_ROOT to non-existent directory
    local old_contextual_root="$CONTEXTUAL_ROOT"
    CONTEXTUAL_ROOT="/tmp/nonexistent-contextual-root-$$"
    
    local test_dir=$(create_test_dir)
    assert_failure "Fails with invalid templates directory" copy_analysis_templates "$test_dir" "structure"
    
    cleanup_test_dir "$test_dir"
    CONTEXTUAL_ROOT="$old_contextual_root"
}

test_copy_analysis_templates_creates_output_dir() {
    local test_dir=$(create_test_dir)
    local output_dir="$test_dir/analyzed"
    
    # Check if templates directory exists
    if [[ -d "$CONTEXTUAL_ROOT/templates/analyzed" ]]; then
        # This will succeed if templates exist
        copy_analysis_templates "$output_dir" "structure" 2>/dev/null || true
        assert_dir_exists "$output_dir" "Creates output directory"
    else
        # Skip test if templates don't exist
        echo "  SKIP: Templates directory not found"
        TESTS_RUN=$((TESTS_RUN + 1))
    fi
    
    cleanup_test_dir "$test_dir"
}

test_validate_analysis_input_dir_valid() {
    local test_dir=$(create_test_dir)
    
    local result=$(validate_analysis_input_dir "$test_dir" 2>&1)
    assert_success "Succeeds with valid directory" validate_analysis_input_dir "$test_dir"
    
    cleanup_test_dir "$test_dir"
}

test_validate_analysis_input_dir_empty() {
    assert_failure "Fails with empty input dir" validate_analysis_input_dir ""
}

test_validate_analysis_input_dir_invalid() {
    assert_failure "Fails with non-existent directory" validate_analysis_input_dir "/tmp/nonexistent-dir-$$"
}

test_functions_are_accessible() {
    # Test that functions are defined and callable
    assert_success "get_analysis_types_for_depth is defined" type get_analysis_types_for_depth
    assert_success "normalize_analysis_depth is defined" type normalize_analysis_depth
    assert_success "copy_analysis_templates is defined" type copy_analysis_templates
    assert_success "validate_analysis_input_dir is defined" type validate_analysis_input_dir
}

# ============================================================================
# Main Test Runner
# ============================================================================

main() {
    init_test_suite "Analysis Utils Tests"
    
    test_get_analysis_types_for_depth_shallow
    test_get_analysis_types_for_depth_standard
    test_get_analysis_types_for_depth_deep
    test_get_analysis_types_for_depth_invalid
    test_normalize_analysis_depth_valid
    test_normalize_analysis_depth_invalid
    test_copy_analysis_templates_missing_args
    test_copy_analysis_templates_invalid_templates_dir
    test_copy_analysis_templates_creates_output_dir
    test_validate_analysis_input_dir_valid
    test_validate_analysis_input_dir_empty
    test_validate_analysis_input_dir_invalid
    test_functions_are_accessible
    
    print_test_summary
    exit $?
}

# Run tests
main "$@"

