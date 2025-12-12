# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**ZMETA** is a modular, cross-platform shell configuration system built on zsh and zinit. It provides platform-specific and hardware-specific configuration management with XDG Base Directory compliance.

## Repository Structure

```
~/.zmeta/
├── .zshenv              # Environment variables (sourced by all zsh instances)
├── .zshrc               # Main zsh configuration with zinit plugin management
├── aliases.zsh          # Global shell aliases
├── aliases-{Darwin,Linux}.zsh  # OS-specific aliases
├── lib/
│   └── xdg.zsh         # XDG Base Directory Specification setup
├── hosts/
│   ├── platforms/      # OS + architecture combinations
│   │   ├── _core/      # Shared platform initialization
│   │   ├── darwin-arm64/
│   │   ├── linux-aarch64/
│   │   └── linux-x86_64/
│   └── hardware/       # Machine-specific configs (by hostname)
│       ├── m1/, m3/, obs/, nzt/, etc.
├── bin/                # Utility scripts and tools
├── shells/
│   └── fish/          # Fish shell integration (isolated from zsh)
├── functions/         # Shell functions
├── tests/            # Bats test suite
└── zinit/           # Zinit plugin manager (git submodule)
```

## Key Architecture Concepts

### 1. Initialization Flow

The shell initialization follows this order:
1. `.zshenv` - Sets core environment variables, ZMETA paths, detects platform
2. Platform detection → sources `hosts/platforms/{os}-{arch}/init.zsh`
3. Platform init → sources `hosts/platforms/_core/init.zsh`
4. `.zshrc` - Loads zinit, plugins, completions, and theme
5. Hardware-specific config loaded if hostname matches directory in `hosts/hardware/`
6. User aliases and functions sourced last

### 2. Platform-Specific Configuration

Platforms are auto-detected as `{os}-{arch}` (e.g., `darwin-arm64`, `linux-x86_64`). Each platform can define:
- `init.zsh` - Platform initialization and environment setup
- `essence/` - Directory synced to `~/.config/` for platform-specific app configs
- `DARWIN_ARM64_CONFIGS` or similar associative arrays for lazy-loaded configs

### 3. Hardware-Specific Configuration

Machine-specific configs are stored in `hosts/hardware/{hostname}/` and typically contain:
- `aliases.zsh` - Machine-specific command aliases
- Additional host-specific configuration files

### 4. Zinit Plugin Management

The `.zshrc` uses zinit extensively for:
- Oh-My-Zsh and Prezto plugins as snippets
- GitHub releases as binaries (fd, bat, ripgrep, etc.)
- Completions for various tools
- Fast-syntax-highlighting and autosuggestions
- Pure prompt theme

## Common Development Tasks

### Running Tests

```bash
# Run all tests using bats
./tests/run_tests.sh tests/*.bats

# Run specific test suite
bats tests/platform_detection.bats

# View test output
cat tests/output/test_results.tap    # TAP13 format
cat tests/output/summary.txt         # Human-readable summary
```

Test coverage includes:
- Platform detection (OS/architecture)
- Hardware detection (hostname-based)
- Environment setup (PATH, XDG directories)
- Essence copying (config inheritance)
- Alias management

### Regenerating Directory Structure

Use the `cohere` script to regenerate platform/hardware directories:

```bash
# Source the cohere function
source ~/.zmeta/bin/cohere

# Run to create directory structure
cohere
```

This creates all platform and hardware directories defined in the script.

### Adding New Platform Support

1. Add platform to `bin/cohere` in the `platforms` array
2. Run `cohere` to create directory structure
3. Create `hosts/platforms/{new-platform}/init.zsh`
4. Add platform-specific PATH, environment variables, and configs

### Adding New Hardware Configuration

1. Add hostname to `bin/cohere` in the `hardware_names` array
2. Run `cohere` to create directory structure
3. Create `hosts/hardware/{hostname}/aliases.zsh` with machine-specific aliases

### Benchmarking Shell Startup

