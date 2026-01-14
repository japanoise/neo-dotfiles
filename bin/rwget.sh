#!/bin/sh
# Wrapper around wget & lynx to make it easier to grab directories

emsg() {
    echo "$@" >&2
}

usage() {
    emsg "usage: $0 command [url]"
    emsg ""
    emsg "Supported commands:"
    emsg "default     - \`wget --recursive --no-parent -e robots=off -k\`"
    emsg "hostile     - \`wget --recursive --no-parent -e robots=off -k --user-agent=\"\$(useragent.sh)\"\`"
    emsg "dumplinks   - \`lynx -dump -listonly\`"
    emsg "filterlinks - [url] [sed expression] - show links matching regex"
    emsg "grablinks   - [url] [sed expression] - download links matching regex"
    emsg "usage, help - display this message"
}

dumplinks() {
    lynx -dump -listonly "$@"
}

sed_printcmd() {
    startswith=$(echo "$1" | sed -e 's/^\(.\).*/\1/')
    endswith=$(echo "$1" | sed -e 's/.*\(.\)$/\1/')

    if [ "$startswith" = "/" ]
    then
        if [ "$endswith" = "/" ]
        then
            echo "$1"p
            return 0
        elif [ "$endswith" = "p" ]
        then
            echo "$1"
            return 0
        else
            echo "malformed regex/sed print command" >&2
            exit 1
        fi
    else
        echo /"$1"/p
    fi
}

filterlinks() {
    dumplinks "$1" | \
            sed -n -e "$(sed_printcmd "$2")" | \
            sed -e 's/^  *[0-9]*\. //'
}

case "$1" in
    default )
        shift
        wget --recursive --no-parent -e robots=off -k "$@";;
    hostile )
        shift
        wget --recursive --no-parent -e robots=off -k --user-agent="$(useragent.sh)" "$@";;
    dumplinks )
        shift
        dumplinks "$@"
        ;;
    filterlinks )
        shift
        filterlinks "$1" "$2"
        ;;
    grablinks )
        shift
        filterlinks "$1" "$2" | xargs wget
        ;;
    usage )
        usage;;
    help )
        usage;;
    * )
        emsg "Unknown command $1"
        usage
        exit 1;;
esac
