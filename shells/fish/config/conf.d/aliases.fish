# Basic aliases for fish shell - no loops, no automatic sourcing

# Safety
abbr -a cp 'cp -i'
abbr -a mv 'mv -i'
abbr -a rm 'rm -i'

# Navigation
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'

# Git shortcuts
abbr -a g 'git'
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gd 'git diff'
abbr -a gl 'git log --oneline'

# List improvements
if type -q eza
    abbr -a ls 'eza'
    abbr -a ll 'eza -l'
    abbr -a la 'eza -la'
else if type -q exa
    abbr -a ls 'exa'
    abbr -a ll 'exa -l'
    abbr -a la 'exa -la'
else
    abbr -a ll 'ls -la'
    abbr -a la 'ls -A'
end

# Cat improvements
if type -q bat
    abbr -a cat 'bat'
end

# Convenience
abbr -a c 'clear'
abbr -a reload 'source ~/.config/fish/config.fish'
