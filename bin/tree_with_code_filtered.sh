#!/bin/bash

# Define the directory to explore
directory=${1:-.}

# Maximum number of lines to display from each file
max_lines=${2:-10}

# Regex pattern for file names
pattern=${3:-'^Task'}

# Function to display the tree structure and file contents
display_tree() {
    local dir=$1
    local prefix=$2

    # Print the directory name
    echo "${prefix}$(basename "$dir")/"

    # Find files and directories using fd with the specified pattern
    fd --base-directory "$dir" --type d --type f --regex "$pattern" -x bash -c '
        for entry; do
            if [ -d "$entry" ]; then
                echo "'"${prefix}  $(basename "$entry")/"'"
            else
                echo "'"${prefix}  $(basename "$entry")"'"
                head -n "'"$max_lines"'" "$entry" | sed "s/^/'"${prefix}"'    /"
            fi
        done
    ' bash
}

# Call the display_tree function with the specified directory
display_tree "$directory" ""