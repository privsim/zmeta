# Performance optimizations for fish shell

# Disable greeting
set -g fish_greeting ""

# Faster key timeout for vi mode
if test "$fish_key_bindings" = "fish_vi_key_bindings"
    set -g fish_escape_delay_ms 10
end

# Limit syntax highlighting for large buffers to improve performance
set -g fish_handle_reflow 0

# Optimize command history
set -g fish_history_max_lines 20000

# Define function to measure shell startup time
function time_fish
    for i in (seq 5)
        /usr/bin/time fish -c exit
    end
end

# Disable running of startup commands if --no-config flag is passed to fish
if set -q argv[1]; and test "$argv[1]" = "--no-config"
    # Clear all event handlers
    for e in (functions -a | grep "__fish_on")
        functions -e $e
    end
    # Skip the rest of initialization
end