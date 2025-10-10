#!/bin/bash

# run-tests.sh - Test runner for contextual development tools
# Runs all tests and provides a comprehensive test report

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
TEST_DIR="$PROJECT_ROOT/tests"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Function to print colored output
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_test_header() {
    echo -e "\n${CYAN}Running: $1${NC}"
    echo -e "${CYAN}$(printf '=%.0s' {1..50})${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Function to cleanup test artifacts
cleanup_test_artifacts() {
    print_info "Cleaning up test artifacts..."
    
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
            print_info "Removing directory: $dir"
            rm -rf "$dir" 2>/dev/null || true
        fi
    done
    
    # Clean up any test files that might have been created
    local temp_files=(
        "$PROJECT_ROOT/.test-*"
        "$PROJECT_ROOT/test-*"
        "$PROJECT_ROOT/*.tmp"
        "$PROJECT_ROOT/*.temp"
    )
    
    for pattern in "${temp_files[@]}"; do
        if ls $pattern 2>/dev/null | grep -q .; then
            print_info "Removing temporary files: $pattern"
            rm -f $pattern 2>/dev/null || true
        fi
    done
    
    # Clean up any test artifacts in subdirectories
    find "$PROJECT_ROOT" -name "test-*" -type d -exec rm -rf {} + 2>/dev/null || true
    find "$PROJECT_ROOT" -name ".test-*" -type d -exec rm -rf {} + 2>/dev/null || true
    
    print_success "Test cleanup completed"
}

# Function to run a test file
run_test_file() {
    local test_file="$1"
    local test_name="$(basename "$test_file" .sh)"
    
    if [[ ! -f "$test_file" ]]; then
        print_error "Test file not found: $test_file"
        return 1
    fi
    
    if [[ ! -x "$test_file" ]]; then
        print_warning "Making test file executable: $test_file"
        chmod +x "$test_file"
    fi
    
    print_test_header "$test_name"
    
    local start_time=$(date +%s)
    local exit_code=0
    
    # Run the test and capture output
    if bash "$test_file" 2>&1; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        print_success "$test_name completed successfully (${duration}s)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        print_error "$test_name failed (${duration}s)"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        exit_code=1
    fi
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Clean up after each test
    cleanup_test_artifacts
    
    return $exit_code
}

# Function to run all tests
run_all_tests() {
    print_header "Contextual Development Tools - Test Suite"
    echo -e "${BLUE}Project Root: $PROJECT_ROOT${NC}"
    echo -e "${BLUE}Test Directory: $TEST_DIR${NC}"
    echo -e "${BLUE}Timestamp: $(date)${NC}"
    
    # Check if test directory exists
    if [[ ! -d "$TEST_DIR" ]]; then
        print_error "Test directory not found: $TEST_DIR"
        exit 1
    fi
    
    # Find all test files
    local test_files=()
    while IFS= read -r -d '' file; do
        test_files+=("$file")
    done < <(find "$TEST_DIR" -name "*.sh" -type f -print0 | sort -z)
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        print_warning "No test files found in $TEST_DIR"
        return 0
    fi
    
    print_info "Found ${#test_files[@]} test file(s)"
    
    # Run each test file
    local failed_tests=()
    for test_file in "${test_files[@]}"; do
        if ! run_test_file "$test_file"; then
            failed_tests+=("$(basename "$test_file" .sh)")
        fi
    done
    
    # Print summary
    print_header "Test Summary"
    echo -e "${BLUE}Total Tests: $TOTAL_TESTS${NC}"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
    echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    echo -e "${YELLOW}Skipped: $SKIPPED_TESTS${NC}"
    
    if [[ ${#failed_tests[@]} -gt 0 ]]; then
        echo -e "\n${RED}Failed Tests:${NC}"
        for test in "${failed_tests[@]}"; do
            echo -e "${RED}  - $test${NC}"
        done
    fi
    
    # Calculate success rate
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        echo -e "\n${BLUE}Success Rate: ${success_rate}%${NC}"
        
        if [[ $success_rate -eq 100 ]]; then
            print_success "All tests passed! 🎉"
        elif [[ $success_rate -ge 80 ]]; then
            print_warning "Most tests passed, but some failed"
        else
            print_error "Many tests failed"
        fi
    else
        print_warning "No tests were run"
    fi
    
    # Final cleanup
    echo ""
    cleanup_test_artifacts
    
    # Return appropriate exit code
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        if [[ $success_rate -eq 100 ]]; then
            return 0
        else
            return 1
        fi
    else
        return 0
    fi
}

# Function to run specific test
run_specific_test() {
    local test_name="$1"
    local test_file="$TEST_DIR/${test_name}.sh"
    
    if [[ ! -f "$test_file" ]]; then
        print_error "Test file not found: $test_file"
        print_info "Available tests:"
        find "$TEST_DIR" -name "*.sh" -type f -exec basename {} .sh \; | sort
        exit 1
    fi
    
    print_header "Running Specific Test: $test_name"
    run_test_file "$test_file"
    
    # Final cleanup for specific test
    echo ""
    cleanup_test_artifacts
}

# Function to list available tests
list_tests() {
    print_header "Available Tests"
    
    if [[ ! -d "$TEST_DIR" ]]; then
        print_error "Test directory not found: $TEST_DIR"
        exit 1
    fi
    
    local test_files=()
    while IFS= read -r -d '' file; do
        test_files+=("$file")
    done < <(find "$TEST_DIR" -name "*.sh" -type f -print0 | sort -z)
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        print_warning "No test files found"
        return 0
    fi
    
    for test_file in "${test_files[@]}"; do
        local test_name="$(basename "$test_file" .sh)"
        local test_desc=""
        
        # Try to extract description from test file
        if [[ -f "$test_file" ]]; then
            test_desc=$(head -n 5 "$test_file" | grep -E "^#.*test|^#.*Test" | head -n 1 | sed 's/^# *//' || echo "No description")
        fi
        
        echo -e "${BLUE}$test_name${NC}"
        if [[ -n "$test_desc" && "$test_desc" != "No description" ]]; then
            echo -e "  ${YELLOW}$test_desc${NC}"
        fi
        echo
    done
}

# Function to show help
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] [TEST_NAME]

Run tests for contextual development tools.

OPTIONS:
    -h, --help          Show this help message
    -l, --list          List available tests
    -a, --all           Run all tests (default)
    -v, --verbose       Enable verbose output
    -q, --quiet         Suppress output except for results
    -c, --cleanup       Clean up test artifacts and exit

ARGUMENTS:
    TEST_NAME           Run specific test by name (without .sh extension)

EXAMPLES:
    $0                  # Run all tests
    $0 --all            # Run all tests
    $0 --list           # List available tests
    $0 simple-test      # Run specific test
    $0 --verbose        # Run all tests with verbose output
    $0 --cleanup        # Clean up test artifacts

EOF
}

# Main function
main() {
    local run_all=true
    local test_name=""
    local verbose=false
    local quiet=false
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
            -a|--all)
                run_all=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            -c|--cleanup)
                cleanup_only=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$test_name" ]]; then
                    test_name="$1"
                    run_all=false
                else
                    print_error "Multiple test names provided: $test_name and $1"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Handle cleanup-only mode
    if [[ "$cleanup_only" == true ]]; then
        print_header "Cleaning Up Test Artifacts"
        cleanup_test_artifacts
        exit 0
    fi
    
    # Set up output based on options
    if [[ "$quiet" == true ]]; then
        exec 1>/dev/null
    fi
    
    # Run tests
    if [[ "$run_all" == true ]]; then
        run_all_tests
    else
        run_specific_test "$test_name"
    fi
}

# Run main function
main "$@"
