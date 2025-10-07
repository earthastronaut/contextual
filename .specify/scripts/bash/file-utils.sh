#!/bin/bash

# File discovery and context management utilities for spec-driven development
# Usage: source .specify/scripts/bash/file-utils.sh

# No colors - using default terminal colors

# Function to find all context files
find_context_files() {
    find . -path "./specs/*/context.md" -type f 2>/dev/null | sort
}

# Function to get context file for current feature
get_current_context_file() {
    # Source branch utils if not already loaded
    if ! declare -f get_context_file >/dev/null 2>&1; then
        source "$(dirname "${BASH_SOURCE[0]}")/branch-utils.sh"
    fi
    get_context_file
}

# Function to update task status in context file
update_task_status() {
    local context_file="$1"
    local task_pattern="$2"
    local status="$3"  # "completed" or "pending"
    
    if [[ ! -f "$context_file" ]]; then
        echo "Error: Context file not found: $context_file"
        return 1
    fi
    
    local temp_file=$(mktemp)
    local task_marker=""
    
    if [[ "$status" == "completed" ]]; then
        task_marker="- [x]"
    else
        task_marker="- [ ]"
    fi
    
    # Update the task in the file
    sed "s/^- \[[ x]\] $task_pattern/$task_marker $task_pattern/" "$context_file" > "$temp_file"
    
    if [[ $? -eq 0 ]]; then
        mv "$temp_file" "$context_file"
        echo "Updated task: $task_pattern"
    else
        rm -f "$temp_file"
        echo "Failed to update task: $task_pattern"
        return 1
    fi
}

# Function to add new task to context file
add_task() {
    local context_file="$1"
    local task="$2"
    
    if [[ ! -f "$context_file" ]]; then
        echo "Error: Context file not found: $context_file"
        return 1
    fi
    
    # Find the tasks section and add the new task
    local temp_file=$(mktemp)
    local in_tasks_section=false
    local task_added=false
    
    while IFS= read -r line; do
        if [[ "$line" == "## Tasks" ]]; then
            in_tasks_section=true
            echo "$line" >> "$temp_file"
        elif [[ "$in_tasks_section" == true && "$line" == "" && "$task_added" == false ]]; then
            echo "- [ ] $task" >> "$temp_file"
            task_added=true
            echo "$line" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$context_file"
    
    if [[ "$task_added" == true ]]; then
        mv "$temp_file" "$context_file"
        echo "Added task: $task"
    else
        rm -f "$temp_file"
        echo "Failed to add task: $task"
        return 1
    fi
}

# Function to get project structure for context
get_project_structure() {
    local max_depth="${1:-3}"
    echo "Project structure (max depth: $max_depth):"
    find . -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.specify/*" | \
    head -20 | \
    while read -r file; do
        local depth=$(echo "$file" | tr -cd '/' | wc -c)
        if [[ $depth -le $max_depth ]]; then
            echo "  $file"
        fi
    done
}

# Function to find related files for a feature
find_related_files() {
    local feature_name="$1"
    local context_file="specs/$feature_name/context.md"
    
    if [[ ! -f "$context_file" ]]; then
        echo "Error: Context file not found: $context_file"
        return 1
    fi
    
    echo "Finding files related to feature: $feature_name"
    
    # Find files that might be related based on feature name
    local sanitized_name=$(echo "$feature_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    
    echo "Potential related files:"
    find . -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.specify/*" | \
    grep -i "$sanitized_name" | head -10
    
    echo "Files in feature directory:"
    find "specs/$feature_name" -type f 2>/dev/null
}

# Function to create feature directory structure
create_feature_structure() {
    local feature_name="$1"
    local numbered_name="$2"
    
    # Use numbered name if provided, otherwise sanitize the feature name
    local feature_dir="specs/$numbered_name"
    
    echo "Creating feature structure for: $feature_name"
    
    # Create main directory only
    mkdir -p "$feature_dir"
    
    echo "Created feature structure: $feature_dir"
    echo "  - $feature_dir/context.md"
}

# Backup functionality removed - no longer creating backups in context folder

# Export functions for use in other scripts
export -f find_context_files
export -f get_current_context_file
export -f update_task_status
export -f add_task
export -f get_project_structure
export -f find_related_files
export -f create_feature_structure

echo "File utilities loaded" >&2
