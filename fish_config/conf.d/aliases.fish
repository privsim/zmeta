# ============ System Utilities ============
# Safety first
abbr -a cp 'cp -i'
abbr -a mv 'mv -i'
abbr -a rm 'rm -i'
abbr -a ping 'ping -c 5'

# Navigation
abbr -a .. 'cd ..'
abbr -a ... 'cd ../../'
abbr -a .... 'cd ../../../'
abbr -a ..... 'cd ../../../../'

# Fix common typos
abbr -a quit 'exit'
abbr -a cd.. 'cd ..'

# ============ Security Tools ============
abbr -a ea "cat /proc/sys/kernel/random/entropy_avail"
abbr -a 64AN 'openssl rand -base64 48 | tr -d "+/=" | cut -c -64 | pbcopy'
abbr -a 64ANU "tr -dc 'A-Za-z0-9' < /dev/urandom | head -c64 | pbcopy"
abbr -a hashpass 'python ~/.zmeta/bin/argon2_hashgen.py'

# ============ File Operations ============
# Tar operations
abbr -a tarls "tar -tvf"
abbr -a untar "tar -xf"

# Find operations
abbr -a fd 'find . -type d -name'
abbr -a ff 'find . -type f -name'

# ============ Disk Usage ============
abbr -a biggest 'du -s ./* | sort -nr | awk \'{print $2}\' | xargs du -sh'
abbr -a dux 'du -x --max-depth=1 | sort -n'
abbr -a dud 'du -d 1 -h'
abbr -a duf 'du -sh *'

# ============ Network Tools ============
abbr -a listening 'sudo netstat -anp tcp | grep "LISTEN"'
abbr -a psg 'ps aux | grep -v grep | grep -i'
abbr -a nsl 'netstat -taupn | grep LISTEN'
abbr -a nsg 'netstat -taupn | grep -i'
abbr -a ns 'netstat -taupn'

# ============ Process Management ============
abbr -a rss "ps aux | sort -n -k 4"
abbr -a gg 'sudo bpytop'
abbr -a wth 'sudo dmesg'

# ============ Development Tools ============
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

# Python
abbr -a python 'python3'
abbr -a pip 'pip3'

# ============ Text Processing ============
# URL encode/decode
abbr -a urldecode 'python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
abbr -a urlencode 'python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

# Better alternatives
abbr -a cat 'bat'
abbr -a kit 'bat -pp'
abbr -a ls 'eza'
abbr -a ll 'eza -l'
abbr -a la 'eza -la'
abbr -a q 'eza -al --sort=accessed --time=accessed --group-directories-first --time-style=long-iso'

# ============ Time and Date ============
abbr -a timestamp "date '+%Y-%m-%d %H:%M:%S'"
abbr -a datestamp "date '+%Y-%m-%d'"

# ============ Convenience ============
abbr -a c 'clear'
abbr -a ee 'exit'
abbr -a qq 'reset'
abbr -a please 'sudo $(history | tail -n1 | cut -c8-)'

# ============ History Management ============
abbr -a history-stat "history | awk '{print \$2}' | sort | uniq -c | sort -n -r | head" 