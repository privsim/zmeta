# Fish shell configuration integrated with zmeta

# ============ Set zmeta path ============
set -gx ZMETA "$HOME/.zmeta"

# ============ Language and Locale ============
set -Ux LANG "en_US.UTF-8"
set -Ux LANGUAGE "en"
set -Ux LC_ALL "en_US.UTF-8"

# ============ Environment Variables ============
# Editor and Pager
set -Ux EDITOR vim
set -Ux VISUAL vim
set -Ux PAGER less
set -Ux LESS "-R"

# XDG Directories
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_RUNTIME_DIR "$HOME/.xdg"

# Development Paths
set -Ux GOPATH "$HOME/go"
set -Ux fish_user_paths $GOPATH/bin $fish_user_paths

# Security and Keys
set -Ux SOPS_AGE_KEY_FILE "$HOME/.config/sops/age/keys.txt"
set -Ux GPG_TTY (tty)
set -Ux SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

# For better color support
set -gx TERM xterm-256color

# ============ Performance Optimizations ============
# Disable greeting message for faster startup
set -g fish_greeting ""

# ============ Tool Initialization ============
# Initialize GPG agent
if type -q gpgconf
    gpgconf --launch gpg-agent
end

# Initialize direnv if available
if type -q direnv
    direnv hook fish | source
end

# Initialize pyenv if available
if type -q pyenv-virtualenv-init
    pyenv virtualenv-init | source
end

# ============ Custom Functions ============
function error
    echo (set_color red)[ERROR](set_color normal): (set_color yellow)$argv(set_color normal)
    return 1
end

function info
    echo (set_color blue)[INFO](set_color normal): (set_color cyan)$argv(set_color normal)
end

# ============ Working Directory Management ============
set -Ux IWD (pwd)
alias iwd='echo $IWD'
alias cdiwd='cd "$IWD"'

# ============ Path Management ============
# Add local bins to path
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# ============ Import Configurations ============
# Source all files in conf.d directory
for file in $ZMETA/fish/conf.d/*.fish
    source $file
end

# Source local configurations that may change per machine
if test -f ~/.config/fish/local.config.fish
    source ~/.config/fish/local.config.fish
end

# Source Fabric bootstrap if available
if test -f ~/.config/fabric/fabric-bootstrap.inc
    source ~/.config/fabric/fabric-bootstrap.inc
end

# ============ Key Bindings ============
# Use default emacs mode
fish_default_key_bindings

# ============ History Settings ============
set -g fish_history_size 10000
set -g fish_history_path ~/.local/share/fish/fish_history

# ============ Prompt Configuration ============
# If starship is installed, use it, otherwise fallback to default prompt
if type -q starship
    starship init fish | source
end