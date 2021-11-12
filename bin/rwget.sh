#!/bin/sh
# Wrapper around wget & lynx to make it easier to grab directories

emsg() {
    echo "$@" >&2
}

usage() {
    emsg "usage: $0 command [url]"
    emsg ""
    emsg "Supported commands:"
    emsg "default     - \`wget --recursive --no-parent -e robots=off\`"
    emsg "hostile     - \`wget --recursive --no-parent -e robots=off --user-agent=\"\$(useragent.sh)\"\`"
    emsg "dumplinks   - \`lynx -dump -listonly\`"
    emsg "usage, help - display this message"
}

case "$1" in
    default )
        shift
        wget --recursive --no-parent -e robots=off "$@";;
    hostile )
        shift
        wget --recursive --no-parent -e robots=off --user-agent="$(useragent.sh)" "$@";;
    dumplinks )
        shift
        lynx -dump -listonly "$@";;
    usage )
        usage;;
    help )
        usage;;
    * )
        emsg "Unknown command $1"
        usage
        exit 1;;
esac
