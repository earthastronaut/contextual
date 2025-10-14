#!/bin/bash

set -euo pipefail

# Project Structure Analysis Script
# Analyzes a directory and generates structured documentation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/branch-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"
source "$SCRIPT_DIR/utils/analysis-utils.sh"

# ============================================================================
# Help Documentation
# ============================================================================

show_help() {
    cat << EOF
Usage: analyze.sh [DIRECTORY] [OPTIONS]

Analyzes a directory and generates structured documentation based on the
specified depth and analysis types.

ARGUMENTS:
    DIRECTORY              Path to the directory to analyze
                          (default: git repository root)

OPTIONS:
    --analysis-depth DEPTH
                          Analysis depth level (default: standard)
                          Values: shallow, standard, deep
                          
                          shallow:  summary only
                          standard: summary, components, architecture
                          deep:     all available analysis types
    
    --analysis-types TYPES
                          Comma-separated list of analysis types
                          Overrides the default types for the depth level
                          
                          Available types:
                            - summary        : High-level project overview
                            - components     : Key components and modules
                            - architecture   : System architecture and patterns
                            - dependencies   : External and internal dependencies
                            - relationships  : Component relationships and interactions
                            - quality        : Code quality and best practices
    
    -h, --help            Display this help message

EXAMPLES:
    # Analyze current repository with standard depth
    analyze.sh
    
    # Analyze a specific directory with deep analysis
    analyze.sh /path/to/project --analysis-depth deep
    
    # Analyze with specific types only
    analyze.sh --analysis-types summary,components
    
    # Combine directory and options
    analyze.sh ./src --analysis-depth deep

EOF
}

# ============================================================================
# Argument Parsing
# ============================================================================

# Initialize variables
ANALYSIS_INPUT_DIR=""
ANALYSIS_DEPTH="standard"
ANALYSIS_TYPES=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --analysis-depth)
            ANALYSIS_DEPTH="$2"
            shift 2
            ;;
        --analysis-types)
            ANALYSIS_TYPES="$2"
            shift 2
            ;;
        *)
            if [[ -z "$ANALYSIS_INPUT_DIR" ]]; then
                ANALYSIS_INPUT_DIR="$1"
            fi
            shift
            ;;
    esac
done

# ============================================================================
# Configuration and Validation
# ============================================================================

# Normalize depth and set default analysis types if not specified
ANALYSIS_DEPTH=$(normalize_analysis_depth "$ANALYSIS_DEPTH")

if [[ -z "$ANALYSIS_TYPES" ]]; then
    ANALYSIS_TYPES=$(get_analysis_types_for_depth "$ANALYSIS_DEPTH")
fi

# Validate ANALYSIS_INPUT_DIR
if [[ -z "$ANALYSIS_INPUT_DIR" ]]; then
    print_error "ANALYSIS_INPUT_DIR is not set"
    print_error "Please provide a valid directory path"
    show_help
    exit 1
fi

if ! validate_analysis_input_dir "$ANALYSIS_INPUT_DIR"; then
    exit 1
fi

# ============================================================================
# Main Analysis Function
# ============================================================================

analyze_project() {
    local feature_dir=$(get_feature_dir)
    local feature_context_file=$(get_feature_context_file)
    if [[ "$feature_dir" == "" ]]; then
        local analysis_output_dir=$ANALYSIS_INPUT_DIR/analyzed
    else
        local analysis_output_dir="$feature_dir/analyzed"
    fi

    # Copy template files based on analysis types
    if ! copy_analysis_templates "$analysis_output_dir" "$ANALYSIS_TYPES"; then
        print_error "Failed to copy analysis templates"
        return 1
    fi
    
    # Echo key variables in the same format as specify.sh
    echo "ANALYSIS_INPUT_DIR: $ANALYSIS_INPUT_DIR"
    echo "ANALYSIS_OUTPUT_DIR: $analysis_output_dir"
    echo "ANALYSIS_OUTPUT_ROOT: $analysis_output_dir/README.md"
    echo "ANALYSIS_DEPTH: $ANALYSIS_DEPTH"
    echo "ANALYSIS_TYPES: $ANALYSIS_TYPES"
    echo "FEATURE_DIR: $feature_dir"
    echo "FEATURE_CONTEXT: $feature_context_file"
    return 0
}

# ============================================================================
# Script Execution
# ============================================================================

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    analyze_project
fi
