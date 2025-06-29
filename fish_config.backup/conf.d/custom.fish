# Custom configurations for your environment

# ============ Development Tools ============
# Rust environment
if type -q cargo
    set -gx RUST_BACKTRACE 1
    set -gx RUSTFLAGS "-C target-cpu=native"
    set -gx CARGO_INCREMENTAL 1
end

# ============ Docker Configuration ============
if type -q docker
    # Force Docker BuildKit to be enabled for better build performance
    set -gx DOCKER_BUILDKIT 1
    set -gx COMPOSE_DOCKER_CLI_BUILD 1
    
    # Docker abbreviations (faster than aliases)
    abbr -a dps 'docker ps'
    abbr -a dex 'docker exec -it'
    abbr -a dc 'docker-compose'
    abbr -a dcu 'docker-compose up'
    abbr -a dcd 'docker-compose down'
    abbr -a dcl 'docker-compose logs -f'
end

# ============ Python Environment ============
if type -q python
    # Auto-activate virtual environments
    function __auto_source_venv --on-variable PWD --description "Auto activate Python virtualenvs"
        # Check for .venv directory
        if test -d .venv
            if test -f .venv/bin/activate.fish
                source .venv/bin/activate.fish
                echo "Activated virtual environment (.venv)"
            end
        # Check for venv directory
        else if test -d venv
            if test -f venv/bin/activate.fish
                source venv/bin/activate.fish
                echo "Activated virtual environment (venv)"
            end
        end
    end
    
    # Python abbreviations
    abbr -a py 'python'
    abbr -a pip 'pip3'
    abbr -a venv 'python -m venv'
end

# ============ Kubernetes Configuration ============
if type -q kubectl
    # Set up kubectl shell completion
    kubectl completion fish | source
    
    # Kubernetes abbreviations
    abbr -a k 'kubectl'
    abbr -a kgp 'kubectl get pods'
    abbr -a kgs 'kubectl get services'
    abbr -a kgd 'kubectl get deployments'
    abbr -a kgn 'kubectl get nodes'
    abbr -a kd 'kubectl describe'
    abbr -a kl 'kubectl logs -f'
    
    # Function to switch kubectl context
    function kctx --description "Switch kubectl context"
        if count $argv > /dev/null
            kubectl config use-context $argv[1]
        else
            kubectl config current-context
        end
    end
    
    # Function to get pod logs
    function klogs --description "Get pod logs"
        if count $argv > /dev/null
            kubectl logs -f $argv[1]
        else
            echo "Usage: klogs <pod-name>"
        end
    end
end

# ============ System Information ============
if type -q neofetch
    # Run neofetch on new shell but only if:
    # 1. Not in Cursor IDE
    # 2. Not in a non-interactive shell
    # 3. Not in a subshell (check is a login shell)
    if status is-login; and status is-interactive; and test -z "$CURSOR_TERMINAL"
        neofetch
    end
end

# ============ Git Configuration ============
if type -q git
    # Set default branch name
    git config --global init.defaultBranch main
    
    # Set default editor
    git config --global core.editor vim
    
    # Set default push behavior
    git config --global push.default current
end