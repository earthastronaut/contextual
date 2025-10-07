#!/bin/bash

# Implement command implementation
# Returns key variables for FEATURE and FEATURE_CONTEXT

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"
source "$SCRIPT_DIR/utils/branch-utils.sh"

# No colors - using default terminal colors

# Function to check if we're ready to implement
check_implementation_readiness() {
    # Validate feature setup
    if ! validate_feature_setup; then
        return 1
    fi
    
    # Check if context file has content
    local context_file=$(get_context_file)
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

# Function to output JSON format for requirements checking
output_json() {
    local context_file=$(get_context_file)
    if [[ -z "$context_file" ]]; then
        echo '{"error": "No context file found", "ready": false}'
        return 1
    fi
    
    local feature_name=$(get_current_feature_display_name)
    local branch=$(git branch --show-current)
    
    cat << EOF
{
  "ready": true,
  "feature": "$feature_name",
  "branch": "$branch",
  "context_file": "$context_file"
}
EOF
}

# Function to output key variables
output_variables() {
    local context_file=$(get_context_file)
    if [[ -z "$context_file" ]]; then
        print_error "Could not find context file" >&2
        return 1
    fi
    
    local feature_name=$(get_current_feature_display_name)
    local branch=$(git branch --show-current)
    # tasks.md

    # Only output the variables, no other messages
    echo "FEATURE=\"$feature_name\""
    echo "FEATURE_CONTEXT=\"$context_file\""
    echo "FEATURE_BRANCH=\"$branch\""
}

# Main implement function
implement_feature() {
    # Check for JSON output request
    if [[ "$1" == "--json" ]]; then
        output_json
        return $?
    fi
    
    # Check readiness (suppress output for variable mode)
    if ! check_implementation_readiness >/dev/null 2>&1; then
        print_error "Implementation not ready" >&2
        return 1
    fi
    
    # Output key variables
    output_variables
    
    return 0
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    implement_feature "$@"
fi
