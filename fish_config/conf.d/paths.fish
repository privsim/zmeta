# Path configuration optimized for Fish shell
# Using fish_add_path which handles duplicates and prepends to PATH

# ============ Personal Directories ============
fish_add_path $HOME/bin
fish_add_path $HOME/sbin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/sbin

# ============ Development Tools ============
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.docker/bin
fish_add_path $HOME/.npm-global/bin
fish_add_path $HOME/.yarn/bin
fish_add_path $HOME/go/bin

# ============ System Directories ============
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/local/bin
fish_add_path /opt/local/sbin
fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin
fish_add_path /usr/bin
fish_add_path /bin

# ============ Custom Tools ============
fish_add_path $HOME/.arkade/bin
fish_add_path $HOME/.zmeta/bin

# ============ Python ============
if test -d $HOME/.pyenv/bin
    fish_add_path $HOME/.pyenv/bin
end

# ============ Node.js ============
if test -d $HOME/.nvm
    fish_add_path $HOME/.nvm/versions/node/(node -v)/bin
end