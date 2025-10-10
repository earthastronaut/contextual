#!/bin/bash

# Specify command implementation
# Creates a new feature specification with proper branch and file structure

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"
source "$SCRIPT_DIR/utils/branch-utils.sh"

# No colors - using default terminal colors


# Main specify function
specify_feature() {
    local feature_name="$1"
    local specs_dir="${2:-$SPECS_DIR}"
    
    if [[ -z "$feature_name" ]]; then
        print_error "Feature name is required"
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
        print_error "Not in a git repository"
        return 1
    fi
    
    # Check if branch already exists
    if git show-ref --verify --quiet refs/heads/"$branch_name"; then
        git checkout "$branch_name"
        if [[ $? -ne 0 ]]; then
            print_error "Failed to switch to existing branch"
            return 1
        fi
    else
        # Create and switch to new branch
        git checkout -b "$branch_name"
        if [[ $? -ne 0 ]]; then
            print_error "Failed to create feature branch"
            return 1
        fi
    fi
    
    # Create feature directory and context file
    local feature_dir="$SPECS_DIR/$numbered_feature_name"
    local context_file="$feature_dir/context.md"
    local template_file="$SPECIFY_ROOT/templates/context.md"
    
    # Create feature directory
    mkdir -p "$feature_dir"
    
    # Check if template file exists
    if [[ ! -f "$template_file" ]]; then
        print_error "Template file not found: $template_file"
        return 1
    fi
    
    # Create context.md from template
    sed "s/{{FEATURE_NAME}}/$feature_name/g" "$template_file" > "$context_file"
    if [[ $? -ne 0 ]]; then
        print_error "Failed to create context file from template"
        return 1
    fi
    
    # Verify context file was created
    if [[ ! -f "$context_file" ]]; then
        print_error "Context file was not created: $context_file"
        return 1
    fi
    
    # Echo key variables
    echo "CONTEXT_ROOT: $CONTEXT_ROOT"
    echo "FEATURE: $numbered_feature_name"
    echo "FEATURE_BRANCH: $branch_name"
    echo "FEATURE_DIR: $feature_dir"
    echo "FEATURE_CONTEXT: $context_file"
    
    return 0
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -eq 0 ]]; then
        print_error "Feature name is required"
        echo "Usage: $0 \"Feature Name\" [specs_directory]"
        exit 1
    fi
    
    specify_feature "$1" "$2"
fi
