# Fish plugin configuration for zmeta

# ============ Plugin Manager ============
# Using Fisher as the plugin manager
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl -sL https://git.io/fisher | source
end

# ============ Popular Plugins ============
# Only install if fisher is available
if functions -q fisher
    # 1. Colored man pages
    fisher install decors/fish-colored-man

    # 2. Bass - Run bash commands in Fish
    fisher install edc/bass

    # 3. Autopair - Automatic bracket/parenthesis pairing
    fisher install jorgebucaran/autopair.fish

    # 4. Puffer - Fish command history search
    fisher install nickeb96/puffer-fish

    # 5. fzf - Fuzzy finder integration
    fisher install patrickf1/fzf.fish

    # 6. z - Directory jumping
    fisher install jethrokuan/z

    # 7. Done - Notifications for long-running commands
    fisher install franciscolourenco/done

    # 8. Sponge - Clean command output
    fisher install meaningful-ooo/sponge
end

# ============ Plugin Configuration ============

# Configure fzf
set -g FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"
set -g FZF_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
set -g FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"

# Configure z (directory jumping)
set -g Z_DATA "$HOME/.z"
set -g Z_OWNER $USER

# Configure done notifications
set -U __done_min_cmd_duration 10000  # Notify for commands taking >10s
set -U __done_notification_command "terminal-notifier -title 'Done' -message 'Command completed'"

# Configure colored man pages
set -g man_blink -o red
set -g man_bold -o green
set -g man_standout -b black yellow
set -g man_underline -u blue