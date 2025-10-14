#!/bin/bash

# Branch naming and management utilities for spec-driven development
# Usage: source .contextual/scripts/bash/utils/branch-utils.sh

# No colors - using default terminal colors

# Function to sanitize feature name for branch naming
sanitize_feature_name() {
    local feature_name="$1"
    # Convert to lowercase, replace spaces and special chars with hyphens
    echo "$feature_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# Function to get current feature name from branch
get_current_feature_name() {
    local current_branch=$(git branch --show-current 2>/dev/null)
    if [[ $current_branch == feature/* ]]; then
        echo "${current_branch#feature/}"
    else
        echo ""
    fi
}

# Function to get current feature name in original case
get_current_feature_display_name() {
    local feature_name=$(get_current_feature_name)
    if [[ -n "$feature_name" ]]; then
        # Try to get original name from context file
        local context_file="specs/$feature_name/context.md"
        if [[ -f "$context_file" ]]; then
            # Extract from the first heading
            local display_name=$(grep "^# Feature:" "$context_file" | sed 's/^# Feature: *//' | head -1)
            if [[ -n "$display_name" ]]; then
                echo "$display_name"
                return
            fi
        fi
        # Fallback to sanitized name
        echo "$feature_name"
    else
        echo ""
    fi
}

# Function to check if we're on a feature branch
is_feature_branch() {
    local current_branch=$(git branch --show-current 2>/dev/null)
    [[ $current_branch == feature/* ]]
}

# Function to check if we're NOT on the main branch
is_not_main_branch() {
    local current_branch=$(git branch --show-current 2>/dev/null)
    [[ -n "$current_branch" && "$current_branch" != "$MAIN_BRANCH" ]]
}

# Function to get feature directory path
get_feature_dir() {
    local feature_name=$(get_current_feature_name)
    if [[ -n "$feature_name" ]]; then
        echo "specs/$feature_name"
    else
        echo ""
    fi
}

# Function to get context file path
get_feature_context_file() {
    local feature_dir=$(get_feature_dir)
    if [[ -n "$feature_dir" ]]; then
        echo "$feature_dir/context.md"
    else
        echo ""
    fi
}

# Function to validate feature setup
validate_feature_setup() {
    local feature_dir=$(get_feature_dir)
    local context_file=$(get_feature_context_file)
    local current_branch=$(git branch --show-current 2>/dev/null)
    
    if [[ -z "$feature_dir" ]]; then
        echo "Error: Not on a feature branch"
        return 1
    fi
    
    # Check that we're actually on the current feature branch
    if [[ "$current_branch" != "feature/$(get_current_feature_name)" ]]; then
        echo "Error: Not on the expected feature branch. Current: $current_branch, Expected: feature/$(get_current_feature_name)"
        return 1
    fi
    
    if [[ ! -d "$feature_dir" ]]; then
        echo "Error: Feature directory not found: $feature_dir"
        return 1
    fi
    
    if [[ ! -f "$context_file" ]]; then
        echo "Error: Context file not found: $context_file"
        return 1
    fi
    
    echo "Feature setup is valid"
    echo "  Feature: $(get_current_feature_display_name)"
    echo "  Branch: $current_branch"
    echo "  Directory: $feature_dir"
    echo "  Context: $context_file"
    return 0
}

# Export functions for use in other scripts
export -f sanitize_feature_name
export -f get_current_feature_name
export -f get_current_feature_display_name
export -f is_feature_branch
export -f is_not_main_branch
export -f get_feature_dir
export -f get_feature_context_file
export -f validate_feature_setup
