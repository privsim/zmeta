# Set Actual
export ZMETA="$HOME/.zmeta"

zstyle ':znap:*' repos-dir ~/.zmeta/zsh-snap/repos
source $ZMETA/zsh-snap/znap.zsh

# Set Zsh options needed for your scripts, or ones not set by your plugins.
setopt INTERACTIVE_COMMENTS          # Allow comments in interactive sessions.
#setopt COMBINING_CHARS              # Combine zero-length punctuation characters (accents) into one.
setopt RC_QUOTES                     # Allow 'Ender''s Game' instead of 'Ender'\''s Game'.
unsetopt MAIL_WARNING                # Don't print warning if a mail file has been accessed.

# Job options
setopt LONG_LIST_JOBS                # More verbose listing of jobs.
setopt AUTO_RESUME                   # Try to resume existing job before creating a new one.
setopt NOTIFY                        # Report status of background jobs immediately.
unsetopt BG_NICE                     # Don't run background jobs at a lower priority.
unsetopt HUP                         # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS                  # Don't report on jobs when shell exit.
unsetopt beep nomatch                # Don't beep on failed completion.
setopt autocd extendedglob notify    # Allow autocd and extended globbing.

# Set any environment variables or keybindings related to your plugins or session.
SHELL_SESSIONS_DISABLE=1
KEYTIMEOUT=1

bindkey -v

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000


export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTORY_IGNORE="(ls|bg|fg|pwd|q|p|exit|cd ..|cd -|pushd|popd)"

export ZSH_CACHE_DIR="$ZMETA/cache"
export FIGNORE=".DS_Store"
export GLOBIGNORE=".DS_Store"

export LESS="${LESS:--g -i -M -R -S -w -z-4}"

#export KUBECONFIG="~/.kube/t3/config"
#export KUBECONFIG="~/.kube/sbc/config:${KUBECONFIG}"

# Download Znap, if it's not there yet.
[[ -f $ZMETA/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git $ZMETA/zsh-snap



znap source privsim/OA 


[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"


#Enable autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh


#Enable p
[ -f $ZMETA/functions/p ] && source $ZMETA/functions/p



# Load zmeta bin if it exists
[ -f $ZMETA/bin ] && PATH="$ZMETA/bin:$PATH"

# set PATH so it includes user's private bin if it exists
 [ -f "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# set PATH so it includes user's private bin if it exists
[ -f "$HOME/.local/bin" ] &&  PATH="$HOME/.local/bin:$PATH"

# set PATH so it includes user's arkade bin if it exists
[ -f "$HOME/.arkade/bin" ] &&  PATH="$HOME/.arkade/bin:$PATH"

# set PATH so it includes user's cargo bin if it exists
[ -f "$HOME/.cargo/bin" ] &&  PATH="$HOME/.cargo/bin:$PATH"



mkd () {
    mkdir -p "$@" && cd "$@"
}

batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
}

hist()
{
        [[ -z ${1} ]] && echo "No arguments given"
        history 1 | grep ${1}
}


# Easier extraction of compressed files
ex () {
       if [ -f $1 ] ; then
           case $1 in
               *.tar.bz2)   tar xvjf $1    ;;
               *.tar.gz)    tar xvzf $1    ;;
               *.tar.xz)    tar xvJf $1    ;;
               *.bz2)       bunzip2 $1     ;;
               *.rar)       unrar x $1     ;;
               *.gz)        gunzip $1      ;;
               *.tar)       tar xvf $1     ;;
               *.tbz2)      tar xvjf $1    ;;
               *.tgz)       tar xvzf $1    ;;
               *.zip)       unzip $1       ;;
               *.Z)         uncompress $1  ;;
               *.7z)        7z x $1        ;;
               *.xz)        unxz $1        ;;
               *.exe)       cabextract $1  ;;
               *)           echo "\`$1': unrecognized file compression" ;;
           esac
       else
           echo "\`$1' is not a valid file"
       fi
    }





# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/lclose/.local/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lclose/.local/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/lclose/.local/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/lclose/.local/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"
#export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
#export PATH="/Users/$USER/platform-tools:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

znap source marlonrichert/zsh-hist


ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
# znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-history-substring-search



##
# Load your plugins with `znap source`.
#
#znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# ...or to load only those parts of Oh-My-Zsh or Prezto that you really need:
znap source sorin-ionescu/prezto modules/{environment,history}

znap source ohmyzsh/ohmyzsh plugins/git
znap source ohmyzsh/ohmyzsh plugins/command-not-found
znap source ohmyzsh/ohmyzsh plugins/docker
znap source ohmyzsh/ohmyzsh plugins/docker-compose
znap source ohmyzsh/ohmyzsh plugins/kubectl
znap source ohmyzsh/ohmyzsh plugins/magic-enter
znap source ohmyzsh/ohmyzsh plugins/kubectx
znap source ohmyzsh/ohmyzsh plugins/terraform
znap source ohmyzsh/ohmyzsh plugins/ansible
znap source ohmyzsh/ohmyzsh plugins/virtualenv
znap source ohmyzsh/ohmyzsh lib/completion.zsh
znap source ohmyzsh/ohmyzsh lib/correction.zsh
znap source ohmyzsh/ohmyzsh lib/clipboard.zsh

znap source zdharma-continuum/fast-syntax-highlighting
znap source zsh-users/zsh-completions


# Load distribution-specific aliases
[ -f $ZMETA/aliases-"$(uname)" ] && source $ZMETA/aliases-"$(uname)"

# Load *nix aliases
[ -f $ZMETA/aliases.zsh ] && source $ZMETA/aliases.zsh


znap function _kubectl kubectl           'eval "$( kubectl completion zsh)"'
compctl -K    _kubectl kubectl

znap function _pyenv pyenv              'eval "$( pyenv init - --no-rehash )"'
compctl -K    _pyenv pyenv

znap function _pip_completion pip       'eval "$( pip completion --zsh )"'
compctl -K    _pip_completion pip

znap function _python_argcomplete pipx  'eval "$( register-python-argcomplete pipx  )"'
complete -o nospace -o default -o bashdefault \
           -F _python_argcomplete pipx

znap function _pipenv pipenv            'eval "$( pipenv --completion )"'
compdef       _pipenv pipenv

# If we gotta duck, lets get it out of the way first thing
[ -f "${ZMETA}/ascii/ducky.txt"  ] && neofetch --source "${ZMETA}/ascii/ducky.txt" -L
