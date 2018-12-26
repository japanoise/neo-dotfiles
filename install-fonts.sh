#!/bin/sh
# Ignoring because it's the intended behaviour:
# shellcheck disable=SC2088
if grep -q "~/.fonts" /etc/fonts/fonts.conf
then
	mkdir -pv "$HOME"/.fonts
	find fonts -print0 -iname '*.ttf' | xargs -0 -I FONT cp -v FONT "$HOME"/.fonts
elif grep -q -i '<dir prefix="xdg">fonts</dir>' /etc/fonts/fonts.conf
then
	FONTDIR="$XDG_DATA_HOME"
	if [ -z "$FONTDIR" ]
	then
		FONTDIR="$HOME"/.local/share
	fi
	FONTDIR="$FONTDIR"/fonts
	mkdir -pv "$FONTDIR"
	find fonts -print0 -iname '*.ttf' | xargs -0 -I FONT cp -v FONT "$FONTDIR"
else
	sudo mkdir -pv /usr/local/share/fonts
	find fonts -print0 -iname '*.ttf' | xargs -0 -I FONT sudo cp -v FONT /usr/local/share/fonts
fi
sudo fc-cache -v
