#!/bin/bash

# scripts/dev/update-links.sh - Symlink commands for local development
# Creates symlinks from ./commands/* and ./tests/commands/* to .cursor/commands/

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MAIN_COMMANDS_DIR="$PROJECT_ROOT/commands"
TEST_COMMANDS_DIR="$PROJECT_ROOT/tests/commands"
CURSOR_COMMANDS_DIR="$PROJECT_ROOT/.cursor/commands"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_error() {
    echo -e "${RED}[update-links] ERROR:${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}[update-links] SUCCESS:${NC} $1"
}

print_info() {
    echo -e "${BLUE}[update-links] INFO:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[update-links] WARNING:${NC} $1"
}

# Function to create symlinks from a source directory
create_symlinks() {
    local source_dir="$1"
    local source_name="$2"
    
    # Check if source directory exists
    if [[ ! -d "$source_dir" ]]; then
        print_warning "$source_name directory not found: $source_dir" >&2
        echo "0 0"
        return 0
    fi
    
    # Find all markdown files in the source directory
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$source_dir" -maxdepth 1 -name "*.md" -type f -print0)
    
    if [[ ${#files[@]} -eq 0 ]]; then
        print_info "No .md files found in $source_name" >&2
        echo "0 0"
        return 0
    fi
    
    print_info "Found ${#files[@]} file(s) in $source_name" >&2
    
    # Create symlinks for each file
    local linked_count=0
    local skipped_count=0
    
    for file in "${files[@]}"; do
        local filename=$(basename "$file")
        local symlink_path="$CURSOR_COMMANDS_DIR/$filename"
        
        # Calculate relative path from .cursor/commands/ to the source file
        # Remove PROJECT_ROOT prefix and construct relative path
        local file_rel_to_root="${file#$PROJECT_ROOT/}"
        local relative_path="../../$file_rel_to_root"
        
        # Check if symlink already exists
        if [[ -L "$symlink_path" ]]; then
            # Check if it points to the correct location
            local current_target=$(readlink "$symlink_path")
            if [[ "$current_target" == "$relative_path" ]]; then
                print_info "Symlink already exists (correct): $filename" >&2
                ((skipped_count++))
                continue
            else
                print_warning "Symlink exists but points to wrong location: $filename" >&2
                print_info "  Current: $current_target" >&2
                print_info "  Expected: $relative_path" >&2
                print_info "  Removing and recreating..." >&2
                rm "$symlink_path"
            fi
        elif [[ -e "$symlink_path" ]]; then
            print_warning "File exists but is not a symlink: $filename" >&2
            print_info "  Skipping to avoid overwriting..." >&2
            ((skipped_count++))
            continue
        fi
        
        # Create symlink with relative path
        ln -s "$relative_path" "$symlink_path"
        print_success "Created symlink: $filename -> $relative_path" >&2
        ((linked_count++))
    done
    
    echo "$linked_count $skipped_count"
}

# Main function
main() {
    print_info "Linking commands for local development..."
    echo ""
    
    # Create .cursor/commands directory if it doesn't exist
    if [[ ! -d "$CURSOR_COMMANDS_DIR" ]]; then
        print_info "Creating directory: $CURSOR_COMMANDS_DIR"
        mkdir -p "$CURSOR_COMMANDS_DIR"
        echo ""
    fi
    
    # Total counters
    local total_linked=0
    local total_skipped=0
    
    # Link main commands
    print_info "Processing ./commands/*"
    local result=$(create_symlinks "$MAIN_COMMANDS_DIR" "Main commands")
    local linked=$(echo "$result" | awk '{print $1}')
    local skipped=$(echo "$result" | awk '{print $2}')
    total_linked=$((total_linked + linked))
    total_skipped=$((total_skipped + skipped))
    echo ""
    
    # Link test commands
    print_info "Processing ./tests/commands/*"
    result=$(create_symlinks "$TEST_COMMANDS_DIR" "Test commands")
    linked=$(echo "$result" | awk '{print $1}')
    skipped=$(echo "$result" | awk '{print $2}')
    total_linked=$((total_linked + linked))
    total_skipped=$((total_skipped + skipped))
    echo ""
    
    # Summary
    print_success "Link operation complete!"
    print_info "  Linked: $total_linked"
    print_info "  Skipped: $total_skipped"
    print_info "  Total: $((total_linked + total_skipped))"
    echo ""
    print_info "Commands are now available in Cursor at: $CURSOR_COMMANDS_DIR"
}

# Run main function
main "$@"

