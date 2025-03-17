#!/bin/bash

# Define the directory to explore
directory=${1:-.}

# Maximum number of lines to display from each file
max_lines=${2:-10}

# Function to display the tree structure and file contents
display_tree() {
    local dir=$1
    local prefix=$2

    # Print the directory name
    echo "${prefix}$(basename "$dir")/"

    # List all files and directories
    for entry in "$dir"/*; do
        if [ -d "$entry" ]; then
            # If the entry is a directory, recursively call display_tree
            display_tree "$entry" "$prefix  "
        else
            # If the entry is a file, print its name and contents
            echo "${prefix}  $(basename "$entry")"
            echo "${prefix}  $(head -n "$max_lines" "$entry" | sed 's/^/'"$prefix"'    /')"
        fi
    done
}

# Call the display_tree function with the specified directory
display_tree "$directory" ""
