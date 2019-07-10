#!/bin/sh
# Wrapper around grep to provide an interface similar to ripgrep
grep --color=always -rnI "$@"
