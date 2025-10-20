#!/bin/bash

# scripts/autocomplete.sh - Shell completion for contextual CLI
# Provides bash/zsh autocompletion for contextual commands

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print functions
print_success() {
    echo -e "${GREEN}[contextual autocomplete] SUCCESS:${NC} $1"
}

print_info() {
    echo -e "${BLUE}[contextual autocomplete] INFO:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[contextual autocomplete] WARNING:${NC} $1"
}

# Generate bash completion script
generate_bash_completion() {
    cat << 'EOF'
# Bash completion for contextual CLI
_contextual_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Main commands
    local main_commands="install update dev autocomplete help version"
    
    # Dev subcommands
    local dev_subcommands="test update-links help"
    
    # Handle completion based on position
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        # Complete main commands
        COMPREPLY=( $(compgen -W "${main_commands}" -- "${cur}") )
        return 0
    fi
    
    # Handle subcommands for 'dev'
    if [[ ${COMP_CWORD} -eq 2 && "${COMP_WORDS[1]}" == "dev" ]]; then
        COMPREPLY=( $(compgen -W "${dev_subcommands}" -- "${cur}") )
        return 0
    fi
    
    # Handle options
    case "${prev}" in
        install|update)
            # Complete with directories
            COMPREPLY=( $(compgen -d -- "${cur}") )
            return 0
            ;;
        test)
            # Complete with test options (when test is a dev subcommand)
            local test_opts="--verbose --list --cleanup --help"
            COMPREPLY=( $(compgen -W "${test_opts}" -- "${cur}") )
            return 0
            ;;
    esac
    
    return 0
}

# Register completion function
complete -F _contextual_completions contextual
EOF
}

# Generate zsh completion script
generate_zsh_completion() {
    cat << 'EOF'
#compdef contextual

# Zsh completion for contextual CLI
_contextual() {
    local -a main_commands dev_subcommands
    
    main_commands=(
        'install:Install contextual development tools into a project'
        'update:Update contextual development tools in a project'
        'dev:Development utilities'
        'autocomplete:Install shell completion'
        'help:Show help message'
        'version:Show version information'
    )
    
    dev_subcommands=(
        'test:Run all tests for contextual development tools'
        'update-links:Symlink commands from ./commands/* and ./tests/commands/ to .cursor/commands/'
        'help:Show dev help message'
    )
    
    # Handle completion based on context
    if (( CURRENT == 2 )); then
        # Complete main commands
        _describe 'command' main_commands
    elif (( CURRENT == 3 )); then
        case "${words[2]}" in
            dev)
                _describe 'subcommand' dev_subcommands
                ;;
            install|update)
                _directories
                ;;
        esac
    elif (( CURRENT == 4 )); then
        # Handle options for dev subcommands
        case "${words[2]}" in
            dev)
                case "${words[3]}" in
                    test)
                        _arguments \
                            '--verbose[Enable verbose output]' \
                            '--list[List available tests]' \
                            '--cleanup[Clean up test artifacts]' \
                            '--help[Show help message]'
                        ;;
                esac
                ;;
        esac
    fi
}

_contextual "$@"
EOF
}

# Show help
show_help() {
    cat << EOF
Contextual Autocomplete - Shell Completion Setup

USAGE:
    contextual autocomplete [shell]

ARGUMENTS:
    shell    Shell type (bash, zsh, or fish). Auto-detected if not provided.

EXAMPLES:
    contextual autocomplete          # Auto-detect shell
    contextual autocomplete bash     # Install bash completion
    contextual autocomplete zsh      # Install zsh completion

DESCRIPTION:
    This command installs shell completion for the contextual CLI.
    
    For bash:
        Completion will be added to ~/.bash_completion or ~/.bashrc
    
    For zsh:
        Completion will be added to ~/.zshrc
    
    After installation, restart your shell or source the rc file:
        source ~/.bashrc    # bash
        source ~/.zshrc     # zsh

MANUAL INSTALLATION:
    You can also manually add completion by running:
        eval "\$(contextual autocomplete bash)"   # For bash
        eval "\$(contextual autocomplete zsh)"    # For zsh

EOF
}

# Install completion for a specific shell
install_completion() {
    local shell_type="$1"
    local completion_script=""
    local rc_file=""
    
    case "$shell_type" in
        bash)
            rc_file="$HOME/.bashrc"
            completion_script=$(generate_bash_completion)
            
            # Check if bash_completion exists
            if [[ -f "$HOME/.bash_completion" ]]; then
                rc_file="$HOME/.bash_completion"
            fi
            ;;
        zsh)
            rc_file="$HOME/.zshrc"
            completion_script=$(generate_zsh_completion)
            ;;
        *)
            echo "Error: Unsupported shell type: $shell_type"
            echo "Supported shells: bash, zsh"
            return 1
            ;;
    esac
    
    # Check if completion is already installed
    if grep -q "# Bash completion for contextual CLI" "$rc_file" 2>/dev/null || \
       grep -q "#compdef contextual" "$rc_file" 2>/dev/null; then
        print_warning "Completion already installed in $rc_file"
        print_info "To reinstall, remove the existing completion block and run again"
        return 0
    fi
    
    # Add completion to rc file
    print_info "Installing $shell_type completion to $rc_file..."
    
    {
        echo ""
        echo "# Contextual CLI completion (added by contextual autocomplete)"
        echo "$completion_script"
    } >> "$rc_file"
    
    print_success "Completion installed to $rc_file"
    print_info "Restart your shell or run: source $rc_file"
}

# Detect current shell
detect_shell() {
    if [[ -n "${BASH_VERSION:-}" ]]; then
        echo "bash"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        echo "zsh"
    else
        # Try to detect from SHELL environment variable
        case "$SHELL" in
            */bash)
                echo "bash"
                ;;
            */zsh)
                echo "zsh"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    fi
}

# Main function
main() {
    # Show help if requested
    if [[ $# -gt 0 && ("$1" == "help" || "$1" == "--help" || "$1" == "-h") ]]; then
        show_help
        exit 0
    fi
    
    # Determine shell type
    local shell_type=""
    if [[ $# -eq 0 ]]; then
        # Auto-detect shell
        shell_type=$(detect_shell)
        if [[ "$shell_type" == "unknown" ]]; then
            echo "Error: Could not detect shell type"
            echo "Please specify shell type: contextual autocomplete [bash|zsh]"
            exit 1
        fi
        print_info "Detected shell: $shell_type"
    else
        shell_type="$1"
    fi
    
    # If only generating completion script (for eval)
    if [[ "${CONTEXTUAL_AUTOCOMPLETE_GENERATE:-}" == "1" ]]; then
        case "$shell_type" in
            bash)
                generate_bash_completion
                ;;
            zsh)
                generate_zsh_completion
                ;;
            *)
                echo "Error: Unsupported shell: $shell_type" >&2
                exit 1
                ;;
        esac
        exit 0
    fi
    
    # Install completion
    install_completion "$shell_type"
}

# Run main function
main "$@"

