# Minimal Fish shell configuration for zmeta
# Performance-focused and loop-free

# Set basic environment
set -gx ZMETA "$HOME/.zmeta"
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER less

# Disable greeting for faster startup
set -g fish_greeting ""

# Basic PATH additions
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
if test -d $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end

# Source minimal configurations only if they exist
if test -f $ZMETA/shells/fish/config/conf.d/aliases.fish
    source $ZMETA/shells/fish/config/conf.d/aliases.fish
end

# Initialize starship if available (no automatic installation)
if type -q starship
    starship init fish | source
end

# Basic completion
if type -q direnv
    direnv hook fish | source
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/lclose/.cache/lm-studio/bin
# End of LM Studio CLI section

