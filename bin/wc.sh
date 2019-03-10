#!/bin/sh
twc=0
n=0
for chapter in [0-9]*.md
do
    wc=$(sed -e '1d' < "$chapter" | wc -w - | sed -e 's/\([^ ]*\) .*/\1/')
    twc=$((twc + wc))
    n=$((n + 1))
    printf "$chapter:\t%i\n" "$wc"
done
printf "\n  total:\t%i\n" "$twc"
printf "    avg:\t%i\n" "$((twc / n))"
