# Abbreviations for common commands
# These expand as you type, unlike aliases

# Git abbreviations
abbr -a gco git checkout
abbr -a gcm git commit -m
abbr -a gpl git pull
abbr -a gps git push
abbr -a gst git status
abbr -a gaa git add -A
abbr -a glo git log --oneline --graph

# System abbreviations 
abbr -a l ls -lah
abbr -a e $EDITOR
abbr -a md mkdir -p
abbr -a rd rmdir
abbr -a c clear

# Directory navigation
abbr -a ~ cd ~
abbr -a .2 ../..
abbr -a .3 ../../..
abbr -a .4 ../../../..

# Homebrew
abbr -a bi brew install
abbr -a bci brew cask install
abbr -a bup brew update
abbr -a bug brew upgrade