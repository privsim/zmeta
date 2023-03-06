umask 077
autoload -U colors && colors
fpath+=~/.complete


# macos zsh-autocomplete
if [[ $OSTYPE == darwin ]]; then
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
#    autoload -Uz compinit
#    compinit
  fi
fi

# linuxbrew zsh-autocomplete
[[ -f /home/linuxbrew/.linuxbrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] &&
  source /home/linuxbrew/.linuxbrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

zstyle ':znap:*' repos-dir ~/.zmeta/zsh-snap/repos
source $ZMETA/zsh-snap/znap.zsh

# Set Zsh options needed for your scripts, or ones not set by your plugins.
setopt INTERACTIVE_COMMENTS # Allow comments in interactive sessions.
#setopt COMBINING_CHARS              # Combine zero-length punctuation characters (accents) into one.
setopt RC_QUOTES      # Allow 'Ender''s Game' instead of 'Ender'\''s Game'.
unsetopt MAIL_WARNING # Don't print warning if a mail file has been accessed.

# Job options
setopt LONG_LIST_JOBS # More verbose listing of jobs.
setopt AUTO_RESUME    # Try to resume existing job before creating a new one.
setopt NOTIFY         # Report status of background jobs immediately.
unsetopt BG_NICE      # Don't run background jobs at a lower priority.
unsetopt HUP          # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS   # Don't report on jobs when shell exit.
unsetopt beep nomatch # Don't beep on failed completion.

#zstyle ":completion:*" auto-description "specify %d"
#zstyle ":completion:*" cache-path "${HOME}/.zmeta/.zsh_cache"
#zstyle ":completion:*" completer _expand _complete _correct _approximate
#zstyle ":completion:*" file-sort modification reverse
#zstyle ":completion:*" format "completing %d"
#zstyle ":completion:*" group-name ""
#zstyle ":completion:*" hosts off
#zstyle ":completion:*" list-colors "=(#b) #([0-9]#)*=36=31"
#zstyle ":completion:*" menu select=long-list select=0
#zstyle ":completion:*" use-cache on
#zstyle ":completion:*" verbose yes
#zstyle ":completion:*:kill:*" command "ps -u ${USER} -o pid,%cpu,tty,cputime,cmd"

#setopt autocd
#setopt clobber
#setopt complete_aliases
#setopt extended_glob
#setopt interactive_comments
#setopt nonomatch
#setopt pushd_ignore_dups
#
#DISABLE_MAGIC_FUNCTIONS=true
#
# ZSH History Options
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
setopt appendhistory
setopt extended_history

# Set any environment variables or keybindings related to your plugins or session.
SHELL_SESSIONS_DISABLE=1
KEYTIMEOUT=1

bindkey -v

export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTORY_IGNORE="(ls|bg|fg|pwd|exit|cd ..)"
export ZSH_CACHE_DIR="$ZMETA/cache"
export FIGNORE=".DS_Store"
export GLOBIGNORE=".DS_Store"

export LESS="${LESS:--g -i -M -R -S -w -z-4}"

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

#Enable various
[ -f $ZMETA/functions/various ] && source $ZMETA/functions/various


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
# set PATH so it includes user's arkade bin if it exists
if [ -d "$HOME/.arkade/bin" ]; then
  PATH="$HOME/.arkade/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes user's zmeta bin if it exists
if [ -d "$HOME/.zmeta/bin" ]; then
  PATH="$HOME/.zmeta/bin:$PATH"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

znap source ohmyzsh/ohmyzsh plugins/git
znap source ohmyzsh/ohmyzsh plugins/command-not-found
znap source ohmyzsh/ohmyzsh plugins/docker
znap source ohmyzsh/ohmyzsh plugins/docker-compose
znap source ohmyzsh/ohmyzsh plugins/kubectl
znap source ohmyzsh/ohmyzsh plugins/kubectx
znap source ohmyzsh/ohmyzsh plugins/terraform
znap source ohmyzsh/ohmyzsh plugins/ansible
znap source ohmyzsh/ohmyzsh plugins/virtualenv

# Load distribution-specific aliases
[ -f $ZMETA/aliases-"$(uname)" ] && source $ZMETA/aliases-"$(uname)"

# Load *nix aliases
[ -f $ZMETA/aliases.zsh ] && source $ZMETA/aliases.zsh

znap function _kubectl kubectl 'eval "$( kubectl completion zsh)"'
compctl -K _kubectl kubectl

znap function _pyenv pyenv 'eval "$( pyenv init - --no-rehash )"'
compctl -K _pyenv pyenv

znap function _pip_completion pip 'eval "$( pip completion --zsh )"'
compctl -K _pip_completion pip

znap function _python_argcomplete pipx 'eval "$( register-python-argcomplete pipx  )"'
complete -o nospace -o default -o bashdefault \
  -F _python_argcomplete pipx

znap function _pipenv pipenv 'eval "$( pipenv --completion )"'
compdef _pipenv pipenv

# If we gotta duck, lets get it out of the way first thing
[ -f "${ZMETA}/ascii/ducky.txt" ] && neofetch --source "${ZMETA}/ascii/ducky.txt" -L

# linuxbrew
[ -f /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# linuxbrew autojunp
 [ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh

# linuxbrew zsh-vi-mode
[ -f /home/linuxbrew/.linuxbrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ] && source /home/linuxbrew/.linuxbrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# linuxbrew zsh-fast-syntax
[ -f /home/linuxbrew/.linuxbrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source /home/linuxbrew/.linuxbrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# linuxbrew zsh-autopair
[ -f /home/linuxbrew/.linuxbrew/share/zsh-autopair/autopair.zsh ] && source /home/linuxbrew/.linuxbrew/share/zsh-autopair/autopair.zsh

# linuxbrew zsh-autosuggestions
[ -f /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# linuxbrew zsh-history-substring-search
[ -f /home/linuxbrew/.linuxbrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source /home/linuxbrew/.linuxbrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# linuxbrew zsh-syntax-highlighting
[ -f /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# brew autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# brew zsh-vi-mode
[ -f /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ] && source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# brew zsh-fast-syntax
[ -f /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# brew zsh-autopair
[ -f /opt/homebrew/share/zsh-autopair/autopair.zsh ] && source /opt/homebrew/share/zsh-autopair/autopair.zsh

# brew zsh-autosuggestions
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# brew zsh-history-substring-search
[ -f /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# brew zsh-syntax-highlighting
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# linuxbrew zsh-syntax-highlighting
[ -f /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#fpath+=(~/.zmeta/cache/completions:$fpath)
#if [[ $OSTYPE == darwin ]]; then
#  autoload -U compinit && compinit
#fi

[ -f /Users/$USER/.docker/init-zsh.sh ] && source /Users/$USER/.docker/init-zsh.sh || true 

#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
#gpg-connect-agent updatestartuptty /bye > /dev/null
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

autoload -Uz compinit
compinit
