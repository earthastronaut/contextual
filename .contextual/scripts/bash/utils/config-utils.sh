#!/bin/bash

# Configuration utilities for spec-driven development
# Usage: source .contextual/scripts/bash/utils/config-utils.sh

# Function to load configuration overrides
load_config_overrides() {
    # Check for environment variables first
    # Format: CONTEXTUAL_<VARIABLE_NAME>
    # Example: CONTEXTUAL_SPECIFY_ROOT, CONTEXTUAL_CONTEXT_DIR, etc.
    
    # Check for configuration file
    local config_file="${CONTEXTUAL_CONFIG_FILE:-.contextual/config}"
    
    if [[ -f "$config_file" ]]; then
        # Source the configuration file if it exists
        # This allows users to set variables like:
        # SPECIFY_ROOT="custom/path"
        # CONTEXT_DIR="custom/context"
        source "$config_file" 2>/dev/null || true
    fi
}

# Load any configuration overrides
load_config_overrides

# Configuration variables with override support
# These can be overridden by environment variables or config file
GIT_REPO_ROOT="${CONTEXTUAL_GIT_REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
CONTEXTUAL_ROOT="${CONTEXTUAL_CONTEXTUAL_ROOT:-.contextual}"
CONTEXT_DIR="${CONTEXTUAL_CONTEXT_DIR:-$CONTEXTUAL_ROOT/context}"
CONTEXT_ROOT="${CONTEXTUAL_CONTEXT_ROOT:-$CONTEXT_DIR/README.md}"
SPECS_DIR="${CONTEXTUAL_SPECS_DIR:-specs}"
MAIN_BRANCH="${CONTEXTUAL_MAIN_BRANCH:-main}"
MERGE_TEMPLATE="${CONTEXTUAL_MERGE_TEMPLATE:-Merge \{FEATURE_BRANCH\}: \{DESCRIPTION\}}"

# Function to get all context files
get_context_files() {
    if [[ -d "$CONTEXT_DIR" ]]; then
        find "$CONTEXT_DIR" -type f 2>/dev/null | sort
    else
        echo ""
    fi
}

# Function to refresh the CONTEXT variable
refresh_context() {
    CONTEXT=$(get_context_files)
    export CONTEXT
}

# Function to show current configuration
show_config() {
    echo "Current Configuration:" >&2
    echo "  GIT_REPO_ROOT: $GIT_REPO_ROOT" >&2
    echo "  CONTEXTUAL_ROOT: $CONTEXTUAL_ROOT" >&2
    echo "  CONTEXT_DIR: $CONTEXT_DIR" >&2
    echo "  CONTEXT_ROOT: $CONTEXT_ROOT" >&2
    echo "  SPECS_DIR: $SPECS_DIR" >&2
    echo "  CONTEXT: $CONTEXT" >&2
}

# Function to create a sample configuration file
create_sample_config() {
    local config_file="${1:-.contextual/config}"
    local config_dir=$(dirname "$config_file")
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    cat > "$config_file" << 'EOF'
# Contextual Configuration File
# Uncomment and modify the variables below to override defaults

# CONTEXTUAL_ROOT="custom/.contextual"
# CONTEXT_DIR="custom/context"
# CONTEXT_ROOT="custom/context/README.md"
# SPECS_DIR="custom/specs"
# GIT_REPO_ROOT="/custom/git/root"

# Note: You can also set these as environment variables:
# export CONTEXTUAL_CONTEXTUAL_ROOT="custom/.contextual"
# export CONTEXTUAL_CONTEXT_DIR="custom/context"
# export CONTEXTUAL_CONTEXT_ROOT="custom/context/README.md"
# export CONTEXTUAL_SPECS_DIR="custom/specs"
# export CONTEXTUAL_GIT_REPO_ROOT="/custom/git/root"
EOF
    
    echo "Sample configuration file created at: $config_file" >&2
}

# Initialize CONTEXT variable with all files in .contextual/context
refresh_context

# Export variables and functions for use in other scripts
export GIT_REPO_ROOT
export CONTEXTUAL_ROOT
export CONTEXT_DIR
export SPECS_DIR
export MAIN_BRANCH
export CONTEXT
export -f get_context_files
export -f refresh_context
export -f show_config
export -f create_sample_config

echo "Configuration utilities loaded" >&2
