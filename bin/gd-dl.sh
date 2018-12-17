#!/bin/bash
URL=$1
TMPDIR=/tmp/gd-dl
mkdir -pv "$TMPDIR"

wget_args=--user-agent='Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:64.0) Gecko/20100101 Firefox/64.0'

wget "$wget_args" -O - "$URL" 2>/dev/null | sed -n -e 's/[^"]*"\(\/download\/[^"]*vbr.m3u\).*/https:\/\/archive.org\1/p' | xargs wget "$wget_args" -O "$TMPDIR/files.txt"

while read -r -u 10 p; do
	wget "$wget_args" "$p"
done 10<"$TMPDIR/files.txt"
