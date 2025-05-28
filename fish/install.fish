#!/usr/bin/env fish

# Zmeta Fish configuration installer script

# Define source and destination paths
set -l zmeta_dir "$HOME/.zmeta"
set -l fish_source_dir "$zmeta_dir/fish"
set -l dest_dir "$HOME/.config/fish"

function info
    echo (set_color blue)[INFO](set_color normal): (set_color cyan)$argv(set_color normal)
end

function error
    echo (set_color red)[ERROR](set_color normal): (set_color yellow)$argv(set_color normal)
    return 1
end

# Create destination directory if it doesn't exist
mkdir -p $dest_dir

# Store current configuration as backup if it exists
if test -d $dest_dir/conf.d
    set timestamp (date +%Y%m%d%H%M%S)
    set backup_dir "$dest_dir.backup.$timestamp"
    info "Creating backup of existing configuration in $backup_dir"
    mkdir -p $backup_dir
    cp -r $dest_dir/* $backup_dir/
end

# Create necessary directories
info "Creating config directories"
for dir in functions completions conf.d
    mkdir -p $dest_dir/$dir
end

# Link main config file
info "Linking config.fish"
ln -sf $fish_source_dir/config.fish $dest_dir/config.fish

# Link configuration files in conf.d
info "Linking conf.d files"
for file in $fish_source_dir/conf.d/*.fish
    set file_name (basename $file)
    ln -sf $file $dest_dir/conf.d/$file_name
    info "- Linked $file_name"
end

# Link function files
info "Linking function files"
for file in $fish_source_dir/functions/*.fish
    set file_name (basename $file)
    ln -sf $file $dest_dir/functions/$file_name
    info "- Linked $file_name"
end

# Link completion files
info "Linking completion files"
for file in $fish_source_dir/completions/*.fish
    set file_name (basename $file)
    ln -sf $file $dest_dir/completions/$file_name
    info "- Linked $file_name"
end

# Install Fisher plugin manager
info "Installing Fisher plugin manager..."
if not functions -q fisher
    curl -sL https://git.io/fisher | source
    info "- Fisher installed successfully"
else
    info "- Fisher already installed"
end

# Install plugins from plugins.fish
if test -f $fish_source_dir/conf.d/plugins.fish
    info "Installing plugins from plugins.fish"
    source $fish_source_dir/conf.d/plugins.fish
    info "- Plugins installed successfully"
end

# Install recommended tools
info "Checking for recommended tools..."

# Set up tool installation based on platform
if test (uname) = "Darwin"
    set install_cmd "brew install"
    set check_cmd "brew list"
else if type -q apt
    set install_cmd "sudo apt install -y"
    set check_cmd "dpkg -l"
else if type -q pacman
    set install_cmd "sudo pacman -S --noconfirm"
    set check_cmd "pacman -Q"
else if type -q dnf
    set install_cmd "sudo dnf install -y"
    set check_cmd "rpm -q"
end

# Function to install tools with proper checks
function install_tool
    set -l tool $argv[1]
    
    # Check if tool is installed
    if not type -q $tool
        info "- Installing $tool"
        eval "$install_cmd $tool"
    else
        info "- $tool already installed"
    end
end

# Install recommended tools
install_tool starship
install_tool fzf
install_tool fd
install_tool bat
install_tool exa
install_tool ripgrep

# Final instructions
info "Installation complete!"
info "Fish configuration is now linked to zmeta. Changes to zmeta/fish will be reflected in your Fish shell."
info "To apply changes immediately, restart your shell or run: source ~/.config/fish/config.fish"