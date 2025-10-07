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
    local feature_name="$1"
    local specs_dir="${2:-./specs}"
    
    if [[ -z "$feature_name" ]]; then
        echo "Error: Feature name is required"
        echo "Usage: specify_feature \"Feature Name\" [specs_directory]"
        return 1
    fi
    
    # Create sanitized version of feature name
    local sanitized_name=$(sanitize_feature_name "$feature_name")
    
    # Scan specs folder for max number
    local max_num=0
    if [[ -d "$specs_dir" ]]; then
        # Use ls and sed to parse existing numbered directories
        while IFS= read -r dir; do
            if [[ $dir =~ ^([0-9]{4})- ]]; then
                local num="${BASH_REMATCH[1]}"
                # Remove leading zeros for comparison
                num=$((10#$num))
                if [[ $num -gt $max_num ]]; then
                    max_num=$num
                fi
            fi
        done < <(ls "$specs_dir" 2>/dev/null | grep -E '^[0-9]{4}-')
    fi
    
    # Add 1 to get next number
    local next_num=$((max_num + 1))
    local numbered_feature_name=$(printf "%04d-%s" "$next_num" "$sanitized_name")
    
    # Create feature branch using the numbered feature name
    local branch_name="feature/$numbered_feature_name"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi
    
    # Check if branch already exists
    if git show-ref --verify --quiet refs/heads/"$branch_name"; then
        echo "Branch $branch_name already exists. Switching to it."
        git checkout "$branch_name"
        if [[ $? -ne 0 ]]; then
            echo "Failed to switch to existing branch"
            return 1
        fi
    else
        echo "Creating feature branch: $branch_name"
        # Create and switch to new branch
        git checkout -b "$branch_name"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create feature branch"
            return 1
        fi
        echo "Created and switched to branch: $branch_name"
    fi
    
    # Create context template
    create_context_template "$feature_name" "$numbered_feature_name"
    if [[ $? -ne 0 ]]; then
        echo "Failed to create context template"
        return 1
    fi
    
    # Context file created: specs/$numbered_feature_name/context.md
    local context_file="specs/$numbered_feature_name/context.md"
    
    # Verify context file was created
    if [[ ! -f "$context_file" ]]; then
        echo "Error: Context file was not created: $context_file"
        return 1
    fi
    
    # Echo key variables
    echo "FEATURE: $numbered_feature_name"
    echo "FEATURE_INPUT: $feature_name"
    echo "FEATURE_BRANCH: $branch_name"
    echo "FEATURE_DIR: specs/$numbered_feature_name"
    echo "FEATURE_CONTEXT: $context_file"
    
    echo ""
    echo "✅ Feature specification created successfully!"
    echo "   You can now edit the context file to define your feature requirements."
    
    return 0
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -eq 0 ]]; then
        echo "Error: Feature name is required"
        echo "Usage: $0 \"Feature Name\" [specs_directory]"
        exit 1
    fi
    
    specify_feature "$1" "$2"
fi
