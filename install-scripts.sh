#!/bin/sh
mkdir -p "$HOME/bin"
find "$PWD"/bin -type f -print0 | xargs -0 -I SCRIPT ln -f -s SCRIPT "$HOME"/bin
