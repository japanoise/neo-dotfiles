#!/bin/sh
dunstctl set-paused true
XSECURELOCK_LIST_VIDEOS_COMMAND='find -L ~/vid/saver -type f' XSECURELOCK_SAVER=saver_mpv XSECURELOCK_NO_COMPOSITE=1 xsecurelock || i3lock -n
dunstctl set-paused false
