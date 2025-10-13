#!/bin/bash

# Analysis Utilities
# Provides helper functions for project analysis operations

# ============================================================================
# Analysis Type Configuration
# ============================================================================

# Define default analysis types for each depth level
_SHALLOW_ANALYSIS_TYPES="structure"
_STANDARD_ANALYSIS_TYPES="$_SHALLOW_ANALYSIS_TYPES,components,architecture"
_DEEP_ANALYSIS_TYPES="$_STANDARD_ANALYSIS_TYPES,dependencies,relationships,quality"

# Get analysis types for a given depth level
# Args:
#   $1 - depth level (shallow|standard|deep)
# Returns:
#   Comma-separated list of analysis types
get_analysis_types_for_depth() {
    local depth="$1"
    
    case "$depth" in
        shallow)
            echo "$_SHALLOW_ANALYSIS_TYPES"
            ;;
        standard)
            echo "$_STANDARD_ANALYSIS_TYPES"
            ;;
        deep)
            echo "$_DEEP_ANALYSIS_TYPES"
            ;;
        *)
            # Default to standard if invalid depth provided
            echo "$_STANDARD_ANALYSIS_TYPES"
            ;;
    esac
}

# Normalize depth level, returning 'standard' for invalid values
# Args:
#   $1 - depth level to normalize
# Returns:
#   Normalized depth level
normalize_analysis_depth() {
    local depth="$1"
    
    case "$depth" in
        shallow|standard|deep)
            echo "$depth"
            ;;
        *)
            echo "standard"
            ;;
    esac
}

# ============================================================================
# Template Management
# ============================================================================

# Copy template files based on analysis types
# Args:
#   $1 - analysis output directory path
#   $2 - comma-separated list of analysis types
# Returns:
#   0 on success, 1 on error
copy_analysis_templates() {
    local analysis_output_dir="$1"
    local analysis_types="$2"
    local templates_dir="$CONTEXTUAL_ROOT/templates/analyzed"

    # Validate arguments
    if [[ -z "$analysis_output_dir" ]]; then
        echo "Error: analysis_output_dir is required" >&2
        return 1
    fi
    
    if [[ -z "$analysis_types" ]]; then
        echo "Error: analysis_types is required" >&2
        return 1
    fi
    
    if [[ ! -d "$templates_dir" ]]; then
        echo "Error: templates directory not found: $templates_dir" >&2
        return 1
    fi

    # Create output directory if it doesn't exist
    mkdir -p "$analysis_output_dir"
    
    # Convert comma-separated types to array
    IFS=',' read -ra types_array <<< "$analysis_types"
    
    # Copy over the README.md template
    if [[ -f "$templates_dir/README.md" ]]; then
        cp "$templates_dir/README.md" "$analysis_output_dir/README.md"
    fi

    # Copy templates for requested analysis types
    for type in "${types_array[@]}"; do
        # Trim whitespace
        type=$(echo "$type" | xargs)
        
        # Determine template filename for this type
        local template="${type}.md"
        
        if [[ -f "$templates_dir/$template" ]]; then
            cp "$templates_dir/$template" "$analysis_output_dir/$template"
        fi
    done
    
    return 0
}

# ============================================================================
# Validation
# ============================================================================

# Validate analysis input directory
# Args:
#   $1 - directory path to validate
# Returns:
#   0 if valid, 1 if invalid
validate_analysis_input_dir() {
    local input_dir="$1"
    
    if [[ -z "$input_dir" ]]; then
        echo "Error: ANALYSIS_INPUT_DIR is not set" >&2
        return 1
    fi
    
    if [[ ! -d "$input_dir" ]]; then
        echo "Error: Invalid ANALYSIS_INPUT_DIR path: $input_dir" >&2
        return 1
    fi
    
    return 0
}

