export ZMETA=~/.zmeta
[[ -f ~/.zshenv ]] && mv ~/.zshenv ~/.zshenv.bak
ln -s $ZMETA/.zshenv ~/.zshenv
