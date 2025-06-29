# Aliases

alias ea="cat /proc/sys/kernel/random/entropy_avail"
alias 64AN='openssl rand -base64 48 | tr -d "+/=" | cut -c -64 | pbcopy'
alias 64ANU="tr -dc 'A-Za-z0-9' < /dev/urandom | head -c64 | pbcopy"
alias hashpass='python ~/.zmeta/bin/argon2_hashgen.py'

# Mask built-ins with better defaults
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ping='ping -c 5'
alias vi='vim'

# Navigation and Quick Access
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Fix typos
alias quit='exit'
alias cd..='cd ..'

# Tar commands
alias tarls="tar -tvf"
alias untar="tar -xf"

# Date/Time
alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"

# Find commands
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# Disk Usage
alias biggest='du -s ./* | sort -nr | awk \'{print $2}\' | xargs du -sh'
alias dux='du -x --max-depth=1 | sort -n'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# URL encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

# History commands
alias history-stat="history | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias history="history"

# System checks and utilities
alias listening='sudo netstat -anp tcp | grep "LISTEN"'
alias psg='ps aux | grep -v grep | grep -i'
alias nsl='netstat -taupn | grep LISTEN'
alias nsg='netstat -taupn | grep -i'
alias ns='netstat -taupn'
alias rss="ps aux | sort -n -k 4"
alias c='clear'
alias please='sudo $(history | tail -n1 | cut -c8-)'
alias gg='sudo bpytop'
alias wth='sudo dmesg'
alias python='python3'

# Miscellaneous
alias ee='exit'
alias qq='reset'
alias cat='bat'
alias kit='bat -pp'
#alias status-all='sudo systemctl list-unit-files'
#alias status='sudo systemctl status '
alias q='eza -al --sort=accessed --time=accessed --group-directories-first --time-style=long-iso'
alias ch='choice'
