#!/bin/bash

# Function to generate the project structure using `tree`
generate_tree_structure() {
  echo "# Project Structure (left) and File Metadata (right)" > "$2"
  echo -e "\n## Project Structure\n\n" >> "$2"
  tree "$1" >> "$2"
}

# Function to list and display contents of files
list_and_cat() {
  # Find all files recursively and loop through each file
  find . -type f | while read -r file; do
    if file "$file" | grep -q 'text'; then
      echo "File: $file"
      echo "---------------------------------"
      cat "$file"
      echo -e "\n"
    else
      echo "File: $file (binary or non-renderable, skipping)"
      echo "---------------------------------"
      echo -e "\n"
    fi
  done
}

# Call the function
list_and_cat


---
