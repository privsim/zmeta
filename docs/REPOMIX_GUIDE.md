# Repomix Quick Reference Guide

## What is Repomix?
A powerful CLI tool that converts entire repositories into single, AI-friendly files with automatic .gitignore handling, token counting, and clipboard integration.

## Quick Start

### Basic Usage
```bash
# Copy entire repo to clipboard
rp                    # Alias for: repomix --copy

# Copy with code compression (extract only functions/classes)
rpc                   # Alias for: repomix --compress --copy

# Preview token distribution without output
rptoken               # Alias for: repomix --token-count-tree
```

### Language-Specific
```bash
# Copy only TypeScript/JavaScript files
rpjs                  # Alias for: repomix --include "**/*.{ts,tsx,js,jsx}" --copy

# Copy only Python files
rppy                  # Alias for: repomix --include "**/*.py" --copy
```

### Git Context
```bash
# Include git diffs and commit history
rpgit                 # Alias for: repomix --include-diffs --include-logs --copy
```

### Custom Functions

**Copy a specific subdirectory:**
```bash
rpsub src/components  # Copies only src/components/**/*
```

**Pack a remote GitHub repo:**
```bash
rpremote https://github.com/user/repo
# Or shorthand:
rpremote user/repo
```

**Ultra-compressed (minimal tokens):**
```bash
rpmin                 # Removes comments, empty lines, and compresses structure
```

## Advanced Options

### Output Formats
```bash
repomix --style markdown --copy    # Markdown format (default: XML)
repomix --style json --copy        # JSON format
repomix --style plain --copy       # Plain text
```

### Token Optimization
```bash
# Show only files with 100+ tokens
repomix --token-count-tree 100

# Remove comments and empty lines
repomix --remove-comments --remove-empty-lines --copy

# Compress to just code structure (HUGE savings)
repomix --compress --copy
```

### File Selection
```bash
# Include specific patterns
repomix --include "src/**/*.ts,*.md" --copy

# Exclude specific patterns (in addition to .gitignore)
repomix --ignore "*.test.ts,docs/**" --copy

# Disable .gitignore (include everything)
repomix --no-gitignore --copy
```

### Security
```bash
# Skip security scanning (faster but risky)
repomix --no-security-check --copy
```

### Git Integration
```bash
# Include current diffs
repomix --include-diffs --copy

# Include last 20 commits
repomix --include-logs --include-logs-count 20 --copy
```

## Configuration File

Create `repomix.config.json` in your repo for persistent settings:

```json
{
  "output": {
    "filePath": "output.md",
    "style": "markdown",
    "removeComments": true,
    "removeEmptyLines": true,
    "topFilesLength": 10
  },
  "include": ["src/**/*", "*.md"],
  "ignore": {
    "customPatterns": ["*.test.ts", "**/__tests__/**"]
  },
  "security": {
    "enableSecurityCheck": true
  }
}
```

Generate default config:
```bash
repomix --init  # Creates repomix.config.json in current directory
```

## Real-World Examples

### Example 1: Prepare frontend code for AI review
```bash
cd my-react-app
repomix --include "src/**/*.{ts,tsx}" --compress --remove-comments --copy
```

### Example 2: Share backend API with context
```bash
cd my-api
repomix --include "src/**/*.py,*.md" --include-diffs --copy
```

### Example 3: Minimal token usage for large repos
```bash
rpmin  # Alias for ultra-compressed output
```

### Example 4: Clone and pack a GitHub repo without cloning
```bash
repomix --remote yamadashy/repomix --compress --copy
```

## Web Interface

Visit **https://repomix.com** for a GUI version with:
- Drag & drop folder selection
- Live preview
- Browser-based processing
- No installation required

## Browser Extension

Install the Chrome/Firefox extension to pack any GitHub repository with one click.

## Token Limits Reference

| Model | Max Tokens | Safe Limit | Repomix Flag |
|-------|-----------|------------|--------------|
| GPT-4o | 128K | ~100K | `--token-count-encoding o200k_base` |
| Claude Sonnet 4.5 | 1M | ~950K | Use `--compress` for large repos |
| GPT-3.5 | 16K | ~12K | `--compress --remove-comments` |
| Gemini Pro | 2M | ~1.9M | No special flags needed |

## Tips & Tricks

1. **Always check token count first:**
   ```bash
   rptoken  # Preview before copying
   ```

2. **Use compression for large repos:**
   ```bash
   rpc  # Compressed version
   ```

3. **Create project-specific configs:**
   - Add `repomix.config.json` to your repos
   - Commit it for consistent team usage

4. **Combine with jq for JSON output:**
   ```bash
   repomix --style json -o output.json
   cat output.json | jq '.files[] | .path'
   ```

5. **Monitor your clipboard:**
   - macOS: `pbpaste | wc -l` (line count)
   - Linux: `xclip -o | wc -l`

## Troubleshooting

**"Command not found: repomix"**
```bash
npm install -g repomix
```

**"Security check failed"**
```bash
repomix --no-security-check --copy  # Skip if false positive
```

**"Output too large"**
```bash
repomix --compress --remove-comments --remove-empty-lines --copy
```

## Comparison with Alternatives

| Feature | Repomix | code2prompt | HTML File |
|---------|---------|-------------|-----------|
| Auto .gitignore | ✅ | ✅ | ❌ Manual |
| Token counting | ✅ Accurate | ✅ Accurate | ❌ Size only |
| Compression | ✅ Tree-sitter | ❌ | ❌ |
| Security scan | ✅ Secretlint | ❌ | ❌ |
| Web UI | ✅ repomix.com | ❌ | ✅ Local |
| Git integration | ✅ Diffs/logs | ✅ Diffs | ❌ |
| Speed | ✅ Fast | ✅ Fast | ❌ Slow |
| Installation | npm/npx | cargo/brew | None |

## Sources & Documentation

- GitHub: https://github.com/yamadashy/repomix
- Web UI: https://repomix.com
- Documentation: https://github.com/yamadashy/repomix#readme

---

**Last Updated:** 2025-11-28
**Repomix Version:** 1.9.2
