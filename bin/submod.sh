#!/bin/sh
# Remember all the stupid submodule commands for me
usage() {
    printf "%s fetch - fetch submodules, if you forgot to recursive clone\n" \
           "$0"
    printf "%s add [url] - add new submodule\n" \
           "$0"
    printf "%s update [submodule] - update given submodule\n" \
           "$0"
    printf "If you're more patient than I am: %s\n" \
           "https://git-scm.com/book/en/v2/Git-Tools-Submodules"
}

case "$1" in
    fetch|clone ) git submodule update --init --recursive;;
    update ) git submodule update --remote "$2";;
    hate )
        while true
        do
            echo "I HATE SUBMODULES!"
            sleep 0.5s
        done
        ;;
    * ) usage;;
esac

