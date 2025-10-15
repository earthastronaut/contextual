#!/bin/bash

# run-tests.sh - Unified Test Runner for Contextual Development Tools
# Runs all test categories and provides comprehensive reporting

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR"
PROJECT_ROOT="$(cd "$TEST_DIR/.." && pwd)"

# Source test framework for utilities
source "$TEST_DIR/utils/test-framework.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Test category counters
TOTAL_CATEGORIES=0
PASSED_CATEGORIES=0
FAILED_CATEGORIES=0

# Overall test counters (for detailed tracking)
TOTAL_INDIVIDUAL_TESTS=0
PASSED_INDIVIDUAL_TESTS=0
FAILED_INDIVIDUAL_TESTS=0

# Verbosity flag
VERBOSE=false
QUIET=false

# ============================================================================
# Output Functions
# ============================================================================

print_header() {
    if [[ "$QUIET" == false ]]; then
        echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║  $1${NC}"
        echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    fi
}

print_section() {
    if [[ "$QUIET" == false ]]; then
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${CYAN}  $1${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    fi
}

print_category() {
    if [[ "$QUIET" == false ]]; then
        echo ""
        echo -e "${MAGENTA}▶ $1${NC}"
        echo -e "${MAGENTA}$(printf '─%.0s' {1..60})${NC}"
    fi
}

print_success() {
    if [[ "$QUIET" == false ]]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    if [[ "$QUIET" == false ]]; then
        echo -e "${YELLOW}⚠ $1${NC}"
    fi
}

print_info() {
    if [[ "$QUIET" == false ]]; then
        echo -e "${BLUE}ℹ $1${NC}"
    fi
}

# ============================================================================
# Test Category Runners
# ============================================================================

run_test_file() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .sh)
    
    if [[ "$VERBOSE" == true ]]; then
        print_info "Running: $test_name"
    fi
    
    local start_time=$(date +%s)
    
    if [[ "$VERBOSE" == true ]]; then
        bash "$test_file"
    else
        bash "$test_file" 2>&1 | tail -20
    fi
    
    local exit_code=${PIPESTATUS[0]}
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [[ $exit_code -eq 0 ]]; then
        if [[ "$VERBOSE" == true ]]; then
            print_success "$test_name completed (${duration}s)"
        fi
        return 0
    else
        print_error "$test_name failed (${duration}s)"
        return 1
    fi
}

