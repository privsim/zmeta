# Function to install fish equivalents of your zinit plugins
# This helps maintain parity between zsh and fish environments

function use_zinit_plugins --description "Install fish equivalents of zinit plugins"
    # Check if fisher is installed
    if not functions -q fisher
        echo "Fisher plugin manager not installed. Installing now..."
        curl -sL https://git.io/fisher | source
    end
    
    # Common plugins from your zinit setup with fish equivalents
    echo "Installing fish equivalents of zinit plugins..."
    
    # Git integration
    fisher install jhillyerd/plugin-git
    
    # z for directory jumping (equivalent to z in zinit)
    fisher install jethrokuan/z
    
    # fzf integration
    fisher install patrickf1/fzf.fish
    
    # Completion enhancements
    fisher install franciscolourenco/done
    
    # Auto-suggestions (equivalent to zsh-autosuggestions)
    fisher install jorgebucaran/fish-shell-abbr
    
    # Syntax highlighting is built into fish
    
    # Bass to run bash utilities
    fisher install edc/bass
    
    echo "Fish plugin installation complete!"
end