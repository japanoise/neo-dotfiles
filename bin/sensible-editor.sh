#!/bin/sh
if [ -n "$VISUAL" ]
then
    "$VISUAL" "$@"
elif [ -n "$EDITOR" ]
then
    "$EDITOR" "$@"
elif command -v gomacs
then
     gomacs "$@"
elif command -v emsys
then
     emsys "$@"
elif command -v em
then
     em "$@"
elif command -v mg
then
     mg "$@"
elif command -v vim
then
     vim "$@"
elif command -v vi
then
     vi "$@"
fi
