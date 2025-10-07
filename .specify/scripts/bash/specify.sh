#!/bin/bash

# Specify command implementation
# Creates a new feature specification with proper branch and file structure

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/branch-utils.sh"
source "$SCRIPT_DIR/file-utils.sh"

# No colors - using default terminal colors


# Function to create context template
create_context_template() {
    local feature_name="$1"
    local numbered_feature_name="$2"
    local sanitized_name=$(sanitize_feature_name "$feature_name")
    local feature_dir="specs/$numbered_feature_name"
    local context_file="$feature_dir/context.md"
    local template_file=".specify/templates/context.md"
    
    # Create feature directory
    create_feature_structure "$feature_name" "$numbered_feature_name"
    
    # Check if template file exists
    if [[ ! -f "$template_file" ]]; then
        echo "Error: Template file not found: $template_file"
        return 1
    fi
    
    # Create context.md from template
    sed "s/{{FEATURE_NAME}}/$feature_name/g" "$template_file" > "$context_file"
    
    # Return the numbered name for use in branch creation
    echo "$numbered_feature_name"
}

# Main specify function
specify_feature() {
    local input_name="$1"
    
    if [[ -z "$input_name" ]]; then
        echo "Error: Feature name is required"
        echo "Usage: specify_feature \"Feature Name\""
        return 1
    fi
    
    # Get next incremental number for the feature using branch-utils
    local sanitized_name=$(sanitize_feature_name "$input_name")
    local next_num=$(get_next_feature_number "$sanitized_name")
    local numbered_feature_name="$next_num-$sanitized_name"
    
    # Create feature branch
    local branch_name=$(create_feature_branch "$input_name")
    if [[ $? -ne 0 ]]; then
        echo "Failed to create feature branch"
        return 1
    fi
    
    # Create context template
    create_context_template "$input_name" "$numbered_feature_name"
    
    # Context file created: specs/$numbered_feature_name/context.md
    
    # Echo key variables
    echo "FEATURE: $numbered_feature_name"
    echo "FEATURE_INPUT: $input_name"
    echo "FEATURE_BRANCH: $branch_name"
    echo "FEATURE_DIR: specs/$numbered_feature_name"
    echo "FEATURE_CONTEXT: $context_file"
    
    return 0
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -eq 0 ]]; then
        echo "Error: Feature name is required"
        echo "Usage: $0 \"Feature Name\""
        exit 1
    fi
    
    specify_feature "$1"
fi
