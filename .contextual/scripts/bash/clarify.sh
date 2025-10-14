#!/bin/bash

set -euo pipefail

# Clarify command implementation
# Returns feature variables for use in clarify.md command

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"
source "$SCRIPT_DIR/utils/env-utils.sh"
source "$SCRIPT_DIR/utils/branch-utils.sh"
source "$SCRIPT_DIR/utils/feature-utils.sh"

# Main clarify function - returns variables only
clarify_feature() {
    # Check prerequisites
    if ! check_feature_prerequisites; then
        print_error "Prerequisites not met. Please ensure you're on a feature branch with a context file."
        return 1
    fi
    
    # Get and output feature variables
    output_clarify_variables
    
    return 0
}

# Function to show help
show_clarify_help() {
    print_header "Clarify Command Help"
    echo ""
    echo "Usage: clarify"
    echo ""
    echo "Purpose: Returns feature variables for use in clarify.md command"
    echo ""
    echo "Prerequisites:"
    echo "  - Must be on a feature branch"
    echo "  - Feature context file must exist"
    echo ""
    echo "What it does:"
    echo "  1. Checks prerequisites"
    echo "  2. Returns feature variables (FEATURE, FEATURE_BRANCH, FEATURE_DIR, FEATURE_CONTEXT)"
    echo ""
    echo "Example:"
    echo "  clarify"
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        -h|--help|help)
            show_clarify_help
            ;;
        *)
            clarify_feature
            ;;
    esac
fi