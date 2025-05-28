# Optimized Fish Shell Configuration

This is a performance-focused Fish shell configuration setup, especially optimized for use with Cursor IDE.

## Features

- **Performance Optimizations**: Faster startup and command execution
- **Modern Prompt**: Informative and clean prompt design
- **Useful Functions**: Productivity-enhancing commands
- **Path Management**: Comprehensive PATH configuration matching ZSH setup
- **Abbreviations**: Quick text expansions for common commands
- **Cursor Integration**: Special configurations for Cursor IDE
- **Organized Structure**: Modular configuration files
- **Tool Detection**: Automatic configuration based on installed tools

## Installation

1. Run the installer:
   ```fish
   cd /path/to/fish_config
   fish install.fish
   ```

2. Restart your shell or source the configuration:
   ```fish
   source ~/.config/fish/config.fish
   ```

## Directory Structure

- `config.fish`: Main configuration file
- `functions/`: Custom function definitions
- `completions/`: Tab completion definitions
- `conf.d/`: Configuration snippets (loaded automatically)
  - `paths.fish`: PATH setup matching ZSH configuration
  - `custom.fish`: Tool-specific configurations
  - `performance.fish`: Speed optimizations
  - `abbr.fish`: Abbreviations for common commands
  - `cursor.fish`: Cursor IDE integrations

## Key Features

### Path Management

- Comprehensive path configuration matching ZSH setup
- Properly configured with Fish's `fish_add_path` function
- Includes all personal, tool-specific, and system bin directories

### Performance Optimizations

- Faster command execution with optimized settings
- Lazy-loaded functions
- Efficient abbreviations instead of aliases where appropriate
- Reduced history size and completion timeouts

### Useful Functions

- `mkcd`: Create a directory and navigate into it
- `extract`: Universal archive extraction
- `up`: Move up multiple directories quickly
- `proj`: Quick navigation to project directories
- `tools`: Display all available development tools and versions

### Automatic Environment Configuration

- Detects installed tools and languages
- Configures environment variables automatically
- Sets up completions for tools like kubectl when available
- Auto-activates Python virtual environments

### Cursor IDE Integration

- Detects when running inside Cursor
- Sets appropriate environment variables
- Optimizes terminal usage within Cursor

## Recommended Tools

This configuration works even better with:

- **Starship**: Modern cross-shell prompt
- **fzf**: Fuzzy finder for history, file search
- **fd**: Fast alternative to `find`
- **bat**: Better `cat` with syntax highlighting
- **ripgrep**: Faster alternative to grep

The installer will attempt to install these if you have Homebrew available.

## Customization

- Add machine-specific settings to `~/.config/fish/local.config.fish`
- Add new functions to `~/.config/fish/functions/`
- Add new configuration files to `~/.config/fish/conf.d/`