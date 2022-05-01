#!/bin/sh
mkdir -p $HOME/img/scrot
scrnst=$HOME/img/scrot/$(date +'%Y-%m-%d-%T').png
if scrot -s "$scrnst"
then
    notify-send "Took screenshot $scrnst"
else
    notify-send "Canceled or failed to take screenshot $scrnst"
fi
