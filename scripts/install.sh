#!/bin/bash

# install.sh - Contextual Development Tools Installer
# Installs contextual development tools into a project directory

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTEXTUAL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)/.contextual"
COMMANDS_SOURCE="$(cd "$SCRIPT_DIR/.." && pwd)/commands"
DEFAULT_AGENT="cursor"
DEFAULT_CONTEXTUAL_ROOT=".contextual"

# Supported agents (space-separated for compatibility with bash 3.2)
SUPPORTED_AGENTS="copilot claude gemini cursor qwen opencode codex windsurf kilocode auggie codebuddy roo q"

# Function to get agent folder path
get_agent_folder() {
    local agent="$1"
    case "$agent" in
        "copilot") echo ".github/copilot/commands" ;;
        "claude") echo ".claude/commands" ;;
        "gemini") echo ".gemini/commands" ;;
        "cursor") echo ".cursor/commands" ;;
        "qwen") echo ".qwen/commands" ;;
        "opencode") echo ".opencode/commands" ;;
        "codex") echo ".codex/commands" ;;
        "windsurf") echo ".windsurf/commands" ;;
        "kilocode") echo ".kilocode/commands" ;;
        "auggie") echo ".augment/commands" ;;
        "codebuddy") echo ".codebuddy/commands" ;;
        "roo") echo ".roo/commands" ;;
        "q") echo ".amazonq/commands" ;;
        *) echo "" ;;
    esac
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PROJECT_ROOT=""
AGENT="$DEFAULT_AGENT"
CONTEXTUAL_TARGET="$DEFAULT_CONTEXTUAL_ROOT"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [PROJECT_ROOT] [OPTIONS]

Install contextual development tools into a project directory.

ARGUMENTS:
    PROJECT_ROOT            Target project directory (optional)

OPTIONS:
    --agent AGENT          AI agent to configure (default: cursor)
                          Supported agents:
                            - cursor      (Cursor IDE)
                            - claude      (Claude Code)
                            - gemini      (Gemini CLI)
                            - copilot     (GitHub Copilot)
                            - qwen        (Qwen Code)
                            - opencode    (OpenCode)
                            - codex       (Codex CLI)
                            - windsurf    (Windsurf IDE)
                            - kilocode    (Kilo Code IDE)
                            - auggie      (Auggie CLI)
                            - codebuddy   (CodeBuddy)
                            - roo         (Roo Code IDE)
                            - q           (Amazon Q Developer CLI)
    --contextual-root PATH Contextual root directory (default: .contextual)
    --help                 Show this help message

EXAMPLES:
    $0 /path/to/project
    $0 /path/to/project --agent cursor
    $0 /path/to/project --agent claude
    $0 /path/to/project --contextual-root .dev-tools

EOF
}

# Function to validate arguments
validate_arguments() {
    if [[ -z "$PROJECT_ROOT" ]]; then
        print_error "Project root is required. Provide PROJECT_ROOT as first argument or --help for usage."
        exit 1
    fi
    
    # Validate agent
    local valid_agent=false
    for supported_agent in $SUPPORTED_AGENTS; do
        if [[ "$AGENT" == "$supported_agent" ]]; then
            valid_agent=true
            break
        fi
    done
    
    if [[ "$valid_agent" == "false" ]]; then
        print_error "Unsupported agent: $AGENT"
        print_error "Supported agents: $SUPPORTED_AGENTS"
        exit 1
    fi
    
    # Note: PROJECT_ROOT directory will be created if it doesn't exist
    
    if [[ ! -d "$CONTEXTUAL_ROOT" ]]; then
        print_error "Contextual root directory not found: $CONTEXTUAL_ROOT"
        print_error "Make sure you're running this script from the contextual project root."
        exit 1
    fi
    
    # Validate commands source directory exists
    if [[ ! -d "$COMMANDS_SOURCE" ]]; then
        print_error "Commands source directory not found: $COMMANDS_SOURCE"
        print_error "Make sure the commands directory exists in the contextual project root."
        exit 1
    fi
}

# Function to prompt for project name if project root is empty
prompt_for_project_name() {
    if [[ -z "$PROJECT_ROOT" ]]; then
        echo -n "Enter project name: "
        read -r project_name
        if [[ -z "$project_name" ]]; then
            print_error "Project name cannot be empty."
            exit 1
        fi
        PROJECT_ROOT="$project_name"
    fi
}