```bash
# Run 10 startup benchmarks
zbench

# Or manually
for i in {1..10}; do /usr/bin/time zsh -lic exit; done
```

### Testing Fish Shell Integration

```bash
# Install fish config (symlinks to ~/.config/fish/)
~/.zmeta/shells/fish/install.sh

# Run fish integration tests
~/.zmeta/shells/fish/tests/run_tests.sh all
```

## Important Configuration Details

### XDG Base Directory Compliance

All XDG directories are set up in `lib/xdg.zsh` with platform-specific runtime directory handling:
- macOS: Uses `$TMPDIR/runtime-$(id -u)`
- Linux: Uses `/run/user/$(id -u)` with fallback

### Zinit Configuration

Zinit is configured to use:
- `$HOME/.local/share/zsh/zinit` as the base directory
- Optimized disk access with `ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1`
- Completion caching in zinit's completions directory

### Environment Variables

Key variables set in `.zshenv`:
- `ZMETA` - Path to this repository (`$HOME/.zmeta`)
- `ZDOTDIR` - Points to `$ZMETA` (makes zsh look here for configs)
- `ZINIT_HOME` - Zinit installation directory
- `GOPATH` - Go workspace path
- `OLLAMA_MODELS`, `OLLAMA_HOST` - Ollama configuration

### Plugin Initialization Order

1. Static zsh binary from romkatv/zsh-bin
2. Oh-My-Zsh and Prezto snippets
3. Completions
4. Tool-specific plugins (kubectl, docker, etc.)
5. Pure prompt
6. zsh-vim-mode
7. GitHub release binaries
8. Syntax highlighting (loaded last)
9. Final cleanup with `zicompinit` and `zicdreplay`

## Key Scripts

- `bin/cohere` - Directory structure generator
- `bin/argon2_hashgen.py` - Argon2 password hash generator
- `bin/authelia-gensecs.sh` - Authelia secret generation
- `bin/choices` / `bin/choice` - Interactive menu selection
- `tests/run_tests.sh` - Bats test runner with output formatting

## Testing Infrastructure

Uses bats-core with helper libraries (git submodules):
- `bats-support` - Test helpers
- `bats-assert` - Assertion functions
- `bats-file` - File/directory assertions

Test files use common setup functions from `tests/test_helper/common-setup.bash`.

## Notable Tools Installed via Zinit

Binary tools from GitHub releases:
- **Search/Find**: fd, ripgrep, fzf, grex
- **Viewers**: bat, hexyl, delta (git diff)
- **Benchmarking**: hyperfine, bottom
- **Editors**: neovim, helix
- **Dev Tools**: jq, shellcheck, shfmt
- **Kubernetes**: kubectl-fzf, arkade
- **Package Managers**: aqua, uv (Python)
- **Shell Tools**: direnv, vivid (LS_COLORS)

## Shell Isolation

Fish shell configuration is completely isolated in `shells/fish/` and installed separately to `~/.config/fish/`. It does not interfere with zsh configuration.

## Git Submodules

Initialize submodules after cloning:
```bash
git submodule init
git submodule update
```

Active submodules:
- `test_helper/bats-support`
- `test_helper/bats-assert`
- `test_helper/bats-file`
- `zinit/` (zinit plugin manager)

## Vim Mode Configuration

Zsh uses vim mode with visual indicators:
- Mode indicators: INSERT (green), NORMAL (cyan), VISUAL (blue), REPLACE (red)
- Cursor changes per mode (blinking bar in insert, block in normal)
- `KEYTIMEOUT=1` for fast mode switching
- Edit command line in vim with `Ctrl-e` in vicmd mode

## Common Aliases

See `aliases.zsh`, `aliases-Darwin.zsh`, or `aliases-Linux.zsh` for full list. Notable ones:
- `gac` - Git add all and commit
- `ll`, `la`, `l` - Various listing formats using lsd/eza
- `cleanup` - Platform-specific cleanup (brew cleanup on macOS)
- `zbench` - Benchmark zsh startup time
- `hashpass` - Generate Argon2 password hash
