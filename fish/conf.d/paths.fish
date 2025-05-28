# Path management for fish shell
# Synced with zmeta dotfiles

# ============ Path additions ============
# Add paths only if they exist and aren't already in path

# Core local bins
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin

# Language-specific paths
if test -d $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end

if test -d $HOME/.volta/bin
    fish_add_path $HOME/.volta/bin
end

if test -d $HOME/.cache/lm-studio/bin
    fish_add_path $HOME/.cache/lm-studio/bin
end

# Go
if test -d $HOME/go/bin
    fish_add_path $HOME/go/bin
end

# Kubernetes tools
if test -d $HOME/.krew/bin
    fish_add_path $HOME/.krew/bin
end

# NVM integration
set -gx NVM_DIR "$HOME/.config/nvm"
if test -d $NVM_DIR
    # Bass is a utility to run bash commands in fish
    if type -q bass; and test -f "$NVM_DIR/nvm.sh"
        function nvm
            bass source "$NVM_DIR/nvm.sh" --no-use ';' nvm $argv
        end
    end
end

# Add any zmeta/bin directory
if test -d $ZMETA/bin
    fish_add_path $ZMETA/bin
end