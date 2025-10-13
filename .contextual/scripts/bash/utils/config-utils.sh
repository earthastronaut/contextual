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

# =========================
# Configuration variables
# =========================
# Calculated
GIT_REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
# Fixed
CONTEXTUAL_ROOT=".contextual"
# Variable with override support
# Priority: 1) Environment variables (CONTEXTUAL_*), 2) Config file, 3) Defaults
CONTEXTUAL_ROOT="${CONTEXTUAL_CONTEXTUAL_ROOT:-${CONTEXTUAL_ROOT:-.contextual}}"
SPECS_DIR="${CONTEXTUAL_SPECS_DIR:-${SPECS_DIR:-specs}}"
MAIN_BRANCH="${CONTEXTUAL_MAIN_BRANCH:-${MAIN_BRANCH:-main}}"
MERGE_TEMPLATE="${CONTEXTUAL_MERGE_TEMPLATE:-${MERGE_TEMPLATE:-Merge \{FEATURE_BRANCH\}: \{DESCRIPTION\}}}"
# Folder Analyzer Patterns (defaults set in folder-analyzer.sh)
ANALYZE_SKIP_PATTERNS="${CONTEXTUAL_ANALYZE_SKIP_PATTERNS:-${ANALYZE_SKIP_PATTERNS:-}}"
ANALYZE_INCLUDE_PATTERNS="${CONTEXTUAL_ANALYZE_INCLUDE_PATTERNS:-${ANALYZE_INCLUDE_PATTERNS:-}}"
# Calculated
CONTEXT_DIR=$(dirname "$CONTEXTUAL_ROOT")
# =========================

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

# Initialize CONTEXT variable with all files in .contextual/context
refresh_context

# Export variables and functions for use in other scripts
export GIT_REPO_ROOT
export CONTEXTUAL_ROOT
export CONTEXT_DIR
export SPECS_DIR
export MAIN_BRANCH
export ANALYZE_SKIP_PATTERNS
export ANALYZE_INCLUDE_PATTERNS
export CONTEXT
export -f get_context_files
export -f refresh_context
export -f show_config
