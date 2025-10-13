#!/bin/bash

# Merge prerequisites command implementation
# Returns merge variables for use in merge operations

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"
source "$SCRIPT_DIR/utils/env-utils.sh"
source "$SCRIPT_DIR/utils/branch-utils.sh"
source "$SCRIPT_DIR/utils/feature-utils.sh"

# Main merge prerequisites function - returns variables only
get_merge_prerequisites() {
    # Check prerequisites
    if ! check_merge_prerequisites; then
        print_error "Prerequisites not met. Please ensure you're on a feature branch with a context file and no uncommitted changes."
        return 1
    fi
    
    # Get and output merge variables
    output_merge_variables
    
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