# Function to create project directory if it doesn't exist
create_project_directory() {
    if [[ ! -d "$PROJECT_ROOT" ]]; then
        print_info "Creating project directory: $PROJECT_ROOT"
        mkdir -p "$PROJECT_ROOT"
        print_success "Project directory created: $PROJECT_ROOT"
    else
        print_info "Project directory already exists: $PROJECT_ROOT"
    fi
}

# Function to setup agent-specific folder structure
setup_agent_structure() {
    local project_dir="$1"
    local agent="$2"
    
    # Get agent-specific folder from configuration
    local agent_folder="$(get_agent_folder "$agent")"
    
    if [[ -z "$agent_folder" ]]; then
        print_warning "Unknown agent: $agent. Skipping agent-specific setup."
        return 1
    fi
    
    local commands_dir="$project_dir/$agent_folder"
    
    print_info "Setting up $agent agent structure..."
    
    if [[ ! -d "$commands_dir" ]]; then
        mkdir -p "$commands_dir"
        print_success "Created $agent_folder directory"
    else
        print_info "$agent_folder directory already exists"
    fi
}

# Function to copy contextual files with selective overwrite
copy_contextual_files() {
    local project_dir="$1"
    local contextual_target="$2"
    local target_dir="$project_dir/$contextual_target"
    
    print_info "Copying contextual files to: $target_dir"
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"
    
    # Copy context directory (preserve existing)
    if [[ -d "$CONTEXTUAL_ROOT/context" ]]; then
        print_info "Copying context files (preserving existing)..."
        if [[ -d "$target_dir/context" ]]; then
            # Merge context directories, preserving existing files
            cp -r "$CONTEXTUAL_ROOT/context"/* "$target_dir/context/" 2>/dev/null || true
        else
            cp -r "$CONTEXTUAL_ROOT/context" "$target_dir/"
        fi
        print_success "Context files copied"
    fi
    
    # Copy scripts directory (overwrite)
    if [[ -d "$CONTEXTUAL_ROOT/scripts" ]]; then
        print_info "Copying scripts directory (overwriting existing)..."
        cp -r "$CONTEXTUAL_ROOT/scripts" "$target_dir/"
        print_success "Scripts directory copied"
    fi
    
    # Copy templates directory (overwrite)
    if [[ -d "$CONTEXTUAL_ROOT/templates" ]]; then
        print_info "Copying templates directory (overwriting existing)..."
        cp -r "$CONTEXTUAL_ROOT/templates" "$target_dir/"
        print_success "Templates directory copied"
    fi
    
    # Copy README.md if it exists
    if [[ -f "$CONTEXTUAL_ROOT/README.md" ]]; then
        print_info "Copying README.md..."
        cp "$CONTEXTUAL_ROOT/README.md" "$target_dir/"
        print_success "README.md copied"
    fi
    
    # Copy config if it exists
    if [[ -f "$CONTEXTUAL_ROOT/config" ]]; then
        print_info "Copying config..."
        cp "$CONTEXTUAL_ROOT/config" "$target_dir/"
        print_success "config copied"
    fi
}

# Function to copy agent command files
copy_agent_commands() {
    local project_dir="$1"
    local agent="$2"
    
    # Get agent-specific folder from configuration
    local agent_folder="$(get_agent_folder "$agent")"
    
    if [[ -z "$agent_folder" ]]; then
        print_warning "Unknown agent: $agent. Skipping command copy."
        return 1
    fi
    
    local commands_dir="$project_dir/$agent_folder"
    
    if [[ -d "$commands_dir" ]]; then
        print_info "Copying $agent command files from $COMMANDS_SOURCE..."
        if [[ -d "$COMMANDS_SOURCE" ]] && ls "$COMMANDS_SOURCE"/*.md 1> /dev/null 2>&1; then
            cp "$COMMANDS_SOURCE"/*.md "$commands_dir/" 2>/dev/null || true
            print_success "$agent command files copied"
        else
            print_warning "No command files found in $COMMANDS_SOURCE"
        fi
    fi
}

# Function to validate installation
validate_installation() {
    local project_dir="$1"
    local contextual_target="$2"
    local agent="$3"
    
    print_info "Validating installation..."
    
    local target_dir="$project_dir/$contextual_target"
    
    # Check if contextual directory exists
    if [[ ! -d "$target_dir" ]]; then
        print_error "Contextual directory not found: $target_dir"
        return 1
    fi
    
    # Check for required subdirectories
    local required_dirs=("context" "scripts" "templates")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$target_dir/$dir" ]]; then
            print_error "Required directory missing: $target_dir/$dir"
            return 1
        fi
    done
    
    # Check agent-specific structure
    local agent_folder="$(get_agent_folder "$agent")"
    if [[ -n "$agent_folder" ]]; then
        if [[ ! -d "$project_dir/$agent_folder" ]]; then
            print_error "$agent commands directory not found: $project_dir/$agent_folder"
            return 1
        fi
    fi
    
    print_success "Installation validation passed"
    return 0
}

# Main installation function
install_contextual() {
    local project_dir="$1"
    local agent="$2"
    local contextual_target="$3"
    
    print_info "Starting contextual development tools installation..."
    print_info "Project directory: $project_dir"
    print_info "Agent: $agent"
    print_info "Contextual target: $contextual_target"
    
    # Create project directory
    create_project_directory "$project_dir"
    
    # Setup agent-specific structure
    setup_agent_structure "$project_dir" "$agent"
    
    # Copy contextual files
    copy_contextual_files "$project_dir" "$contextual_target"
    
    # Copy agent-specific command files
    copy_agent_commands "$project_dir" "$agent"
    
    # Validate installation
    if validate_installation "$project_dir" "$contextual_target" "$agent"; then
        print_success "Installation completed successfully!"
        print_info "You can now use contextual development tools in your project."
        print_info ""
        print_info "Contextual directory: $project_dir/$contextual_target"
        
        local agent_folder="$(get_agent_folder "$agent")"
        if [[ -n "$agent_folder" ]]; then
            print_info "$agent commands: $project_dir/$agent_folder"
        fi
        
        print_info ""
        print_info "Configuration:"
        print_info "  Config file: $project_dir/$contextual_target/config"
        print_info "  Edit the config file to customize settings"
    else
        print_error "Installation validation failed. Please check the output above."
        exit 1
    fi
}

# Handle positional arguments first
flag_args=()
if [[ $# -gt 0 ]]; then
    # Check if first argument is a flag
    if [[ "$1" =~ ^-- ]]; then
        # No positional arguments, process all as flags
        flag_args=("$@")
    else
        # First argument is positional (project root)
        PROJECT_ROOT="$1"
        shift
        # Check for additional positional arguments
        additional_positional=()
        while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
            additional_positional+=("$1")
            shift
        done
        if [[ ${#additional_positional[@]} -gt 0 ]]; then
            print_error "Multiple positional arguments provided. Only the first one will be used as project root."
            print_error "Additional arguments: ${additional_positional[*]}"
            exit 1
        fi
        # Remaining arguments are flags
        flag_args=("$@")
    fi
fi

# Parse flag arguments
while [[ ${#flag_args[@]} -gt 0 ]]; do
    case "${flag_args[0]}" in
        --agent)
            AGENT="${flag_args[1]}"
            flag_args=("${flag_args[@]:2}")
            ;;
        --contextual-root)
            CONTEXTUAL_TARGET="${flag_args[1]}"
            flag_args=("${flag_args[@]:2}")
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: ${flag_args[0]}"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_info "Contextual Development Tools Installer"
    print_info "======================================"
    
    # Prompt for project name if not provided
    prompt_for_project_name
    
    # Validate arguments
    validate_arguments
    
    # Convert to absolute path
    if [[ "$PROJECT_ROOT" = /* ]]; then
        # Already absolute path
        PROJECT_ROOT="$(cd "$PROJECT_ROOT" 2>/dev/null && pwd || echo "$PROJECT_ROOT")"
    else
        # Relative path, make it absolute
        PROJECT_ROOT="$(pwd)/$PROJECT_ROOT"
    fi
    
    # Run installation
    install_contextual "$PROJECT_ROOT" "$AGENT" "$CONTEXTUAL_TARGET"
}

# Run main function
main "$@"
