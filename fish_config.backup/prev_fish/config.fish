# Language settings
set -Ux LANG "en_US.UTF-8"
set -Ux LANGUAGE "en"
set -Ux LC_ALL "en_US.UTF-8"

# SOPS Age Key
set -Ux SOPS_AGE_KEY_FILE "$HOME/.config/sops/age/keys.txt"

# ZSH Replacement
set -Ux ZMETA "$HOME/.zmeta"
set -Ux ZDOTDIR "$HOME/.zmeta"
set -Ux ZINIT_HOME "$HOME/.zmeta/zinit"

# XDG Directories
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_RUNTIME_DIR "$HOME/.xdg"

# Go Path
set -Ux GOPATH "$HOME/go"
set -Ux fish_user_paths $GOPATH/bin $fish_user_paths

# Browser for macOS
if string match -q "*darwin*" (uname)
    set -Ux BROWSER "open"
end

# Editor and Pager
set -Ux EDITOR "vim"
set -Ux VISUAL "vim"
set -Ux PAGER "less"

# Less Input Preprocessor
if test -z "$LESSOPEN" && command -q lesspipe
    set -Ux LESSOPEN "| /usr/bin/env lesspipe %s 2>&-"
end

# pyenv Initialization
if type -q pyenv-virtualenv-init
    pyenv virtualenv-init | source
end

# SSH and GPG agent settings
set -Ux GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye > /dev/null
set -Ux SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

# direnv
eval (direnv hook fish)

# Custom Functions for Fish
function error
    echo (set_color red)[ERROR](set_color normal): (set_color yellow)$argv(set_color normal)
    return 1
end

function info
    echo (set_color blue)[INFO](set_color normal): (set_color cyan)$argv(set_color normal)
end

# Set initial working directory
set -Ux IWD (pwd)
alias iwd='echo $IWD'
alias cdiwd='cd "$IWD"'

# Fabric bootstrap include
if test -f "/home/lclose/.config/fabric/fabric-bootstrap.inc"
    source "/home/lclose/.config/fabric/fabric-bootstrap.inc"
end


source ~/.config/fish/aliases.fish
oh-my-posh init fish --config ~/.poshthemes/custom-pure.omp.json | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/lclose/.cache/lm-studio/bin
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
