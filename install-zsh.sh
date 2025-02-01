#!/bin/sh
which zsh || exit 1
mkdir -p "$HOME/.zfunctions"
git clone https://github.com/sindresorhus/pure "$HOME/builds/pure"
ln -s "$HOME/builds/pure/pure.zsh" "$HOME/.zfunctions/prompt_pure_setup"
ln -s "$HOME/builds/pure/async.zsh" "$HOME/.zfunctions/async"
ln -s "$PWD/dotfiles/.zshrc" "$HOME/.zshrc"
echo "Changing shell to $(which zsh) (password required)"
chsh -s "$(which zsh)"

