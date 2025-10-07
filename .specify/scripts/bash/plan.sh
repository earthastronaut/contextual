#!/bin/bash

# Plan command implementation
# Returns feature variables for use in plan.md command

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/branch-utils.sh"
source "$SCRIPT_DIR/file-utils.sh"

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
    
    return 0
}

# Function to get feature variables
get_feature_variables() {
    local context_file=$(get_context_file)
    local feature_name=$(get_current_feature_display_name)
    local feature_dir=$(get_feature_dir)
    local feature_branch=$(git branch --show-current)
    
    # Output variables in format expected by plan.md
    echo "FEATURE: $feature_name"
    echo "FEATURE_BRANCH: $feature_branch"
    echo "FEATURE_DIR: $feature_dir"
    echo "FEATURE_CONTEXT: $context_file"
    
    # Export variables for use by other scripts
    export FEATURE_NAME="$feature_name"
    export FEATURE_BRANCH="$feature_branch"
    export FEATURE_DIR="$feature_dir"
    export FEATURE_CONTEXT="$context_file"
}

# Main plan function - returns variables only
plan_feature() {
    # Check prerequisites
    if ! check_prerequisites; then
        echo "Error: Prerequisites not met. Please ensure you're on a feature branch with a context file."
        return 1
    fi
    
    # Get and output feature variables
    get_feature_variables
    
    return 0
}

# Function to show help
show_plan_help() {
    print_header "Plan Command Help"
    echo ""
    echo "Usage: plan"
    echo ""
    echo "Purpose: Returns feature variables for use in plan.md command"
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
    echo "  plan"
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        -h|--help|help)
            show_plan_help
            ;;
        *)
            plan_feature
            ;;
    esac
fi
