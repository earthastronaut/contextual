#!/bin/bash

# Merge prerequisites command implementation
# Returns merge variables for use in merge operations

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"
source "$SCRIPT_DIR/utils/env-utils.sh"
source "$SCRIPT_DIR/utils/branch-utils.sh"

# Function to check prerequisites
check_prerequisites() {
    # Check if we're in a valid environment
    if ! validate_environment; then
        return 1
    fi
    
    # Check if we're on a feature branch
    if ! is_feature_branch; then
        return 1
    fi
    
    # Check if context file exists
    local context_file=$(get_context_file)
    if [[ -z "$context_file" || ! -f "$context_file" ]]; then
        return 1
    fi
    
    # Check if branch is clean (no uncommitted changes)
    if ! git diff-index --quiet HEAD --; then
        print_error "Branch has uncommitted changes. Please commit or stash changes before merging."
        print_error "Use 'git status' to see uncommitted changes."
        return 1
    fi
    
    # Check if there are untracked files that might be important
    local untracked_files=$(git ls-files --others --exclude-standard)
    if [[ -n "$untracked_files" ]]; then
        print_warning "There are untracked files in the repository:"
        echo "$untracked_files" | sed 's/^/  /'
        print_warning "Consider adding and committing important files before merging."
    fi
    
    return 0
}

# Function to get merge variables
get_merge_variables() {
    local feature_branch=$(git branch --show-current)
    local feature_name=$(get_current_feature_display_name)
    
    # Output variables in format expected by merge operations
    echo "MERGE_TEMPLATE: $MERGE_TEMPLATE"
    echo "FEATURE_SPEC: $(get_context_file)"
    
    # Export variables for use by other scripts
    export FEATURE_SPEC="$(get_context_file)"
    export MERGE_TEMPLATE="$MERGE_TEMPLATE"
}

# Main merge prerequisites function - returns variables only
get_merge_prerequisites() {
    # Check prerequisites
    if ! check_prerequisites; then
        print_error "Prerequisites not met. Please ensure you're on a feature branch with a context file."
        return 1
    fi
    
    # Get and output merge variables
    get_merge_variables
    
    return 0
}

# Function to show help
show_merge_prerequisites_help() {
    print_header "Merge Prerequisites Command Help"
    echo ""
    echo "Usage: merge-prerequisites"
    echo ""
    echo "Purpose: Returns merge variables for use in merge operations"
    echo ""
    echo "Prerequisites:"
    echo "  - Must be on a feature branch"
    echo "  - Feature context file must exist"
    echo "  - Branch must be clean (no uncommitted changes)"
    echo ""
    echo "What it does:"
    echo "  1. Checks prerequisites"
    echo "  2. Returns merge variables (FEATURE_BRANCH, FEATURE_SPEC, FEATURE_NAME)"
    echo ""
    echo "Example:"
    echo "  merge-prerequisites"
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        -h|--help|help)
            show_merge_prerequisites_help
            ;;
        *)
            get_merge_prerequisites
            ;;
    esac
fi