run_tests_category() {
    local category_name="$1" # integration, unit
    print_category "$category_name"
    
    TOTAL_CATEGORIES=$((TOTAL_CATEGORIES + 1))
    
    # Get test files from category
    local test_files=()
    while IFS= read -r file; do
        [[ -n "$file" ]] && test_files+=("$file")
    done < <(get_test_files "$TEST_DIR/$category_name")
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        print_warning "No tests found in $TEST_DIR/$category_name"
        PASSED_CATEGORIES=$((PASSED_CATEGORIES + 1))
        return 0
    fi
    
    local failed_tests=()
    local start_time=$(date +%s)
    
    for test_file in "${test_files[@]}"; do
        if ! run_test_file "$test_file"; then
            failed_tests+=("$(basename "$test_file" .sh)")
        fi
    done
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [[ ${#failed_tests[@]} -eq 0 ]]; then
        PASSED_CATEGORIES=$((PASSED_CATEGORIES + 1))
        print_success "$category_name completed (${duration}s)"
        return 0
    else
        FAILED_CATEGORIES=$((FAILED_CATEGORIES + 1))
        print_error "$category_name failed - ${#failed_tests[@]} test(s) failed (${duration}s)"
        for test in "${failed_tests[@]}"; do
            print_error "  - $test"
        done
        return 1
    fi
}

# ============================================================================
# Cleanup Functions
# ============================================================================

cleanup_test_artifacts() {
    if [[ "$VERBOSE" == true ]]; then
        print_info "Cleaning up test artifacts..."
    fi
    
    # Clean up test directories
    local cleanup_dirs=(
        "$PROJECT_ROOT/test-scenarios"
        "$PROJECT_ROOT/test-new-project"
        "$PROJECT_ROOT/test-existing-project"
        "$PROJECT_ROOT/test-custom-root"
        "$PROJECT_ROOT/test-different-agents"
        "$PROJECT_ROOT/test-args"
        "$PROJECT_ROOT/test-simple-test-project"
        "$PROJECT_ROOT/test-simple-existing-project"
        "$PROJECT_ROOT/test-simple-custom-project"
        "$PROJECT_ROOT/test-interactive-project"
        "$PROJECT_ROOT/test-debug-test"
    )
    
    for dir in "${cleanup_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            rm -rf "$dir" 2>/dev/null || true
        fi
    done
    
    # Clean up any test files that might have been created
    find "$PROJECT_ROOT" -maxdepth 1 -name "test-*" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$PROJECT_ROOT" -maxdepth 1 \( -name ".test-*" -o -name "*.tmp" -o -name "*.temp" \) -type f -exec rm -f {} + 2>/dev/null || true
}


# ============================================================================
# Main Test Runner
# ============================================================================

run_all_tests() {
    print_header "Contextual Development Tools - Test Suite"
    
    if [[ "$QUIET" == false ]]; then
        echo -e "${BLUE}Project Root: $PROJECT_ROOT${NC}"
        echo -e "${BLUE}Test Directory: $TEST_DIR${NC}"
        echo -e "${BLUE}Timestamp: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    fi
    
    # Check if test directory exists
    if [[ ! -d "$TEST_DIR" ]]; then
        print_error "Test directory not found: $TEST_DIR"
        exit 1
    fi
    
    local overall_start_time=$(date +%s)
    
    # Run test categories
    print_section "Running Test Categories"
        
    # Run integration tests
    run_tests_category "integration" || true
    
    local overall_end_time=$(date +%s)
    local total_duration=$((overall_end_time - overall_start_time))
    
    # Cleanup after all tests
    cleanup_test_artifacts
    
    # Print final summary
    print_section "Final Test Summary"
    
    echo ""
    echo -e "${BLUE}Test Categories:${NC}"
    echo -e "  Total:  $TOTAL_CATEGORIES"
    echo -e "  ${GREEN}Passed: $PASSED_CATEGORIES${NC}"
    echo -e "  ${RED}Failed: $FAILED_CATEGORIES${NC}"
    echo ""
    echo -e "${BLUE}Total Duration: ${total_duration}s${NC}"
    echo ""
    
    # Calculate success rate
    if [[ $TOTAL_CATEGORIES -gt 0 ]]; then
        local success_rate=$((PASSED_CATEGORIES * 100 / TOTAL_CATEGORIES))
        echo -e "${BLUE}Success Rate: ${success_rate}%${NC}"
        echo ""
        
        if [[ $success_rate -eq 100 ]]; then
            print_header "✓ ALL TESTS PASSED! 🎉"
            return 0
        elif [[ $success_rate -ge 80 ]]; then
            print_warning "Most tests passed, but some failed"
            return 1
        else
            print_error "Many tests failed"
            return 1
        fi
    else
        print_warning "No tests were run"
        return 0
    fi
}

# ============================================================================
# List Tests
# ============================================================================

list_tests() {
    print_header "Available Test Categories"
    
    echo -e "${CYAN}Unit Tests${NC}"
    echo "  Location: tests/unit/"
    if [[ -d "$TEST_DIR/unit" ]]; then
        find "$TEST_DIR/unit" -name "test-*.sh" -type f | while read -r file; do
            echo "    - $(basename "$file" .sh)"
        done
    fi
    echo ""
    
    echo -e "${CYAN}Integration Tests${NC}"
    echo "  Location: tests/integration/"
    if [[ -d "$TEST_DIR/integration" ]]; then
        find "$TEST_DIR/integration" -name "test-*.sh" -type f | while read -r file; do
            echo "    - $(basename "$file" .sh)"
        done
    fi
    echo ""
    
    print_info "Run 'contextual test' to run all tests"
    print_info "Run 'contextual test --verbose' for detailed output"
}

# ============================================================================
# Help
# ============================================================================

show_help() {
    cat << EOF
Contextual Development Tools - Test Runner

USAGE:
    contextual test [OPTIONS]
    ./tests/run-tests.sh [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -l, --list          List available test categories
    -v, --verbose       Enable verbose output (show all test details)
    -q, --quiet         Minimal output (errors only)
    --cleanup           Clean up test artifacts and exit

EXAMPLES:
    contextual test                 # Run all tests
    contextual test --verbose       # Run with detailed output
    contextual test --list          # List all test categories
    contextual test --cleanup       # Clean up test artifacts

TEST CATEGORIES:
    - Unit Tests:        Fast, isolated tests for bash utilities
    - Integration Tests: End-to-end tests for install and workflow scripts

EXIT CODES:
    0 - All tests passed
    1 - Some tests failed

EOF
}

# ============================================================================
# Main Entry Point
# ============================================================================

main() {
    local cleanup_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_tests
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -q|--quiet)
                QUIET=true
                shift
                ;;
            --cleanup)
                cleanup_only=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done
    
    # Handle cleanup-only mode
    if [[ "$cleanup_only" == true ]]; then
        print_header "Cleaning Up Test Artifacts"
        cleanup_test_artifacts
        print_success "Cleanup completed"
        exit 0
    fi
    
    # Suppress output based on quiet flag
    if [[ "$QUIET" == true ]]; then
        run_all_tests 2>&1 | grep -E "(✓ ALL|✗|⚠)" || true
        exit ${PIPESTATUS[0]}
    else
        run_all_tests
    fi
}

# Run main function
main "$@"
