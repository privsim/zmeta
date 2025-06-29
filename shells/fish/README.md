# Fish Shell Configuration

Simple, isolated Fish shell configuration for zmeta dotfiles.

## Features

- Minimal configuration to prevent startup loops
- No automatic plugin installation
- Simple symlink-based installation
- Isolated from zsh configuration to prevent conflicts

## Installation

```bash
# Install fish shell first
brew install fish  # macOS
# or your package manager of choice

# Install the configuration
~/.zmeta/shells/fish/install.sh
```

## Structure

- `config/config.fish` - Main configuration file
- `config/conf.d/aliases.fish` - Command aliases
- `config/functions/` - Custom functions (optional)
- `install.sh` - Simple installer script

## Usage

After installation:

```bash
# Test fish shell
fish

# Make it your default shell (optional)
chsh -s $(which fish)
```

## Customization

All files are symlinked to ~/.config/fish/ so changes in zmeta will be reflected immediately.

To add local machine-specific config:
1. Create `~/.config/fish/conf.d/local.fish`
2. Add your custom settings there

## Testing

The fish configuration includes comprehensive tests to verify everything works correctly:

```bash
# Run all tests
~/.zmeta/shells/fish/tests/run_tests.sh all

# Or use the fish manager
fish-manager test

# Quick test
fish-manager test-quick

# CI-style test (for automation)
~/.zmeta/shells/fish/tests/ci_test.sh
```

### Test Coverage

- ✅ Environment setup (ZMETA, EDITOR, PATH)
- ✅ Configuration file installation and symlinks
- ✅ Alias/abbreviation loading
- ✅ Infinite loop detection
- ✅ Basic functionality (commands, navigation)
- ✅ Tool integrations (starship, direnv)

## Troubleshooting

If you encounter issues:
1. Remove ~/.config/fish directory
2. Run the installer again
3. Check that fish is properly installed: `which fish`
