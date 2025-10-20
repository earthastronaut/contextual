#!/bin/bash

# scripts/dev/cli.sh - Development subcommands for contextual CLI
# Provides development utilities for the contextual project

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_error() {
    echo -e "${RED}[contextual dev] ERROR:${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}[contextual dev] SUCCESS:${NC} $1"
}

print_info() {
    echo -e "${BLUE}[contextual dev] INFO:${NC} $1"
}

# Show help for dev subcommands
show_help() {
    cat << EOF
Contextual Development CLI - Development Utilities

USAGE:
    contextual dev <subcommand> [options]

SUBCOMMANDS:
    test                  Run all tests for contextual development tools
    update-links          Symlink commands from ./commands/* and ./tests/commands/* 
                          to .cursor/commands/ for local development
    help                  Show this help message

EXAMPLES:
    contextual dev test
    contextual dev test --verbose
    contextual dev update-links
    contextual dev help

DESCRIPTION:
    The dev command provides utilities for local development on the contextual project.
    
    test:
        Runs the test suite for the contextual project. Supports all test options
        like --verbose, --list, --cleanup, etc.
    
    update-links:
        Creates symlinks for all commands from ./commands/* and ./tests/commands/* 
        to .cursor/commands/, allowing you to use and test commands locally within 
        Cursor AI IDE.

EOF
}

# Main function
main() {
    # Handle case when no arguments provided
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    # Parse subcommand
    local subcommand="$1"
    shift # Remove subcommand from arguments
    
    case "$subcommand" in
        "test")
            # Run tests from tests directory
            local test_script="$PROJECT_ROOT/tests/run-tests.sh"
            if [[ ! -f "$test_script" ]]; then
                print_error "Test script not found: $test_script"
                exit 1
            fi
            if [[ ! -x "$test_script" ]]; then
                print_error "Test script is not executable: $test_script"
                exit 1
            fi
            print_info "Executing run-tests.sh with arguments: $*"
            if "$test_script" "$@"; then
                print_success "run-tests.sh completed successfully"
            else
                local exit_code=$?
                print_error "run-tests.sh failed with exit code $exit_code"
                exit $exit_code
            fi
            ;;
        "update-links")
            local script_path="$SCRIPT_DIR/update-links.sh"
            if [[ ! -f "$script_path" ]]; then
                print_error "Script not found: update-links.sh"
                exit 1
            fi
            if [[ ! -x "$script_path" ]]; then
                print_error "Script is not executable: $script_path"
                exit 1
            fi
            "$script_path" "$@"
            ;;
        "help")
            show_help
            ;;
        *)
            print_error "Unknown subcommand: $subcommand"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

