#!/bin/bash

# Test: Install Script Functionality
# Tests the install.sh script for basic functionality including new project installation,
# existing project updates, custom contextual roots, and error handling.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_SCRIPT="$PROJECT_ROOT/install.sh"
TEST_DIR="$PROJECT_ROOT/test-scenarios"

echo "Testing install.sh script..."

# Test 1: Help functionality
echo "Test 1: Help functionality"
if bash "$INSTALL_SCRIPT" --help 2>/dev/null | grep -q "Usage:"; then
    echo "✓ Help test passed"
else
    echo "✗ Help test failed"
    exit 1
fi

# Test 2: New project installation
echo "Test 2: New project installation"
TEST_PROJECT="$TEST_DIR/simple-test-project"
rm -rf "$TEST_PROJECT" 2>/dev/null || true

if bash "$INSTALL_SCRIPT" --project-root "$TEST_PROJECT" >/dev/null 2>&1; then
    echo "✓ Installation completed"
    
    # Check directory structure
    if [[ -d "$TEST_PROJECT/.contextual" ]]; then
        echo "✓ .contextual directory exists"
    else
        echo "✗ .contextual directory missing"
        exit 1
    fi
    
    if [[ -d "$TEST_PROJECT/.cursor/commands" ]]; then
        echo "✓ .cursor/commands directory exists"
    else
        echo "✗ .cursor/commands directory missing"
        exit 1
    fi
    
    if [[ -f "$TEST_PROJECT/.contextual/README.md" ]]; then
        echo "✓ README.md exists"
    else
        echo "✗ README.md missing"
        exit 1
    fi
    
    echo "✓ New project test passed"
else
    echo "✗ New project test failed"
    exit 1
fi

# Test 3: Existing project update
echo "Test 3: Existing project update"
EXISTING_PROJECT="$TEST_DIR/simple-existing-project"
rm -rf "$EXISTING_PROJECT" 2>/dev/null || true

# Create existing project with context
mkdir -p "$EXISTING_PROJECT/.contextual/context"
echo "# Existing Context" > "$EXISTING_PROJECT/.contextual/context/existing.md"

if bash "$INSTALL_SCRIPT" --project-root "$EXISTING_PROJECT" >/dev/null 2>&1; then
    echo "✓ Update completed"
    
    # Check that existing context was preserved
    if [[ -f "$EXISTING_PROJECT/.contextual/context/existing.md" ]]; then
        echo "✓ Existing context preserved"
    else
        echo "✗ Existing context was overwritten"
        exit 1
    fi
    
    echo "✓ Existing project test passed"
else
    echo "✗ Existing project test failed"
    exit 1
fi

# Test 4: Custom contextual root
echo "Test 4: Custom contextual root"
CUSTOM_PROJECT="$TEST_DIR/simple-custom-project"
rm -rf "$CUSTOM_PROJECT" 2>/dev/null || true

if bash "$INSTALL_SCRIPT" --project-root "$CUSTOM_PROJECT" --contextual-root ".dev-tools" >/dev/null 2>&1; then
    echo "✓ Custom installation completed"
    
    if [[ -d "$CUSTOM_PROJECT/.dev-tools" ]]; then
        echo "✓ Custom contextual root created"
    else
        echo "✗ Custom contextual root not created"
        exit 1
    fi
    
    echo "✓ Custom contextual root test passed"
else
    echo "✗ Custom contextual root test failed"
    exit 1
fi

# Cleanup
rm -rf "$TEST_PROJECT" "$EXISTING_PROJECT" "$CUSTOM_PROJECT" 2>/dev/null || true

echo ""
echo "All tests passed! ✓"
