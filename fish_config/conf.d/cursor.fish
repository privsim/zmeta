# Cursor IDE-specific configurations
if test -n "$CURSOR_TERMINAL"
    # Set specific configurations when running inside Cursor
    set -gx CURSOR_INTEGRATION true
    
    # Cursor-specific aliases and functions
    alias cursor-save 'echo "Saved from terminal"'
    
    # Optimizations for terminal inside Cursor
    set -gx CURSOR_TERMINAL_VERSION (string replace -r "^.*/" "" "$CURSOR_TERMINAL")
end