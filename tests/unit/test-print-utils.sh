#!/bin/bash

# Unit tests for print-utils.sh

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEST_UTILS_DIR="$SCRIPT_DIR/../utils"

# Source the test framework
source "$TEST_UTILS_DIR/test-framework.sh"

# Source the module under test
source "$PROJECT_ROOT/.contextual/scripts/bash/utils/print-utils.sh"

# ============================================================================
# Test Functions
# ============================================================================

test_print_header() {
    local output=$(print_header "Test Header")
    
    assert_contains "$output" "=================================" "Header contains top border"
    assert_contains "$output" "Test Header" "Header contains title"
}

test_print_success() {
    local output=$(print_success "Test success message")
    
    assert_contains "$output" "✓" "Success message contains checkmark"
    assert_contains "$output" "Test success message" "Success message contains text"
}

test_print_error() {
    local output=$(print_error "Test error message")
    
    assert_contains "$output" "✗" "Error message contains X mark"
    assert_contains "$output" "Test error message" "Error message contains text"
}

test_print_warning() {
    local output=$(print_warning "Test warning message")
    
    assert_contains "$output" "⚠" "Warning message contains warning symbol"
    assert_contains "$output" "Test warning message" "Warning message contains text"
}

test_print_info() {
    local output=$(print_info "Test info message")
    
    assert_contains "$output" "ℹ" "Info message contains info symbol"
    assert_contains "$output" "Test info message" "Info message contains text"
}

test_functions_are_callable() {
    # Test that functions are defined and callable (they're already sourced in this script)
    assert_success "print_header is callable" type print_header
    assert_success "print_success is callable" type print_success
    assert_success "print_error is callable" type print_error
    assert_success "print_warning is callable" type print_warning
    assert_success "print_info is callable" type print_info
}

# ============================================================================
# Main Test Runner
# ============================================================================

main() {
    init_test_suite "Print Utils Tests"
    
    test_print_header
    test_print_success
    test_print_error
    test_print_warning
    test_print_info
    test_functions_are_callable
    
    print_test_summary
    exit $?
}

# Run tests
main "$@"

