# Fish shell configuration optimized for performance

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
if type -q gpg-connect-agent
    gpg-connect-agent updatestartuptty /bye > /dev/null
end

# Initialize direnv if available
if type -q direnv
    direnv hook fish | source
end

# Initialize pyenv if available
if type -q pyenv-virtualenv-init
    pyenv virtualenv-init | source
end

# Initialize oh-my-posh if available
if test -f ~/.poshthemes/custom-pure.omp.json
    oh-my-posh init fish --config ~/.poshthemes/custom-pure.omp.json | source
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
fish_add_path $HOME/.volta/bin
fish_add_path $HOME/.cache/lm-studio/bin

# ============ Import Configurations ============
# Source local configurations that may change per machine
if test -f ~/.config/fish/local.config.fish
    source ~/.config/fish/local.config.fish
end

# Source aliases
if test -f ~/.config/fish/conf.d/aliases.fish
    source ~/.config/fish/conf.d/aliases.fish
end

# Source Fabric bootstrap if available
if test -f ~/.config/fabric/fabric-bootstrap.inc
    source ~/.config/fabric/fabric-bootstrap.inc
end

# ============ Abbreviations (faster than aliases) ============
abbr -a ll 'ls -lah'
abbr -a la 'ls -A'
abbr -a grep 'grep --color=auto'
abbr -a df 'df -h'
abbr -a du 'du -h'

# Git shortcuts
abbr -a g 'git'
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gd 'git diff'
abbr -a gl 'git log --oneline'
abbr -a gco 'git checkout'
abbr -a gb 'git branch'
abbr -a gst 'git stash'

# Directory navigation
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'

# Quick edit and reload
abbr -a fishconfig 'vim ~/.config/fish/config.fish'
abbr -a reload 'source ~/.config/fish/config.fish'

# ============ Functions ============
# Load custom functions from functions directory
# Functions are lazy-loaded in Fish for better performance

# ============ Set Fish colors ============
# Nord-inspired theme with good contrast
set -g fish_color_normal normal
set -g fish_color_command blue --bold
set -g fish_color_param cyan
set -g fish_color_redirection yellow
set -g fish_color_comment red
set -g fish_color_error brred
set -g fish_color_escape magenta
set -g fish_color_operator yellow
set -g fish_color_end green
set -g fish_color_quote green
set -g fish_color_autosuggestion 555

# ============ Initialize Fish Shell Extensions ============
# Only initialize what's actually installed (performance)
if type -q starship
    starship init fish | source
end

# ============ Key Bindings ============
# Use vi mode if preferred
# fish_vi_key_bindings
# Or use default emacs mode
fish_default_key_bindings

# ============ History Settings ============
set -g fish_history_size 10000
set -g fish_history_path ~/.local/share/fish/fish_history