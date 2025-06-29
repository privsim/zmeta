function tools --description "Display available development tools and versions"
    echo "Development Environment Tools"
    echo "----------------------------"
    
    set -l tools_list \
        "Node.js:node --version" \
        "npm:npm --version" \
        "Python:python --version" \
        "pip:pip --version" \
        "Go:go version" \
        "Rust:rustc --version" \
        "Ruby:ruby --version" \
        "PHP:php --version" \
        "Docker:docker --version" \
        "Docker Compose:docker-compose --version" \
        "Kubernetes:kubectl version --client" \
        "Git:git --version" \
        "Fish:fish --version" \
        "nvim:nvim --version | head -n1" \
        "vim:vim --version | head -n1" \
        "VS Code:code --version | head -n1"
    
    for tool_info in $tools_list
        set -l tool_name (echo $tool_info | cut -d: -f1)
        set -l tool_cmd (echo $tool_info | cut -d: -f2-)
        
        echo -n "• $tool_name: "
        if type -q (echo $tool_cmd | cut -d' ' -f1)
            eval $tool_cmd 2>/dev/null | head -n1 || echo "Installed"
        else
            set_color red
            echo "Not installed"
            set_color normal
        end
    end
    
    # Check for Homebrew packages
    if type -q brew
        echo ""
        echo "Homebrew Packages"
        echo "----------------"
        brew list --versions | head -n 8
        set -l total_packages (brew list --versions | wc -l | string trim)
        echo "...and" (math $total_packages - 8) "more packages"
    end
end