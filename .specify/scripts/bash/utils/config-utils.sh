#!/bin/bash

# Configuration utilities for spec-driven development
# Usage: source .specify/scripts/bash/utils/config-utils.sh

# Configuration variables
SPECIFY_ROOT=".specify"
CONTEXT_DIR="$SPECIFY_ROOT/context"
SCRIPTS_DIR="$SPECIFY_ROOT/scripts/bash"
SPECS_DIR="specs"

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

# Initialize CONTEXT variable with all files in .specify/context
refresh_context

# Export variables and functions for use in other scripts
export SPECIFY_ROOT
export CONTEXT_DIR
export SCRIPTS_DIR
export SPECS_DIR
export CONTEXT
export -f get_context_files
export -f refresh_context

echo "Configuration utilities loaded" >&2
