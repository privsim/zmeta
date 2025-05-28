# Function to switch from fish to zsh
function zsh --description "Switch to zsh shell or run zsh with arguments"
    # Check if zsh is being called with arguments
    if test (count $argv) -gt 0
        # If arguments are provided, just run zsh with them
        command zsh $argv
    else
        # Save current directory to ensure zsh starts in the same directory
        set -gx IWD (pwd)
        
        # Switch to zsh
        exec zsh
    end
end