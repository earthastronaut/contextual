#!/bin/bash

# Unit tests for env-utils.sh

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEST_UTILS_DIR="$SCRIPT_DIR/../utils"

# Source the test framework
source "$TEST_UTILS_DIR/test-framework.sh"

# Source the module under test (this also sources print-utils.sh)
source "$PROJECT_ROOT/.contextual/scripts/bash/utils/env-utils.sh"

# ============================================================================
# Test Functions
# ============================================================================

test_check_git_repo_valid() {
    # We're in a git repo, so this should pass
    assert_success "Succeeds in git repository" check_git_repo
}

test_check_git_repo_invalid() {
    # Create a temp directory that's not a git repo
    local test_dir=$(create_test_dir)
    
    # Run check_git_repo in the non-git directory
    (cd "$test_dir" && assert_failure "Fails outside git repository" check_git_repo)
    
    cleanup_test_dir "$test_dir"
}

test_check_project_root_valid() {
    # Save current directory
    local orig_dir="$PWD"
    
    # Change to project root
    cd "$PROJECT_ROOT"
    assert_success "Succeeds at project root" check_project_root
    
    # Restore directory
    cd "$orig_dir"
}

test_check_project_root_invalid() {
    # Create a temp directory without .contextual
    local test_dir=$(create_test_dir)
    
    # Run check_project_root in directory without .contextual
    (cd "$test_dir" && assert_failure "Fails without .contextual directory" check_project_root)
    
    cleanup_test_dir "$test_dir"
}

test_validate_environment_valid() {
    # Save current directory
    local orig_dir="$PWD"
    
    # Change to project root (which is a git repo with .contextual)
    cd "$PROJECT_ROOT"
    assert_success "Succeeds with valid environment" validate_environment
    
    # Restore directory
    cd "$orig_dir"
}

test_validate_environment_no_git() {
    # Create a temp directory that's not a git repo
    local test_dir=$(create_test_dir)
    mkdir -p "$test_dir/.contextual"
    
    # Run validate_environment in the non-git directory
    (cd "$test_dir" && assert_failure "Fails without git repository" validate_environment)
    
    cleanup_test_dir "$test_dir"
}

test_validate_environment_no_contextual() {
    # Create a temp git repo without .contextual
    local test_dir=$(create_test_dir)
    (cd "$test_dir" && git init -q)
    
    # Run validate_environment in directory without .contextual
    (cd "$test_dir" && assert_failure "Fails without .contextual directory" validate_environment)
    
    cleanup_test_dir "$test_dir"
}

test_functions_are_callable() {
    # Test that functions are defined and callable (they're already sourced in this script)
    assert_success "check_git_repo is callable" type check_git_repo
    assert_success "check_project_root is callable" type check_project_root
    assert_success "validate_environment is callable" type validate_environment
}

# ============================================================================
# Main Test Runner
# ============================================================================

main() {
    init_test_suite "Environment Utils Tests"
    
    test_check_git_repo_valid
    test_check_git_repo_invalid
    test_check_project_root_valid
    test_check_project_root_invalid
    test_validate_environment_valid
    test_validate_environment_no_git
    test_validate_environment_no_contextual
    test_functions_are_callable
    
    print_test_summary
    exit $?
}

# Run tests
main "$@"

