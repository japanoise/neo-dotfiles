#!/bin/sh

venvname=".venv-thing"
venvpath="$PWD/$venvname"

if gitroot="$(git rev-parse --show-toplevel)"
then
    venvpath="$gitroot/$venvname"
fi

if ! [ -d "$venvpath" ]
then
    # venv doesn't exist, create it
    python -m venv "$venvpath"
    if [ -n "$gitroot" ]
    then
        mkdir -p "$gitroot/.git/info/"
        echo "/$venvname" >> "$gitroot/.git/info/exclude"
    fi
fi

echo "source \"$venvpath/bin/activate\""
