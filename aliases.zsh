#
# aliases
#

# suffix aliases (ie: `cd ..4`)
#alias -g H='| head'
#alias -g T='| tail'
#alias -g G='| grep -E'
#alias -g S='| sort'
#alias -g L='| less'
#alias -g M='| more'
#alias -g ..2='../..'
#alias -g ..3='../../..'
#alias -g ..4='../../../..'
#alias -g ..5='../../../../..'
#alias -g ..6='../../../../../..'
#alias -g ..7='../../../../../../..'
#alias -g ..8='../../../../../../../..'
#alias -g ..9='../../../../../../../../..'
#alias -g ...='../..'
#alias -g ....='../../..'
#alias -g .....='../../../..'
#alias -g ......='../../../../..'
#
## single character shortcuts - be sparing!
#alias d='dirs -v'
#alias l="ls -ltrhsa"
#alias ls="ls -lha"

alias ea="cat /proc/sys/kernel/random/entropy_avail"
alias 64AN='openssl rand -base64 48 | tr -d '+/=' | cut -c -64 | pbcopy'
alias 64ANU='tr -dc 'A-Za-z0-9' < /dev/urandom | head -c64 | pbcopy'


# mask built-ins with better defaults
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ping='ping -c 5'
alias vi=vim

# more ways to ls
#alias ll='ls -lh'
#alias la='ls -lAh'
#alias ldot='ls -ld .*'

# fast
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# fix typos
alias quit='exit'
alias cd..='cd ..'

# tar
alias tarls="tar -tvf"
alias untar="tar -xf"

# date/time
alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# disk usage
alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
alias dux='du -x --max-depth=1 | sort -n'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# history
# list the ten most used commands
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias history="fc -li"

alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'

# echo things
alias print-fpath='for fp in $fpath; do echo $fp; done; unset fp'
alias print-path='echo $PATH | tr ":" "\n"'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

# auto-orient images based on exif tags
alias autorotate="jhead -autorot"

# set initial working directory
IWD=${IWD:-PWD}
alias iwd='echo $IWD'
alias cdiwd='cd "$IWD"'

# dotfiles
alias dotf='cd "$DOTFILES"'
alias dotfed='cd "$DOTFILES" && ${VISUAL:-${EDITOR:-vim}} .'

# python
alias py2='python2'
alias py3='python3'
alias py='python3'
alias pip2update="pip2 list --outdated | cut -d ' ' -f1 | xargs -n1 pip2 install -U"
alias pip3update="pip3 list --outdated | cut -d ' ' -f1 | xargs -n1 pip3 install -U"
alias pyfind='find . -name "*.py"'
alias pygrep='grep --include="*.py"'
alias pyva="source .venv/bin/activate"

# misc
alias ee='exit'
alias qq='reset'
alias tt="exa -bghHliSS"
alias history="history 0"
alias ll='lsd -ltr'
alias la='lsd -la'
alias l='lsd -lS'
alias mv='mv -i'
alias cp='cp -i'
alias q='exa -a -l --sort=modified'
alias listening='sudo netstat -anp tcp | grep "LISTEN"'
alias psg='ps aux | grep -v grep | grep -i'
alias nsl='netstat -taupn | grep LISTEN'
alias nsg='netstat -taupn | grep -i'
alias ns='netstat -taupn'
alias rss="ps aux | sort -n -k 4"
alias c='clear'
alias ch='choices'
alias please='sudo $(fc -ln -1)'
alias t='ls -lt'
alias b='ls -ltr'
alias gg='sudo bpytop'
alias ct='cht.sh --shell'
alias y='cht.sh '
alias wth='sudo dmesg'
alias python='python3'
alias m='mdcat'
alias fast='speedtest'

