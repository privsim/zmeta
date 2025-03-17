#! /usr/bin/env bash
# aliases and functions

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function tolower () { echo "$*" | tr '[:upper:]' '[:lower:]'; }
function toupper () { echo "$*" | tr '[:lower:]' '[:upper:]'; }


alias mvncd='cd ../../../../../../..'
alias mvn='mvn -q'

alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstopall='docker stop $(docker ps -aq)'
alias drmall='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'
alias drmiall='docker rmi -f $(docker images -q)'
alias drmvall='docker volume rm $(docker volume ls -q)'

function best() { agrep -B "$@" /usr/share/dict/words; }

alias p='python3'
alias ut='python3 -m unittest'
alias be='bundle exec'
alias beep='echo -n ""'
alias utime='date -r'

alias rmthumbs="find -E . -regex '.*\.(jpg|gif|png)' -a -size -7k -exec rm '{}' ';'"

alias ntpstat='ntpdc -c peers'
alias epoch='date -r'
alias ch='choice'
alias randompass='openssl rand -base64 12'

alias branch='git branch'
alias co='git checkout'
alias commit='git commit'
alias merge='git merge'
alias pull='git pull'
alias push='git push'
alias status='git status'
alias git_push_this_branch='git push origin $(git branch --show-current)'
function git_delete_branch () {
    git branch -d "$1" && git push origin --delete "$1"
}


function timer { (sleep $((60 * $*)); echo -ne \\a\\a\\a\\a) & }
function minutes { (sleep $((60 * $*)); echo -ne \\a\\a\\a\\a) & }
function seconds { (sleep "$@"; echo -ne \\a\\a\\a\\a) & }
function docxgrep () {
    for i in "${@:2}"
    do
        if unzip -p "$i" | sed -e 's/<[^>]\{1,\}>//g; s/[^[:print:]]\{1,\}//g' | grep "$1" > /dev/null
        then
            echo "$i"
        fi
    done
}

export EDITOR=vim

alias rss='ps aux | sort -n -k 4'
alias c='clear'
alias cp='cp -i'
function gifinfo () {
    giftopnm -verbose "$@" > /dev/null
}
alias gv='ghostview -magstep -4'
alias h='history'
alias j='jobs'
function jpginfo () {
    djpeg -fast -gif "$@" | giftopnm -verbose > /dev/null
}
alias m='less -ReF'
alias more='less -ReF'
alias mv='mv -i'
alias now='date "+%Y%m%d%H%M%S"'
alias t='tail'
alias today='date "+%Y-%m-%d"'

function shuf () {
    sort -R "$@" | head -n 1
}

# Function to capture errors from logs across all Docker containers
capture_docker_errors() {
    for container_id in $(docker ps -q); do
        echo "Errors from container $container_id:"
        docker logs $container_id 2>&1 | grep "ERROR"
        echo "----------------------------------"
    done
}

