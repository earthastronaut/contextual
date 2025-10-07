#!/bin/bash

# Project Structure Analysis Script - Variables Only
# Usage: .specify/scripts/bash/analyze.sh

# Source common utilities
source "$(dirname "$0")/common.sh"

# Analysis configuration variables
ANALYSIS_OUTPUT_DIR="$SPECS_DIR/FEATURES"
ANALYSIS_OUTPUT_FILE="$ANALYSIS_OUTPUT_DIR/analyzed.md"

# Project structure variables
PROJECT_ROOT="$(pwd)"
GIT_BRANCH="$(git branch --show-current 2>/dev/null || echo 'unknown')"
GIT_STATUS_COUNT="$(git status --porcelain | wc -l)"

# Technology detection variables
HAS_PACKAGE_JSON="$(test -f package.json && echo 'true' || echo 'false')"
HAS_REQUIREMENTS_TXT="$(test -f requirements.txt && echo 'true' || echo 'false')"
HAS_PYPROJECT_TOML="$(test -f pyproject.toml && echo 'true' || echo 'false')"
HAS_GEMFILE="$(test -f Gemfile && echo 'true' || echo 'false')"
HAS_CARGO_TOML="$(test -f Cargo.toml && echo 'true' || echo 'false')"
HAS_GO_MOD="$(test -f go.mod && echo 'true' || echo 'false')"
HAS_POM_XML="$(test -f pom.xml && echo 'true' || echo 'false')"
HAS_BUILD_GRADLE="$(test -f build.gradle && echo 'true' || echo 'false')"
HAS_MAKEFILE="$(test -f Makefile && echo 'true' || echo 'false')"
HAS_DOCKERFILE="$(test -f Dockerfile && echo 'true' || echo 'false')"
HAS_DOCKER_COMPOSE="$(test -f docker-compose.yml -o -f docker-compose.yaml && echo 'true' || echo 'false')"

# Directory structure variables
HAS_SRC_DIR="$(test -d src && echo 'true' || echo 'false')"
HAS_LIB_DIR="$(test -d lib && echo 'true' || echo 'false')"
HAS_APP_DIR="$(test -d app && echo 'true' || echo 'false')"
HAS_TESTS_DIR="$(test -d tests -o -d test && echo 'true' || echo 'false')"
HAS_DOCS_DIR="$(test -d docs && echo 'true' || echo 'false')"

# Documentation variables
README_FILES="$(find . -maxdepth 2 -name "README*" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
DOC_FILES="$(find . -maxdepth 2 -name "*.md" ! -name "README*" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
CONTEXT_FILES="$(find . -name "*FEATURE_CONTEXT*" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"

# File count variables
TOTAL_FILES="$(find . -type f ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
JS_FILES="$(find . -type f -name "*.js" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
PY_FILES="$(find . -type f -name "*.py" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
RB_FILES="$(find . -type f -name "*.rb" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
RS_FILES="$(find . -type f -name "*.rs" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
GO_FILES="$(find . -type f -name "*.go" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"
JAVA_FILES="$(find . -type f -name "*.java" ! -path './.*' ! -path './.specify*' 2>/dev/null | wc -l)"

# Export all variables
export ANALYSIS_OUTPUT_DIR
export ANALYSIS_OUTPUT_FILE
export PROJECT_ROOT
export GIT_BRANCH
export GIT_STATUS_COUNT
export HAS_PACKAGE_JSON
export HAS_REQUIREMENTS_TXT
export HAS_PYPROJECT_TOML
export HAS_GEMFILE
export HAS_CARGO_TOML
export HAS_GO_MOD
export HAS_POM_XML
export HAS_BUILD_GRADLE
export HAS_MAKEFILE
export HAS_DOCKERFILE
export HAS_DOCKER_COMPOSE
export HAS_SRC_DIR
export HAS_LIB_DIR
export HAS_APP_DIR
export HAS_TESTS_DIR
export HAS_DOCS_DIR
export README_FILES
export DOC_FILES
export CONTEXT_FILES
export TOTAL_FILES
export JS_FILES
export PY_FILES
export RB_FILES
export RS_FILES
export GO_FILES
export JAVA_FILES

# Main analyze function
analyze_project() {
    # Echo key variables in the same format as specify.sh
    echo "PROJECT_ROOT: $PROJECT_ROOT"
    echo "GIT_BRANCH: $GIT_BRANCH"
    echo "GIT_STATUS_COUNT: $GIT_STATUS_COUNT"
    echo "ANALYSIS_OUTPUT_DIR: $ANALYSIS_OUTPUT_DIR"
    echo "ANALYSIS_OUTPUT_FILE: $ANALYSIS_OUTPUT_FILE"
    echo "TOTAL_FILES: $TOTAL_FILES"
    echo "HAS_PACKAGE_JSON: $HAS_PACKAGE_JSON"
    echo "HAS_REQUIREMENTS_TXT: $HAS_REQUIREMENTS_TXT"
    echo "HAS_PYPROJECT_TOML: $HAS_PYPROJECT_TOML"
    echo "HAS_GEMFILE: $HAS_GEMFILE"
    echo "HAS_CARGO_TOML: $HAS_CARGO_TOML"
    echo "HAS_GO_MOD: $HAS_GO_MOD"
    echo "HAS_POM_XML: $HAS_POM_XML"
    echo "HAS_BUILD_GRADLE: $HAS_BUILD_GRADLE"
    echo "HAS_MAKEFILE: $HAS_MAKEFILE"
    echo "HAS_DOCKERFILE: $HAS_DOCKERFILE"
    echo "HAS_DOCKER_COMPOSE: $HAS_DOCKER_COMPOSE"
    echo "HAS_SRC_DIR: $HAS_SRC_DIR"
    echo "HAS_LIB_DIR: $HAS_LIB_DIR"
    echo "HAS_APP_DIR: $HAS_APP_DIR"
    echo "HAS_TESTS_DIR: $HAS_TESTS_DIR"
    echo "HAS_DOCS_DIR: $HAS_DOCS_DIR"
    echo "README_FILES: $README_FILES"
    echo "DOC_FILES: $DOC_FILES"
    echo "CONTEXT_FILES: $CONTEXT_FILES"
    echo "JS_FILES: $JS_FILES"
    echo "PY_FILES: $PY_FILES"
    echo "RB_FILES: $RB_FILES"
    echo "RS_FILES: $RS_FILES"
    echo "GO_FILES: $GO_FILES"
    echo "JAVA_FILES: $JAVA_FILES"
    
    return 0
}

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    analyze_project
fi
