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

# Function to parse YAML config value (simple parser for basic values)
parse_yaml_value() {
    local config_file="$1"
    local key="$2"
    
    if [[ ! -f "$config_file" ]]; then
        echo ""
        return
    fi
    
    # Simple YAML parser that handles basic key-value pairs and arrays
    local value=""
    local in_array=false
    local array_key=""
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
            continue
        fi
        
        # Check if this is the key we're looking for
        if [[ "$line" =~ ^[[:space:]]*${key}:[[:space:]]*(.*)$ ]]; then
            value="${BASH_REMATCH[1]}"
            # If value is empty, might be an array
            if [[ -z "$value" ]]; then
                in_array=true
                array_key="$key"
            fi
            break
        fi
    done < "$config_file"
    
    # If we found an array, collect all items
    if [[ "$in_array" == true ]]; then
        local array_items=()
        local reading_array=false
        while IFS= read -r line; do
            # Start reading array items after the key
            if [[ "$line" =~ ^[[:space:]]*${array_key}:[[:space:]]*$ ]]; then
                reading_array=true
                continue
            fi
            
            # Stop if we hit a new top-level key
            if [[ "$reading_array" == true ]] && [[ "$line" =~ ^[[:space:]]*[a-zA-Z_]+:[[:space:]]*.*$ ]] && [[ ! "$line" =~ ^[[:space:]]*- ]]; then
                break
            fi
            
            # Collect array items
            if [[ "$reading_array" == true ]] && [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.+)$ ]]; then
                local item="${BASH_REMATCH[1]}"
                # Remove quotes if present
                item=$(echo "$item" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
                array_items+=("$item")
            fi
        done < "$config_file"
        
        # Join array items with newlines and proper YAML formatting
        if [[ ${#array_items[@]} -gt 0 ]]; then
            printf "%s\n" "${array_items[@]}"
            return
        fi
    fi
    
    echo "$value"
}

# Function to replace config variables in command file
replace_config_variables() {
    local cmd_file="$1"
    local config_file="$2"
    
    if [[ ! -f "$cmd_file" ]] || [[ ! -f "$config_file" ]]; then
        return
    fi
    
    # Create a temporary file for processing
    local temp_file="${cmd_file}.tmp"
    cp "$cmd_file" "$temp_file"
    
    # Map config.yaml keys to command frontmatter keys
    # SPECIFY_DIR -> SPECS_DIR
    local specs_dir=$(parse_yaml_value "$config_file" "SPECS_DIR")
    if [[ -n "$specs_dir" ]]; then
        sed -i.bak "s|SPECIFY_DIR: .*|SPECIFY_DIR: $specs_dir|g" "$temp_file"
        rm -f "${temp_file}.bak"
    fi
    
    # MAIN_BRANCH -> MAIN_BRANCH
    local main_branch=$(parse_yaml_value "$config_file" "MAIN_BRANCH")
    if [[ -n "$main_branch" ]]; then
        sed -i.bak "s|MAIN_BRANCH: .*|MAIN_BRANCH: $main_branch|g" "$temp_file"
        rm -f "${temp_file}.bak"
    fi
    
    # MERGE_TEMPLATE -> MERGE_TEMPLATE
    local merge_template=$(parse_yaml_value "$config_file" "MERGE_TEMPLATE")
    if [[ -n "$merge_template" ]]; then
        # Remove existing quotes if present
        merge_template=$(echo "$merge_template" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
        # Escape special characters for sed
        merge_template=$(echo "$merge_template" | sed 's/[&/\]/\\&/g')
        sed -i.bak "s|MERGE_TEMPLATE: .*|MERGE_TEMPLATE: \"$merge_template\"|g" "$temp_file"
        rm -f "${temp_file}.bak"
    fi
    
    # CONTEXTUAL_ROOT -> default value (not in config.yaml, but derived from contextual target)
    # This will be handled separately in the install process
    
    # ANALYZE_EXCLUDE_PATTERNS and ANALYZE_INCLUDE_PATTERNS are complex arrays
    # We'll handle them by replacing the entire array section in the frontmatter
    # For now, keep the default values from the command files
    
    # Move temp file to original
    mv "$temp_file" "$cmd_file"
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PROJECT_ROOT=""
AGENTS=("$DEFAULT_AGENT")  # Changed to array for multiagent support
AGENTS_SPECIFIED=false  # Track if --agent was explicitly specified
CONTEXTUAL_TARGET="$DEFAULT_CONTEXTUAL_ROOT"
INCLUDE_COMMANDS=""
ONLY_COMMANDS=false

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
    --agent AGENT          AI agent(s) to configure (default: cursor)
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
                          Multiple agents can be specified:
                            - Comma-separated: --agent cursor,claude
                            - Multiple flags: --agent cursor --agent claude
    --contextual-root PATH Contextual root directory (default: .contextual)
    --include COMMANDS     Comma-separated list of commands to include
                          Example: --include specify.md,implement.md,commit.md
    --only-commands        Copy commands directly to agent folder without
                          creating .contextual directory or symlinks
    --help                 Show this help message

EXAMPLES:
    $0 /path/to/project
    $0 /path/to/project --agent cursor
    $0 /path/to/project --agent cursor,claude --only-commands
    $0 /path/to/project --contextual-root .dev-tools
    $0 /path/to/project --include specify.md,implement.md,commit.md
    $0 /path/to/project --only-commands
    $0 /path/to/project --agent claude --only-commands --include specify.md,implement.md
EOF
}

# Function to validate arguments
validate_arguments() {
    if [[ -z "$PROJECT_ROOT" ]]; then
        print_error "Project root is required. Provide PROJECT_ROOT as first argument or --help for usage."
        exit 1
    fi
    
    # Validate agents
    for agent in "${AGENTS[@]}"; do
        local valid_agent=false
        for supported_agent in $SUPPORTED_AGENTS; do
            if [[ "$agent" == "$supported_agent" ]]; then
                valid_agent=true
                break
            fi
        done
        
        if [[ "$valid_agent" == "false" ]]; then
            print_error "Unsupported agent: $agent"
            print_error "Supported agents: $SUPPORTED_AGENTS"
            exit 1
        fi
    done
    
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

# Function to check if a command should be included
is_command_included() {
    local cmd_name="$1"
    local include_list="$2"
    
    if [[ -z "$include_list" ]]; then
        return 0  # Include all if no filter specified
    fi
    
    # Split include list by comma
    IFS=',' read -ra INCLUDED <<< "$include_list"
    for included_cmd in "${INCLUDED[@]}"; do
        # Trim whitespace
        included_cmd=$(echo "$included_cmd" | xargs)
        if [[ "$cmd_name" == "$included_cmd" ]]; then
            return 0  # Is included
        fi
    done
    
    return 1  # Not included
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
        mkdir -p "$target_dir/context"
        # Copy each file individually, preserving existing files
        for file in "$CONTEXTUAL_ROOT/context"/*; do
            if [[ -f "$file" ]]; then
                local filename="$(basename "$file")"
                if [[ ! -f "$target_dir/context/$filename" ]]; then
                    cp "$file" "$target_dir/context/$filename"
                fi
            fi
        done
        print_success "Context files copied"
    fi
    
    # Copy README.md if it exists and doesn't already exist in target
    if [[ -f "$CONTEXTUAL_ROOT/README.md" ]]; then
        if [[ ! -f "$target_dir/README.md" ]]; then
            print_info "Copying README.md..."
            cp "$CONTEXTUAL_ROOT/README.md" "$target_dir/"
            print_success "README.md copied"
        else
            print_info "README.md already exists (preserving)"
        fi
    fi
    
    # Copy config.yaml if it exists and doesn't already exist in target
    if [[ -f "$CONTEXTUAL_ROOT/config.yaml" ]]; then
        if [[ ! -f "$target_dir/config.yaml" ]]; then
            print_info "Copying config.yaml..."
            cp "$CONTEXTUAL_ROOT/config.yaml" "$target_dir/"
            print_success "config.yaml copied"
        else
            print_info "config.yaml already exists (preserving)"
        fi
    else
        print_warning "config.yaml not found in $CONTEXTUAL_ROOT"
    fi
}

# Function to install commands and create symlinks
install_agent_commands() {
    local project_dir="$1"
    local agent="$2"
    local contextual_target="$3"
    local include_commands="$4"
    
    local contextual_commands_dir="$project_dir/$contextual_target/commands"
    local config_file="$project_dir/$contextual_target/config.yaml"
    
    # Create .contextual/commands directory
    mkdir -p "$contextual_commands_dir"
    
    # Get the appropriate commands source (agent-specific or default)
    local commands_source="$(get_agent_commands_source "$agent")"
    
    # Copy command files to .contextual/commands (only including specified commands if filter is set)
    print_info "Installing command files to $contextual_commands_dir..."
    print_info "Source: $commands_source"
    if [[ -d "$commands_source" ]] && ls "$commands_source"/*.md 1> /dev/null 2>&1; then
        local installed_count=0
        local skipped_count=0
        for cmd_file in "$commands_source"/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name="$(basename "$cmd_file")"
                # Skip test commands
                if [[ "$cmd_name" =~ ^test ]]; then
                    print_info "Skipping test command: $cmd_name"
                    skipped_count=$((skipped_count + 1))
                    continue
                fi
                if is_command_included "$cmd_name" "$include_commands"; then
                    cp "$cmd_file" "$contextual_commands_dir/"
                    installed_count=$((installed_count + 1))
                else
                    print_info "Skipping command: $cmd_name"
                    skipped_count=$((skipped_count + 1))
                fi
            fi
        done
        if [[ $installed_count -gt 0 ]]; then
            print_success "Command files installed ($installed_count installed, $skipped_count skipped)"
        else
            print_warning "No command files installed (all skipped)"
            return 1
        fi
    else
        print_warning "No command files found in $commands_source"
        return 1
    fi
    
    # Replace config variables in command files
    print_info "Updating command files with project configuration..."
    if [[ -f "$config_file" ]]; then
        for cmd_file in "$contextual_commands_dir"/*.md; do
            if [[ -f "$cmd_file" ]]; then
                replace_config_variables "$cmd_file" "$config_file"
            fi
        done
        
        # Update CONTEXTUAL_ROOT in contextualize.md
        if [[ -f "$contextual_commands_dir/contextualize.md" ]]; then
            local contextual_root="$contextual_target/context"
            sed -i.bak "s|CONTEXTUAL_ROOT: .*|CONTEXTUAL_ROOT: $contextual_root|g" "$contextual_commands_dir/contextualize.md"
            rm -f "$contextual_commands_dir/contextualize.md.bak"
        fi
        
        print_success "Configuration variables updated"
    else
        print_warning "config.yaml not found, using default values in commands"
    fi
    
    # Get agent-specific folder from configuration
    local agent_folder="$(get_agent_folder "$agent")"
    
    if [[ -z "$agent_folder" ]]; then
        print_warning "Unknown agent: $agent. Commands installed but no symlinks created."
        return 1
    fi
    
    local agent_commands_dir="$project_dir/$agent_folder"
    
    # Create symlinks from agent folder to .contextual/commands
    print_info "Creating symlinks in $agent_folder..."
    if [[ -d "$agent_commands_dir" ]]; then
        for cmd_file in "$contextual_commands_dir"/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name="$(basename "$cmd_file")"
                local symlink_path="$agent_commands_dir/$cmd_name"
                local relative_target="../../$contextual_target/commands/$cmd_name"
                
                # Remove existing file or symlink if it exists
                if [[ -e "$symlink_path" ]] || [[ -L "$symlink_path" ]]; then
                    rm -f "$symlink_path"
                fi
                
                # Create symlink
                ln -s "$relative_target" "$symlink_path"
            fi
        done
        print_success "Symlinks created for $agent"
    else
        print_error "Agent commands directory not found: $agent_commands_dir"
        return 1
    fi
}

# Function to get agent-specific commands source directory
get_agent_commands_source() {
    local agent="$1"
    local contextual_root="$(cd "$SCRIPT_DIR/.." && pwd)"
    local agent_commands_dir="$contextual_root/.$agent/commands"
    
    # Check if agent-specific commands directory exists
    if [[ -d "$agent_commands_dir" ]] && ls "$agent_commands_dir"/*.md 1> /dev/null 2>&1; then
        echo "$agent_commands_dir"
        return 0
    fi
    
    # Fall back to default commands directory
    echo "$COMMANDS_SOURCE"
    return 0
}

# Function to install commands directly to agent folder (without .contextual)
install_commands_only() {
    local project_dir="$1"
    local agent="$2"
    local include_commands="$3"
    
    # Get agent-specific folder
    local agent_folder="$(get_agent_folder "$agent")"
    
    if [[ -z "$agent_folder" ]]; then
        print_error "Unknown agent: $agent. Cannot install commands."
        return 1
    fi
    
    local agent_commands_dir="$project_dir/$agent_folder"
    
    # Create agent commands directory if it doesn't exist
    print_info "Setting up $agent commands directory..."
    mkdir -p "$agent_commands_dir"
    print_success "Created $agent_folder directory"
    
    # Get the appropriate commands source (agent-specific or default)
    local commands_source="$(get_agent_commands_source "$agent")"
    
    # Copy command files directly to agent folder (only including specified commands if filter is set)
    print_info "Installing command files directly to $agent_folder..."
    print_info "Source: $commands_source"
    print_info "Note: Commands copied without config variable replacement"
    
    if [[ -d "$commands_source" ]] && ls "$commands_source"/*.md 1> /dev/null 2>&1; then
        local installed_count=0
        local skipped_count=0
        for cmd_file in "$commands_source"/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name="$(basename "$cmd_file")"
                # Skip test commands
                if [[ "$cmd_name" =~ ^test ]]; then
                    print_info "Skipping test command: $cmd_name"
                    skipped_count=$((skipped_count + 1))
                    continue
                fi
                if is_command_included "$cmd_name" "$include_commands"; then
                    local target_path="$agent_commands_dir/$cmd_name"
                    # Remove existing file or symlink if it exists
                    if [[ -e "$target_path" ]] || [[ -L "$target_path" ]]; then
                        rm -f "$target_path"
                    fi
                    cp "$cmd_file" "$agent_commands_dir/"
                    installed_count=$((installed_count + 1))
                else
                    print_info "Skipping command: $cmd_name"
                    skipped_count=$((skipped_count + 1))
                fi
            fi
        done
        if [[ $installed_count -gt 0 ]]; then
            print_success "Command files installed ($installed_count installed, $skipped_count skipped)"
        else
            print_warning "No command files installed (all skipped)"
            return 1
        fi
    else
        print_error "No command files found in $commands_source"
        return 1
    fi
    
    return 0
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
    local required_dirs=("context" "commands")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$target_dir/$dir" ]]; then
            print_error "Required directory missing: $target_dir/$dir"
            return 1
        fi
    done
    
    # Check for config file
    if [[ ! -f "$target_dir/config.yaml" ]]; then
        print_warning "config.yaml not found"
    fi
    
    # Check for command files
    if [[ ! -d "$target_dir/commands" ]] || ! ls "$target_dir/commands"/*.md 1> /dev/null 2>&1; then
        print_error "No command files found in $target_dir/commands"
        return 1
    fi
    
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
    local contextual_target="$2"
    local include_commands="$3"
    
    print_info "Starting contextual development tools installation..."
    print_info "Project directory: $project_dir"
    print_info "Agents: ${AGENTS[*]}"
    
    # Check if only commands mode is enabled
    if [[ "$ONLY_COMMANDS" == true ]]; then
        print_info "Mode: Direct copy (--only-commands)"
        if [[ -n "$include_commands" ]]; then
            print_info "Including only: $include_commands"
        fi
        
        # Create project directory
        create_project_directory "$project_dir"
        
        # Install commands directly to agent folders
        local success_count=0
        local total_agents=${#AGENTS[@]}
        
        for agent in "${AGENTS[@]}"; do
            print_info "Installing commands for agent: $agent"
            if install_commands_only "$project_dir" "$agent" "$include_commands"; then
                success_count=$((success_count + 1))
                local agent_folder="$(get_agent_folder "$agent")"
                if [[ -n "$agent_folder" ]]; then
                    print_success "$agent commands: $project_dir/$agent_folder"
                fi
            else
                print_error "Failed to install commands for agent: $agent"
            fi
        done
        
        if [[ $success_count -eq $total_agents ]]; then
            print_success "Installation completed successfully for all agents!"
            print_info "Commands installed directly to agent folders without .contextual setup."
        elif [[ $success_count -gt 0 ]]; then
            print_warning "Installation completed with some failures ($success_count/$total_agents agents succeeded)"
        else
            print_error "Installation failed for all agents. Please check the output above."
            exit 1
        fi
    else
        # Standard installation with .contextual directory
        print_info "Contextual target: $contextual_target"
        if [[ -n "$include_commands" ]]; then
            print_info "Including only: $include_commands"
        fi
        
        # Create project directory
        create_project_directory "$project_dir"
        
        # Setup agent-specific structures for all agents
        for agent in "${AGENTS[@]}"; do
            print_info "Setting up structure for agent: $agent"
            setup_agent_structure "$project_dir" "$agent"
        done
        
        # Copy contextual files (only once)
        copy_contextual_files "$project_dir" "$contextual_target"
        
        # Install commands and create symlinks for all agents
        local success_count=0
        local total_agents=${#AGENTS[@]}
        
        for agent in "${AGENTS[@]}"; do
            print_info "Installing commands for agent: $agent"
            if install_agent_commands "$project_dir" "$agent" "$contextual_target" "$include_commands"; then
                success_count=$((success_count + 1))
            else
                print_error "Failed to install commands for agent: $agent"
            fi
        done
        
        # Validate installation for all agents
        local validation_success=true
        for agent in "${AGENTS[@]}"; do
            if ! validate_installation "$project_dir" "$contextual_target" "$agent"; then
                validation_success=false
                print_error "Validation failed for agent: $agent"
            fi
        done
        
        if [[ $success_count -eq $total_agents ]] && [[ "$validation_success" == true ]]; then
            print_success "Installation completed successfully for all agents!"
            print_info "You can now use contextual development tools in your project."
            print_info ""
            print_info "Contextual directory: $project_dir/$contextual_target"
            
            print_info "Agent commands:"
            for agent in "${AGENTS[@]}"; do
                local agent_folder="$(get_agent_folder "$agent")"
                if [[ -n "$agent_folder" ]]; then
                    print_info "  $agent: $project_dir/$agent_folder"
                fi
            done
            
            print_info ""
            print_info "Configuration:"
            print_info "  Config file: $project_dir/$contextual_target/config.yaml"
            print_info "  Edit the config file to customize settings"
        elif [[ $success_count -gt 0 ]]; then
            print_warning "Installation completed with some failures ($success_count/$total_agents agents succeeded)"
        else
            print_error "Installation failed for all agents. Please check the output above."
            exit 1
        fi
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
            agent_value="${flag_args[1]}"
            # Clear default agents only on first --agent flag
            if [[ "$AGENTS_SPECIFIED" == false ]]; then
                AGENTS=()
                AGENTS_SPECIFIED=true
            fi
            # Check if comma-separated agents
            if [[ "$agent_value" == *","* ]]; then
                # Split by comma and add each agent
                IFS=',' read -ra AGENT_LIST <<< "$agent_value"
                for agent in "${AGENT_LIST[@]}"; do
                    # Trim whitespace
                    agent=$(echo "$agent" | xargs)
                    if [[ -n "$agent" ]]; then
                        AGENTS+=("$agent")
                    fi
                done
            else
                # Single agent
                AGENTS+=("$agent_value")
            fi
            flag_args=("${flag_args[@]:2}")
            ;;
        --contextual-root)
            CONTEXTUAL_TARGET="${flag_args[1]}"
            flag_args=("${flag_args[@]:2}")
            ;;
        --include)
            INCLUDE_COMMANDS="${flag_args[1]}"
            flag_args=("${flag_args[@]:2}")
            ;;
        --only-commands)
            ONLY_COMMANDS=true
            flag_args=("${flag_args[@]:1}")
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
    install_contextual "$PROJECT_ROOT" "$CONTEXTUAL_TARGET" "$INCLUDE_COMMANDS"
}

# Run main function
main "$@"
