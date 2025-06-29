#!/usr/bin/env fish

# Fish configuration installer script

# Define source and destination paths
set -l source_dir (dirname (status -f))
set -l dest_dir ~/.config/fish

# Create destination directory if it doesn't exist
mkdir -p $dest_dir

# Copy configuration files
echo "Installing Fish shell configuration files..."

# Main config file
echo "- Installing config.fish"
cp -f $source_dir/config.fish $dest_dir/

# Create necessary directories
for dir in functions completions conf.d
    echo "- Creating $dir directory"
    mkdir -p $dest_dir/$dir
    
    echo "- Installing $dir files"
    cp -rf $source_dir/$dir/* $dest_dir/$dir/ 2>/dev/null
end

# Install Fisher plugin manager
echo "Installing Fisher plugin manager..."
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl -sL https://git.io/fisher | source
    echo "- Fisher installed successfully"
else
    echo "- Fisher already installed"
end

# Install recommended packages
echo "Checking for recommended tools..."

# Starship prompt
if not type -q starship
    echo "- Installing starship prompt"
    if type -q brew
        brew install starship
    else
        echo "Homebrew not found. Please install starship manually:"
        echo "curl -sS https://starship.rs/install.sh | sh"
    end
else
    echo "- Starship already installed"
end

# fzf for better history search
if not type -q fzf
    echo "- Installing fzf"
    if type -q brew
        brew install fzf
    else
        echo "Homebrew not found. Please install fzf manually"
    end
else
    echo "- fzf already installed"
end

# fd for better find
if not type -q fd
    echo "- Installing fd"
    if type -q brew
        brew install fd
    else
        echo "Homebrew not found. Please install fd manually"
    end
else
    echo "- fd already installed"
end

# bat for better cat
if not type -q bat
    echo "- Installing bat"
    if type -q brew
        brew install bat
    else
        echo "Homebrew not found. Please install bat manually"
    end
else
    echo "- bat already installed"
end

# terminal-notifier for done plugin
if not type -q terminal-notifier
    echo "- Installing terminal-notifier"
    if type -q brew
        brew install terminal-notifier
    else
        echo "Homebrew not found. Please install terminal-notifier manually"
    end
else
    echo "- terminal-notifier already installed"
end

# Install plugins
echo "Installing Fish plugins..."
if functions -q fisher
    echo "- Installing plugins from plugins.fish"
    source $dest_dir/conf.d/plugins.fish
    echo "- Plugins installed successfully"
else
    echo "Error: Fisher not installed. Please run the installer again."
    exit 1
end

# Final instructions
echo "Installation complete!"
echo "To apply changes, restart your shell or run: source ~/.config/fish/config.fish"
echo ""
echo "Optional: Configure Starship prompt with: starship init fish > ~/.config/fish/conf.d/starship.fish"