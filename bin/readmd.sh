#!/bin/sh
while [ -n "$1" ]
do
    base=$(basename -s.md "$1")

    # Guess the title based on the first line being an h1
    title=$(sed -n -e 's/^# \(.*\)/\1/p;q' "$1")
    if [ -z "$title" ]
    then
        # Welp, we tried our best
        title="$base"
    fi

    # Convert to a markdown file and open in firefox if successful
    outfile="/tmp/$base-$(date +%s).html"
    if pandoc --toc --standalone --metadata title="$title" < "$1" > "$outfile"
    then
        if [ "$(uname)" = "Darwin" ]
        then
            # Fucking macos
            /Applications/Firefox.app/Contents/MacOS/firefox "$outfile"
        else
            firefox "$outfile"
        fi
    fi

    # Loop
    shift
done
