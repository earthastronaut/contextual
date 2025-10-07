#!/bin/bash

# Common utilities and configuration for spec-driven development
# Usage: source .specify/scripts/bash/common.sh

# No colors - using default terminal colors

# Configuration
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

# Function to check if git repository is initialized
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        return 1
    fi
    return 0
}

# Function to check if we're in the project root
check_project_root() {
    if [[ ! -d "$SPECIFY_ROOT" ]]; then
        print_error "Not in project root. Expected .specify directory."
        return 1
    fi
    return 0
}

# Function to validate environment
validate_environment() {
    print_info "Validating environment..."
    
    if ! check_git_repo; then
        return 1
    fi
    
    if ! check_project_root; then
        return 1
    fi
    
    print_success "Environment validation passed"
    return 0
}

# Function to get project information
get_project_info() {
    echo "Project Information:"
    echo "  Root: $(pwd)"
    echo "  Git Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
    echo "  Git Status: $(git status --porcelain | wc -l) files changed"
    echo "  Specs Directory: $SPECS_DIR"
    echo "  Context Directory: $CONTEXT_DIR"
    echo "  Context Files: $(echo "$CONTEXT" | wc -l) files"
}

# Function to show help
show_help() {
    print_header "Spec-Driven Development Help"
    echo ""
    echo "Available Commands:"
    echo "  specify <feature-name>  - Create new feature specification"
    echo "  implement              - Implement current feature"
    echo "  status                 - Show current status"
    echo "  list-features          - List all features"
    echo "  validate               - Validate current setup"
    echo ""
    echo "Available Scripts:"
    echo "  $SCRIPTS_DIR/specify.sh     - Specify command"
    echo "  $SCRIPTS_DIR/implement.sh   - Implement command"
    echo "  $SCRIPTS_DIR/branch-utils.sh - Branch management"
    echo "  $SCRIPTS_DIR/file-utils.sh  - File discovery"
    echo ""
    echo "Usage Examples:"
    echo "  source $SCRIPTS_DIR/common.sh"
    echo "  specify \"User Authentication\""
    echo "  implement"
    echo "  status"
}

# Function to show current status
show_status() {
    print_header "Current Status"
    
    get_project_info
    echo ""
    
    # Check if we're on a feature branch
    local current_branch=$(git branch --show-current 2>/dev/null)
    if [[ $current_branch == feature/* ]]; then
        print_info "On feature branch: $current_branch"
        
        # Load branch utils to get feature info
        source "$SCRIPTS_DIR/branch-utils.sh"
        local feature_name=$(get_current_feature_display_name)
        local context_file=$(get_context_file)
        
        if [[ -n "$feature_name" ]]; then
            echo "  Feature: $feature_name"
        fi
        
        if [[ -n "$context_file" && -f "$context_file" ]]; then
            echo "  Context: $context_file"
            local line_count=$(wc -l < "$context_file")
            echo "  Context lines: $line_count"
        else
            print_warning "No context file found"
        fi
    else
        print_info "Not on a feature branch"
    fi
    
    echo ""
    
    # Show available features
    if [[ -d "$SPECS_DIR" ]]; then
        local feature_count=$(find "$SPECS_DIR" -name "context.md" | wc -l)
        echo -e "${CYAN}Available Features: $feature_count${NC}"
        find "$SPECS_DIR" -name "context.md" | while read -r context_file; do
            local feature_dir=$(dirname "$context_file")
            local feature_name=$(basename "$feature_dir")
            echo "  - $feature_name"
        done
    else
        print_info "No specs directory found"
    fi
}

# Function to list all features
list_features() {
    print_header "Available Features"
    
    if [[ ! -d "$SPECS_DIR" ]]; then
        print_info "No specs directory found"
        return 0
    fi
    
    find "$SPECS_DIR" -name "context.md" | while read -r context_file; do
        local feature_dir=$(dirname "$context_file")
        local feature_name=$(basename "$feature_dir")
        local display_name=$(grep "^# Feature:" "$context_file" | sed 's/^# Feature: *//' | head -1)
        
        echo -e "${GREEN}$feature_name${NC}"
        if [[ -n "$display_name" ]]; then
            echo "  Display: $display_name"
        fi
        echo "  Context: $context_file"
        echo ""
    done
}

# Function to validate current setup
validate_setup() {
    print_header "Validating Setup"
    
    if ! validate_environment; then
        return 1
    fi
    
    # Load branch utils
    source "$SCRIPTS_DIR/branch-utils.sh"
    
    # Check if we're on a feature branch
    if is_feature_branch; then
        print_info "On feature branch"
        if validate_feature_setup; then
            print_success "Feature setup is valid"
        else
            print_error "Feature setup is invalid"
            return 1
        fi
    else
        print_info "Not on a feature branch"
    fi
    
    print_success "Setup validation completed"
    return 0
}

# Export functions and variables
export SPECIFY_ROOT
export CONTEXT_DIR
export SCRIPTS_DIR
export SPECS_DIR
export CONTEXT
export -f print_header
export -f print_success
export -f print_error
export -f print_warning
export -f print_info
export -f check_git_repo
export -f check_project_root
export -f validate_environment
export -f get_project_info
export -f show_help
export -f show_status
export -f list_features
export -f validate_setup
export -f get_context_files
export -f refresh_context

# Auto-load other utilities if they exist
if [[ -f "$SCRIPTS_DIR/branch-utils.sh" ]]; then
    source "$SCRIPTS_DIR/branch-utils.sh"
fi

if [[ -f "$SCRIPTS_DIR/file-utils.sh" ]]; then
    source "$SCRIPTS_DIR/file-utils.sh"
fi

print_success "Common utilities loaded"
