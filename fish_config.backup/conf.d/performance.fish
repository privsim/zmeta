# Fish shell performance optimizations

# ============ Command Execution ============
# Disable command-not-found handler for faster command execution
function __fish_command_not_found_handler
    echo "fish: Unknown command '$argv[1]'"
    return 127
end

# ============ File Navigation ============
# Use fastdir navigation when available
if type -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end

# ============ History Settings ============
# Optimize history settings
set -g fish_history_max_entries 10000
set -g fish_history_path ~/.local/share/fish/fish_history
set -g fish_history_save_on_exit true

# ============ Command Timeouts ============
# Set lower command timeout for faster responsiveness
set -g fish_command_timeout 10000
set -g fish_complete_timeout 0.5

# ============ Completion Settings ============
# Optimize completion settings
set -g fish_complete_max_items 100
set -g fish_complete_require_parameter true

# ============ Search Tools ============
# Use ripgrep for grep if available (much faster)
if type -q rg
    abbr -a grep 'rg'
    set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgreprc
end

# ============ Terminal Performance ============
# Optimize terminal performance
set -g fish_escape_delay_ms 10
set -g fish_key_bindings fish_default_key_bindings

# ============ Prompt Performance ============
# Optimize prompt performance
set -g fish_prompt_pwd_dir_length 0
set -g fish_prompt_pwd_full_dirs 3