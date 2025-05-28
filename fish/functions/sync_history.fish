# Function to sync command history between fish and zsh
# This allows you to maintain a consistent history across shells

function sync_history --description "Sync command history between fish and zsh"
    set -l fish_history_file ~/.local/share/fish/fish_history
    set -l zsh_history_file ~/.zsh_history
    
    # Ensure history files exist
    if not test -f $fish_history_file
        touch $fish_history_file
    end
    
    if not test -f $zsh_history_file
        touch $zsh_history_file
    end
    
    info "Syncing history between fish and zsh..."
    
    # Get zsh history that's not in fish
    if type -q grep; and type -q sed
        # Extract commands from zsh history (format varies)
        set -l zsh_cmds (grep -a ';' $zsh_history_file | sed 's/^.*;//' | sort | uniq)
        
        # Add to fish history
        for cmd in $zsh_cmds
            # Skip empty commands and very short ones (likely typos)
            if test -n "$cmd"; and test (string length "$cmd") -gt 3
                # Add to history without executing
                history merge
                echo "$cmd" | history merge
            end
        end
    end
    
    info "History sync complete"
end