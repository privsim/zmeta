# Repomix helper functions for common workflows
# Source this in your .zshrc or add to functions directory

# Quick copy entire repo to clipboard
alias rp='repomix --copy'

# Copy with compression (extract only code structure)
alias rpc='repomix --compress --copy'

# Copy TypeScript/JavaScript only
alias rpjs='repomix --include "**/*.{ts,tsx,js,jsx}" --copy'

# Copy Python only
alias rppy='repomix --include "**/*.py" --copy'

# Copy with git context
alias rpgit='repomix --include-diffs --include-logs --copy'

# Preview token distribution
alias rptoken='repomix --token-count-tree'

# Copy a specific directory
rpsub() {
    if [[ -z "$1" ]]; then
        echo "Usage: rpsub <directory>"
        return 1
    fi
    repomix --include "$1/**/*" --copy
}

# Pack remote GitHub repo
rpremote() {
    if [[ -z "$1" ]]; then
        echo "Usage: rpremote <github-url-or-user/repo>"
        return 1
    fi
    repomix --remote "$1" --copy
}

# Ultra-compressed version (no comments, no empty lines, compressed structure)
rpmin() {
    repomix --compress --remove-comments --remove-empty-lines --copy
}
