#!/bin/bash

# Shared utilities for feature-related commands
# Used by plan.sh, clarify.sh, implement.sh

# Get script directory for sourcing dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source required utility scripts (only if not already sourced)
if ! declare -f validate_environment >/dev/null 2>&1; then
    source "$SCRIPT_DIR/env-utils.sh"
fi
if ! declare -f is_feature_branch >/dev/null 2>&1; then
    source "$SCRIPT_DIR/branch-utils.sh"
fi
if ! declare -f print_error >/dev/null 2>&1; then
    source "$SCRIPT_DIR/print-utils.sh"
fi

# Function to check basic prerequisites
check_feature_prerequisites() {
    # Check if we're in a valid environment
    if ! validate_environment; then
        return 1
    fi
    
    # Check if we're on a feature branch
    if ! is_feature_branch; then
        return 1
    fi
    
    # Check if context file exists
    local context_file=$(get_feature_context_file)
    if [[ -z "$context_file" || ! -f "$context_file" ]]; then
        return 1
    fi
    
    return 0
}

# Function to get all feature variables (returns as associative array names)
get_all_feature_variables() {
    # Common variables
    local feature_context_file=$(get_feature_context_file)
    local feature_name=$(get_current_feature_display_name)
    local feature_dir=$(get_feature_dir)
    local feature_branch=$(git branch --show-current)
    
    # Export for use by calling scripts
    export FEATURE_NAME="$feature_name"
    export FEATURE_BRANCH="$feature_branch"
    export FEATURE_DIR="$feature_dir"
    export FEATURE_CONTEXT="$feature_context_file"
    export FEATURE_CONTEXT_FILE="$feature_context_file"
}

# Function to output specific variables for plan command
output_plan_variables() {
    get_all_feature_variables
    
    echo "SPECIFY_DIR: $SPECIFY_DIR"
    echo "FEATURE: $FEATURE_NAME"
    echo "FEATURE_CONTEXT: $FEATURE_CONTEXT_FILE"
    echo "CONTEXT_ROOT: $CONTEXT_ROOT"
    
    # Export for use by other scripts
    export SPECIFY_DIR="$SPECIFY_DIR"
}

# Function to output specific variables for clarify command
output_clarify_variables() {
    get_all_feature_variables
    
    echo "CONTEXT_ROOT: $CONTEXT_ROOT"
    echo "GIT_REPO_ROOT: $GIT_REPO_ROOT"
    echo "FEATURE: $FEATURE_NAME"
    echo "FEATURE_BRANCH: $FEATURE_BRANCH"
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_CONTEXT: $FEATURE_CONTEXT"
}

# Function to output specific variables for implement command
output_implement_variables() {
    get_all_feature_variables
    
    echo "FEATURE=\"$FEATURE_NAME\""
    echo "FEATURE_CONTEXT=\"$FEATURE_CONTEXT\""
}

# Function to output specific variables for merge command
output_merge_variables() {
    get_all_feature_variables
    
    echo "MERGE_TEMPLATE: $MERGE_TEMPLATE"
    echo "FEATURE_SPEC: $FEATURE_CONTEXT"
    
    # Export for use by other scripts
    export FEATURE_SPEC="$FEATURE_CONTEXT"
    export MERGE_TEMPLATE="$MERGE_TEMPLATE"
}

# Function to check if context file is ready for implementation
check_context_file_readiness() {
    local context_file=$(get_feature_context_file)
    
    # Check if context file has content
    local line_count=$(wc -l < "$context_file")
    
    if [[ $line_count -lt 10 ]]; then
        print_warning "Context file seems minimal. Consider adding more details."
    fi
    
    # Check for uncommitted changes in context file
    if git ls-files --error-unmatch "$context_file" >/dev/null 2>&1; then
        # File is tracked by git
        if ! git diff --quiet "$context_file"; then
            print_error "Context file has uncommitted changes. Please commit changes before implementation." >&2
            echo "File: $context_file" >&2
            echo "Use: git add '$context_file' && git commit -m 'Update context file'" >&2
            return 1
        fi
    fi
    
    return 0
}

# Function to check merge prerequisites (additional checks for merge operations)
check_merge_prerequisites() {
    # First check basic prerequisites
    if ! check_feature_prerequisites; then
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

