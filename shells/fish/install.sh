#!/usr/bin/env bash
# Simple Fish shell installer for zmeta - no loops, no complexity

set -euo pipefail

ZMETA_DIR="$HOME/.zmeta"
FISH_CONFIG_DIR="$HOME/.config/fish"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if fish is installed
if ! command -v fish >/dev/null 2>&1; then
    error "Fish shell is not installed. Install with: brew install fish"
fi

# Check if zmeta fish config exists
if [ ! -d "$ZMETA_DIR/shells/fish/config" ]; then
    error "Fish configuration not found in zmeta. Expected: $ZMETA_DIR/shells/fish/config"
fi

# Create config directory
info "Creating fish config directory..."
mkdir -p "$FISH_CONFIG_DIR"
mkdir -p "$FISH_CONFIG_DIR/conf.d"
mkdir -p "$FISH_CONFIG_DIR/functions"

# Backup existing config if it exists
if [ -f "$FISH_CONFIG_DIR/config.fish" ] && [ ! -L "$FISH_CONFIG_DIR/config.fish" ]; then
    info "Backing up existing config.fish"
    mv "$FISH_CONFIG_DIR/config.fish" "$FISH_CONFIG_DIR/config.fish.backup.$(date +%s)"
fi

# Create symlinks
info "Creating symlinks..."
ln -sf "$ZMETA_DIR/shells/fish/config/config.fish" "$FISH_CONFIG_DIR/config.fish"
ln -sf "$ZMETA_DIR/shells/fish/config/conf.d/aliases.fish" "$FISH_CONFIG_DIR/conf.d/aliases.fish"

# Link any functions if they exist
if [ -d "$ZMETA_DIR/shells/fish/config/functions" ]; then
    for func_file in "$ZMETA_DIR/shells/fish/config/functions"/*.fish; do
        [ -f "$func_file" ] && ln -sf "$func_file" "$FISH_CONFIG_DIR/functions/"
    done
fi

success "Fish configuration installed successfully!"
info "To test: fish"
info "To make default shell: chsh -s \$(which fish)"
info "Config files are symlinked to zmeta - changes will be preserved"
