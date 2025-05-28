# Fish Shell Configuration for Zmeta Dotfiles

This directory contains Fish shell configurations that integrate with the zmeta dotfiles framework.

## Overview

The Fish shell configuration is designed to:

1. Integrate smoothly with existing zmeta zsh configurations
2. Share aliases, functions, and environment variables where possible
3. Maintain the performance optimizations you've implemented
4. Provide a similar user experience between shells

## Directory Structure

- `config.fish` - Main configuration file
- `conf.d/` - Directory containing modular configurations:
  - `aliases.fish` - Command aliases
  - `paths.fish` - PATH variable management
  - `plugins.fish` - Fish plugin management
  - `performance.fish` - Shell optimization settings
- `functions/` - Fish functions:
  - `sync_history.fish` - Sync command history between Fish and Zsh
  - `use_zinit_plugins.fish` - Install Fish equivalents of Zinit plugins
- `completions/` - Command completions

## Installation

You can install the Fish configuration in two ways:

### Quick Setup (Symlink Only)

```bash
# From zsh or bash
~/.zmeta/bin/setup-fish
```

This will create symlinks from your zmeta Fish configuration to `~/.config/fish/`.

### Full Setup (Plugins & Tools)

```bash
# From zsh or bash
~/.zmeta/bin/setup-fish --full

# Or directly from fish
~/.zmeta/fish/install.fish
```

This will:
1. Create symlinks from your zmeta Fish configuration
2. Install Fisher plugin manager
3. Install recommended plugins
4. Install useful command-line tools if missing

## Adding to Existing Fish Installation

If you already have a Fish configuration:

1. Back up your existing configuration:
   ```fish
   cp -r ~/.config/fish ~/.config/fish.bak
   ```

2. Run the installation script which will preserve your existing local configurations

## Usage with Zinit

This Fish configuration is designed to work alongside your Zinit setup for Zsh. You can:

1. Use both shells interchangeably
2. Share configuration between shells where possible
3. Maintain a consistent environment across shells

## Key Features

- **Performance Optimization**: Fast startup time and responsive shell
- **Plugin Management**: Fisher for Fish plugins (parallel to Zinit for Zsh)
- **Shared Aliases**: Common aliases work in both shells
- **Modern Tools**: Support for starship, fzf, z, and other modern CLI tools
- **History Syncing**: Optional history synchronization between shells

## Customization

To add local machine-specific configurations:

1. Create `~/.config/fish/local.config.fish`
2. Add your custom settings there; they will be loaded automatically

## Recommended Tools

- `starship` - Cross-shell prompt
- `fzf` - Fuzzy finder
- `exa/eza` - Modern replacement for ls
- `bat` - Modern replacement for cat
- `fd` - Modern replacement for find
- `ripgrep` - Modern replacement for grep

## Troubleshooting

If you encounter issues:

1. Run `fish --debug` to see detailed startup information
2. Check for errors in the Fish configuration: `fish -c "source ~/.config/fish/config.fish"`
3. Reset to default configuration: `rm -rf ~/.config/fish && ~/.zmeta/bin/setup-fish`