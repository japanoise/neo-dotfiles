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
wctype=""
if [ "$twc" -lt 7500 ]
then
	wctype="<7500 - Short story"
elif [ "$twc" -lt 17500 ]
then
	wctype="7500-17,499 - Novelette"
elif [ "$twc" -lt 40000 ]
then
	wctype="17,500-39,999 - Novella"
elif [ "$twc" -lt 50000 ]
then
	wctype="40,000 - Novel (SFWA)"
else
	wctype="50,000 - Novel (NaNoWriMo)"
fi
printf "\n  total:\t%i\t(%s)\n" "$twc" "$wctype"
printf "    avg:\t%i\n" "$((twc / n))"
