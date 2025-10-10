#!/bin/bash

# folder-analyzer - A tool to analyze folder structure and generate markdown reports
# Usage: folder-analyzer --input <directory> [--output <file>] [--depth <n>] [--skip-dotfiles] [--help]

set -euo pipefail

# Default values
INPUT_DIR=""
OUTPUT_FILE=""
MAX_DEPTH=10
SKIP_DOTFILES=false
SHOW_HELP=false
ROOT_DIR=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    cat << EOF
folder-analyzer - Generate markdown reports of folder structures

USAGE:
    folder-analyzer --input <directory> [OPTIONS]

REQUIRED ARGUMENTS:
    --input <directory>    Target directory to analyze

OPTIONAL ARGUMENTS:
    --output <file>        Output file path for markdown report (default: stdout)
    --depth <n>            Maximum traversal depth (default: 10)
    --skip-dotfiles        Skip all dotfiles and dotdirs (files/directories starting with ".")
    --root <directory>     Root directory for relative paths (default: parent of input directory)
    --help                 Show this help message

EXAMPLES:
    folder-analyzer --input ./my-project
    folder-analyzer --input ./my-project --output report.md
    folder-analyzer --input ./my-project --depth 5 --skip-dotfiles
    folder-analyzer --input ./my-project --output report.md --skip-dotfiles
    folder-analyzer --input ./my-project --root /home/user --output report.md

EOF
}

# Function to log messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

# Function to convert absolute path to relative path
get_relative_path() {
    local target_path="$1"
    local root_path="$2"
    
    # If root is not set, use input directory
    if [[ -z "$root_path" ]]; then
        root_path="$INPUT_DIR"
    fi
    
    # Convert both to absolute paths
    local abs_target=$(realpath "$target_path")
    local abs_root=$(realpath "$root_path")
    
    # Use relative path if target is under root, otherwise use absolute
    if [[ "$abs_target" == "$abs_root"* ]]; then
        # Calculate relative path
        local rel_path="${abs_target#$abs_root/}"
        if [[ "$rel_path" == "$abs_target" ]]; then
            # Target is the root itself
            echo "."
        else
            echo "$rel_path"
        fi
    else
        # Target is not under root, use absolute path
        echo "$abs_target"
    fi
}

# Function to check if a file/directory should be skipped
should_skip() {
    local item="$1"
    local basename=$(basename "$item")
    
    if [[ "$SKIP_DOTFILES" == "true" && "$basename" =~ ^\..* ]]; then
        return 0
    fi
    return 1
}

# Function to get file description
get_file_description() {
    echo "FILE DESCRIPTION"
}

# Function to get folder description
get_folder_description() {
    echo "FOLDER DESCRIPTION"
}

# Function to analyze directory structure
analyze_directory() {
    local dir="$1"
    local current_depth="$2"
    local indent="$3"
    
    # Check if we've exceeded max depth
    if [[ $current_depth -gt $MAX_DEPTH ]]; then
        return 0
    fi
    
    # Check if directory should be skipped
    if should_skip "$dir"; then
        return 0
    fi
    
    # Get directory description
    local dir_desc=$(get_folder_description "$dir")
    local dir_name=$(basename "$dir")
    local rel_path=$(get_relative_path "$dir" "$ROOT_DIR")
    
    # Output directory entry
    echo "${indent}- [${dir_name}/](${rel_path}) \`${dir_desc}\`"
    
    # Create new indent for sub-items
    local new_indent="${indent}    "
    
    # Process files first, then directories
    local files=()
    local dirs=()
    
    # Read directory contents
    while IFS= read -r -d '' item; do
        if should_skip "$item"; then
            continue
        fi
        
        if [[ -f "$item" ]]; then
            files+=("$item")
        elif [[ -d "$item" ]]; then
            dirs+=("$item")
        fi
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -print0 2>/dev/null | sort -z)
    
    # Output files
    if [[ ${#files[@]} -gt 0 ]]; then
        for file in "${files[@]}"; do
            local file_desc=$(get_file_description "$file")
            local file_name=$(basename "$file")
            local rel_path=$(get_relative_path "$file" "$ROOT_DIR")
            echo "${new_indent}- [${file_name}](${rel_path}) \`${file_desc}\`"
        done
    fi
    
    # Recursively process directories
    if [[ ${#dirs[@]} -gt 0 ]]; then
        for subdir in "${dirs[@]}"; do
            analyze_directory "$subdir" $((current_depth + 1)) "$new_indent"
        done
    fi
}

# Function to generate the markdown report
generate_report() {
    local input_dir="$1"
    
    # Get current timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Count total files and directories
    local total_files=0
    local total_dirs=0
    
    if [[ "$SKIP_DOTFILES" == "true" ]]; then
        total_files=$(find "$input_dir" -type f ! -path '*/.*' | wc -l)
        total_dirs=$(find "$input_dir" -type d ! -path '*/.*' | wc -l)
    else
        total_files=$(find "$input_dir" -type f | wc -l)
        total_dirs=$(find "$input_dir" -type d | wc -l)
    fi
    
    # Generate metadata header
    cat << EOF
---
generate: ${timestamp}
total_files: ${total_files}
total_directories: ${total_dirs}
---
# Folder Analysis

\`SUMMARY DESCRIPTION\`

EOF
    
    # Analyze the directory structure
    analyze_directory "$input_dir" 0 ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --input)
            INPUT_DIR="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --depth)
            MAX_DEPTH="$2"
            shift 2
            ;;
        --skip-dotfiles)
            SKIP_DOTFILES=true
            shift
            ;;
        --root)
            ROOT_DIR="$2"
            shift 2
            ;;
        --help)
            SHOW_HELP=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Show help if requested
if [[ "$SHOW_HELP" == "true" ]]; then
    show_help
    exit 0
fi

# Validate required arguments
if [[ -z "$INPUT_DIR" ]]; then
    log_error "Missing required argument: --input"
    show_help
    exit 1
fi

# Validate input directory
if [[ ! -d "$INPUT_DIR" ]]; then
    log_error "Input directory does not exist: $INPUT_DIR"
    exit 1
fi

# Convert to absolute path first
INPUT_DIR=$(realpath "$INPUT_DIR")

# Set root directory to parent of input directory if not provided
if [[ -z "$ROOT_DIR" ]]; then
    ROOT_DIR=$(basename "$INPUT_DIR")
fi

# Convert root directory to absolute path
ROOT_DIR=$(realpath "$ROOT_DIR")

# Validate root directory
if [[ ! -d "$ROOT_DIR" ]]; then
    log_error "Root directory does not exist: $ROOT_DIR"
    exit 1
fi

# Validate depth parameter
if ! [[ "$MAX_DEPTH" =~ ^[0-9]+$ ]] || [[ "$MAX_DEPTH" -lt 0 ]]; then
    log_error "Depth must be a non-negative integer: $MAX_DEPTH"
    exit 1
fi

log "Analyzing directory: $INPUT_DIR"
log "Root directory for relative paths: $ROOT_DIR"
log "Max depth: $MAX_DEPTH"
log "Skip dotfiles: $SKIP_DOTFILES"

# Generate and output the report
if [[ -n "$OUTPUT_FILE" ]]; then
    log "Writing report to: $OUTPUT_FILE"
    generate_report "$INPUT_DIR" > "$OUTPUT_FILE"
    log "Report generated successfully!"
else
    generate_report "$INPUT_DIR"
fi
