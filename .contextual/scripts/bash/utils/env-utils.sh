#!/bin/bash

# Environment validation utilities for spec-driven development
# Usage: source .contextual/scripts/bash/utils/env-utils.sh

# Source print utilities for error messages
_ENV_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_ENV_UTILS_DIR/print-utils.sh"

# Function to check if git repository is initialized
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        return 1
    fi
    return 0
}

# Function to check if we're in the project root
check_project_root() {
    if [[ ! -d ".contextual" ]]; then
        print_error "Not in project root. Expected .contextual directory."
        return 1
    fi
    return 0
}

# Function to validate environment
validate_environment() {
    print_info "Validating environment..."
    
    if ! check_git_repo; then
        return 1
    fi
    
    if ! check_project_root; then
        return 1
    fi
    
    print_success "Environment validation passed"
    return 0
}

# Export functions for use in other scripts
export -f check_git_repo
export -f check_project_root
export -f validate_environment

