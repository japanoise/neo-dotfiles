#!/bin/sh

if ! command -v "ripdrag"
then
	message="You don't have ripdrag installed. Do \`cargo install ripdrag\`"
	echo "$message" >&2
	notify-send -u critical "$message"
	exit 1
fi

find "$HOME"/img/scrot -iname '*.png' | sort -r | head -n8 | xargs ripdrag -x -i -s 128
