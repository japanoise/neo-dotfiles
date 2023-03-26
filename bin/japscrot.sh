#!/bin/sh
SCROT_CMD="maim -u -s"
mkdir -p "$HOME"/img/scrot
scrnst=$HOME/img/scrot/$(date +'%Y-%m-%d-%T').png
if $SCROT_CMD "$scrnst"
then
    notify-send "Took screenshot $scrnst"
else
    notify-send "Canceled or failed to take screenshot $scrnst"
fi
