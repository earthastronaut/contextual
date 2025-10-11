#!/bin/bash

# Print utilities for spec-driven development
# Usage: source .contextual/scripts/bash/utils/print-utils.sh

# No colors - using default terminal colors

# Function to print header
print_header() {
    local title="$1"
    echo "================================="
    echo "  $title"
    echo "================================="
}

# Function to print success message
print_success() {
    echo "✓ $1"
}

# Function to print error message
print_error() {
    echo "✗ $1"
}

# Function to print warning message
print_warning() {
    echo "⚠ $1"
}

# Function to print info message
print_info() {
    echo "ℹ $1"
}

# Export functions for use in other scripts
export -f print_header
export -f print_success
export -f print_error
export -f print_warning
export -f print_info
