umask 077
autoload -U colors && colors
autoload -U compinit && compinit

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


# Set any environment variables or keybindings related to your plugins or session.
SHELL_SESSIONS_DISABLE=1
KEYTIMEOUT=1

bindkey -v

HISTFILE=~/.zsh_history
HISTSIZE=10000


export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export EDITOR=vim
export LANG="en_US.UTF-8"
#export HISTORY_IGNORE="(ls|bg|fg|pwd|q|p|exit|cd ..|cd -|pushd|popd)"

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


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi
# set PATH so it includes user's arkade bin if it exists
if [ -d "$HOME/.arkade/bin" ] ; then
    PATH="$HOME/.arkade/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes user's zmeta bin if it exists
if [ -d "$HOME/.zmeta/bin" ] ; then
    PATH="$HOME/.zmeta/bin:$PATH"
fi




mkd () {
    mkdir -p "$@" && cd "$@"
}

batdiff() 
{
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




function convert_secs {
  ((h=${1}/3600)) ; ((m=(${1}%3600)/60)) ; ((s=${1}%60))
  printf "%02d:%02d:%02d\n" ${h} ${m} ${s} }

function dump_arp {
  ${ROOT} tcpdump -eni ${NETWORK} -w arp-${NOW}.pcap \
    "ether proto 0x0806" }

function dump_icmp {
  ${ROOT} tcpdump -ni ${NETWORK} -w icmp-${NOW}.pcap \
    "icmp" }

function dump_pflog {
  ${ROOT} tcpdump -ni pflog0 -w pflog-${NOW}.pcap \
    "not icmp6 and not host ff02::16 and not host ff02::d" }

function dump_syn {
  ${ROOT} tcpdump -ni ${NETWORK} -w syn-${NOW}.pcap \
    "tcp[13] & 2 != 0" }

function dump_udp {
  ${ROOT} tcpdump -ni ${NETWORK} -w udp-${NOW}.pcap \
    "udp and not port 443" }

function dump_dns {
  tshark -Y "dns.flags.response == 1" -Tfields \
    -e frame.time_delta -e dns.qry.name -e dns.a \
      -Eseparator=, }

function dump_http {
  tshark -Y "http.request or http.response" -Tfields \
    -e ip.dst -e http.request.full_uri -e http.request.method \
      -e http.response.code -e http.response.phrase \
        -Eseparator=, }

function dump_ssl {
  tshark -Y "ssl.handshake.certificate" -Tfields \
    -e ip.src -e x509sat.uTF8String -e x509sat.printableString \
      -e x509sat.universalString -e x509sat.IA5String \
        -e x509sat.teletexString \
          -Eseparator=, }

function e {  # appx bits of entropy: e <chars> <length>
  awk -v c=${1} -v l=${2} "BEGIN { print log(c^l)/log(2) }" }

function f {
  find . -iname "*${1}*" }

function fd {
  find . -iname "*${1}*" -type d }

function gas {  # get CIDRs for AS number
  whois -h whois.radb.net '!g'${1} }

function myip {
  curl -sq "https://icanhazip.com/" }

function pdf {
  mupdf -r 180 -C FDF6E3 "${1}" }

function png2jpg {
  for png in $(find . -type f -name "*.png") ; do
    image="${png%.*}"
    convert "${image}.png" "${image}.jpg" ; done }

function nonlocal () {
  egrep -ve "^#|^255.255.255.255|^127.|^0.|^::1|^ff..::|^fe80::" "${1}" | \
    egrep -e "[1,2]|::"
}

function rand {
  for item in '01' \
    '[:digit:]' '[:upper:]' \
    '[:xdigit:]' '[:alnum:]' '[:graph:]' ; do \
      tr -dc "${item}" < /dev/urandom | \
      fold -w 80 | head -n 3 | \
      sed "-es/./ /"{1..80..20} ; done }

function rand_mac {
  openssl rand -hex 6 | sed "s/\(..\)/\1:/g; s/.$//" }

function resize_ff {
  xdotool windowsize \
    $(xdotool search --name firefox | tail -n1) 1366 768 }

function reveal {
  output=$(echo "${1}" | rev | cut -c16- | rev)
  gpg --decrypt --output ${output} "${1}" \
    && echo "${1} -> ${output}" }

function rs {
  rsync --verbose --archive --human-readable \
    --progress --stats --ipv4 --compress \
    --log-file=$(mktemp) "${@}" }

#function secret {  # list preferred id last
#  output="${HOME}/$(basename ${1}).$(date +%F).enc"
#  gpg --encrypt --armor \
#    --output ${output} \
#    -r 0xFF3E7D88647EBCDB \
#    -r github@duh.to \
#    "${1}" && echo "${1} -> ${output}" }

function secret () {
        output=~/"${1}".$(date +%s).enc
        gpg --encrypt --armor --output ${output} -r 0x0000 -r 0x0001 -r 0x0002 "${1}" && echo "${1} -> ${output}"
}

function reveal () {
        output=$(echo "${1}" | rev | cut -c16- | rev)
        gpg --decrypt --output ${output} "${1}" && echo "${1} -> ${output}"
}

function srl {
  doas cu -r -s 115200 -l cuaU0 2>/dev/null || \
    sudo minicom -D /dev/ttyUSB0 2>/dev/null || \
      printf "disconnected\n" }

function top_history {
  history 1 | awk '{CMD[$2]++;count++;}END {
    for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
      column -c3 -s " " -t | sort -nr | nl |  head -n25 }

function download () {
  curl -O ${DOWNLOAD}/"${@}" }

function upload {
   curl -sq -F "file=@${@}" ${UPLOAD} | \
     grep -q "Saved" && printf "Uploaded ${@}\n" }

function vpn {
  ssh -C -N -L 5555:127.0.0.1:8118 vpn }

#function zshaddhistory {
#  whence "${${(z)1}[1]}" >| /dev/null || return 1
#  local line cmd
#  line=${1%%$'\n'}
#  cmd=${line%% *}
#  [[ ${#line} -ge 5 \
#    && ${cmd} != (apm|apt-cache|base64|bzip2|cal|calc|cat|cd|chmod|convert|cp|curl|cvs|date|df|dig|disklabel|dmesg|doas|download|du|e|egrep|enc|ent|exiftool|f|fdisk|feh|ffplay|file|find|firejail|gimp|git|gpg|grep|hdiutil|head|hostname|ifconfig|kill|less|libreoffice|lp|ls|mail|make|man|mkdir|mnt|mount|mpv|mv|nc|openssl|patch|pdf|pdfinfo|pgrep|ping|pkg_info|pkill|ps|pylint|rcctl|rm|rsync|scp|scrot|set|sha256|secret|sort|srm|ssh|ssh-keygen|startx|stat|strip|sudo|sysctl|tar|tmux|top|umount|uname|unzip|upload|uptime|useradd|vlc|vi|vim|wc|wget|which|whoami|whois|wireshark|xclip|xxd|youtube-dl|ykman|yt|./pwd.sh|./purse.sh)
#  ]]
#}




test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

znap source marlonrichert/zsh-hist

##
# Load your plugins with `znap source`.
#
#znap source marlonrichert/zsh-autocomplete
znap source marlonrichert/zsh-edit

# ...or to load only those parts of Oh-My-Zsh or Prezto that you really need:
#znap source sorin-ionescu/prezto modules/{environment,history}

znap source ohmyzsh/ohmyzsh plugins/git
znap source ohmyzsh/ohmyzsh plugins/command-not-found
znap source ohmyzsh/ohmyzsh plugins/docker
znap source ohmyzsh/ohmyzsh plugins/docker-compose
znap source ohmyzsh/ohmyzsh plugins/kubectl
znap source ohmyzsh/ohmyzsh plugins/kubectx
znap source ohmyzsh/ohmyzsh plugins/terraform
znap source ohmyzsh/ohmyzsh plugins/ansible
znap source ohmyzsh/ohmyzsh plugins/virtualenv
znap source ohmyzsh/ohmyzsh lib/completion.zsh
znap source ohmyzsh/ohmyzsh lib/correction.zsh
znap source ohmyzsh/ohmyzsh lib/clipboard.zsh
znap source ohmyzsh/ohmyzsh lib/history.zsh

znap source zdharma-continuum/fast-syntax-highlighting


znap source zsh-users/zsh-completions
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-history-substring-search
znap source zsh-users/zsh-syntax-highlighting

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

#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
#gpg-connect-agent updatestartuptty /bye > /dev/null

