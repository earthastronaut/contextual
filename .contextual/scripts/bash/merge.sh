#!/bin/bash

# Merge script implementation
# Executes git merge operations with provided commit message

# Source utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config-utils.sh"
source "$SCRIPT_DIR/utils/print-utils.sh"

# Default values
MAIN_BRANCH="main"
COMMIT_MESSAGE=""

# Function to show help
show_merge_help() {
    print_header "Merge Script Help"
    echo ""
    echo "Usage: merge.sh --message \"COMMIT_MESSAGE\""
    echo ""
    echo "Purpose: Executes git merge operations"
    echo ""
    echo "Parameters:"
    echo "  --message    Commit message for the merge (required)"
    echo ""
    echo "What it does:"
    echo "  1. Checks out main branch"
    echo "  2. Performs squash merge with feature branch"
    echo "  3. Commits with provided message"
    echo ""
    echo "Example:"
    echo "  merge.sh --message \"Merge feature/0003-merge-command: merge-command\""
}

# Function to parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --message)
                COMMIT_MESSAGE="$2"
                shift 2
                ;;
            -h|--help|help)
                show_merge_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_merge_help
                exit 1
                ;;
        esac
    done
}

# Function to validate environment
validate_environment() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        return 1
    fi
    
    # Check if commit message is provided
    if [[ -z "$COMMIT_MESSAGE" ]]; then
        print_error "Commit message is required. Use --message parameter."
        return 1
    fi
    
    return 0
}

# Function to execute merge
execute_merge() {
    # Get current feature branch
    local feature_branch=$(git branch --show-current)
    
    # Use provided commit message or create default
    local commit_message="$COMMIT_MESSAGE"
    if [[ -z "$commit_message" ]]; then
        commit_message="Merge $feature_branch: feature implementation"
    fi

    print_info "Starting merge process..."
    print_info "  Feature Branch: $feature_branch"
    print_info "  Main Branch: $MAIN_BRANCH"
    print_info "  Commit Message: $commit_message"

    # Checkout main branch
    if ! git checkout "$MAIN_BRANCH"; then
        print_error "Failed to checkout main branch: $MAIN_BRANCH"
        return 1
    fi
    
    # Perform squash merge
    if ! git merge --squash "$feature_branch"; then
        print_error "Merge conflicts detected. Aborting merge."
        print_error "Please resolve conflicts manually and try again."
        return 1
    fi
    
    # Commit with provided message
    if ! git commit -m "$commit_message"; then
        print_error "Failed to commit changes"
        return 1
    fi
    
    print_success "Feature branch $feature_branch has been merged into $MAIN_BRANCH!"
    return 0
}

# Main function
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Validate environment
    if ! validate_environment; then
        exit 1
    fi
    
    # Execute merge
    if ! execute_merge; then
        exit 1
    fi
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
