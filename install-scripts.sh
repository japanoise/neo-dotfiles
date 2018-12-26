#!/bin/sh
find "$PWD"/bin -type f -print0 | xargs -0 -I SCRIPT ln -v -f -s SCRIPT "$HOME"/bin
