#!/bin/bash

# Main entry point for spec-driven development
# Usage: .specify/scripts/bash/specify-dev.sh <command> [args...]

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities
source "$SCRIPT_DIR/common.sh"

# Function to show usage
show_usage() {
    echo "Spec-Driven Development Tool"
    echo ""
    echo "Usage: $0 <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  specify <feature-name>  - Create new feature specification"
    echo "  implement              - Implement current feature"
    echo "  status                 - Show current status"
    echo "  list                   - List all features"
    echo "  validate               - Validate current setup"
    echo "  help                   - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 specify \"User Authentication\""
    echo "  $0 implement"
    echo "  $0 status"
    echo "  $0 list"
}

# Main command dispatcher
main() {
    local command="$1"
    
    case "$command" in
        "specify")
        if [[ $# -lt 2 ]]; then
            echo "Error: Feature name is required"
            echo "Usage: $0 specify \"Feature Name\""
            exit 1
        fi
            shift
            source "$SCRIPT_DIR/specify.sh"
            specify_feature "$*"
            ;;
        "implement")
            source "$SCRIPT_DIR/implement.sh"
            implement_feature
            ;;
        "status")
            show_status
            ;;
        "list")
            list_features
            ;;
        "validate")
            validate_setup
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        "")
            show_usage
            ;;
        *)
            echo "Error: Unknown command: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
