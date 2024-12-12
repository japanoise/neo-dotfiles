#!/bin/sh
# brew.sh - omniversal package manager wrapper
# The interface of homebrew, without the Mac!
emsg() {
    echo "$@" >&2
}

usage() {
    emsg "usage: $0 command [packages]"
    emsg ""
    emsg "Supported commands:"
    emsg "install     - install the specified packages"
    emsg "uninstall   - uninstall the specified packages"
    emsg "libinstall  - install the specified packages, with hacks to get libraries"
    emsg "listfiles   - list files installed by the packages"
    emsg "search      - search for the packages"
    emsg "update      - sync (if applicable) and update the system"
    emsg "usage, help - display this message"
}

doInstall() {
    case "$distro" in
        debian )
            sudo apt install "$@";;
        redhat )
            sudo yum install "$@";;
        gentoo )
            sudo emerge --ask "$@";;
        arch )
            sudo pacman -S "$@";;
        msys2 )
            pacman -S "$@";;
    esac
}

doUninstall() {
    case "$distro" in
        debian )
            sudo apt remove "$@";;
        redhat )
            sudo yum remove "$@";;
        gentoo )
            sudo emerge --deselect "$@" && sudo emerge --ask --depclean;;
        arch )
            sudo pacman -Rs "$@";;
        msys2 )
            pacman -Rs "$@";;
    esac
}

doLibInstall() {
    case "$distro" in
        debian )
            for lib in "$@"
            do
                sudo apt install "${lib}-dev" || sudo apt install "lib${lib}-dev" || sudo apt install "$lib" || (emsg "$lib not found" && exit 1)
            done;;
        redhat )
            for lib in "$@"
            do
                sudo yum install "${lib}-devel" || sudo yum install "lib${lib}-devel" || sudo yum install "$lib" || (emsg "$lib not found" && exit 1)
            done;;
        gentoo )
            sudo emerge --ask "$@";;
        arch )
            for lib in "$@"
            do
                sudo pacman -S "lib${lib}" || sudo pacman -S "$lib" || (emsg "$lib not found" && exit 1)
            done;;
        msys2 )
            for lib in "$@"
            do
                pacman -S "lib${lib}" || pacman -S "$lib" || (emsg "$lib not found" && exit 1)
            done;;
    esac
}

doListFiles() {
    case "$distro" in
        debian )
            dpkg-query -L "$@";;
        redhat )
            if command -v repoquery
            then
                repoquery --list "$@"
            else
                emsg "Listfiles requires repoquery - sudo yum install yum-utils"
                exit 1
            fi;;
        gentoo )
            if command -v equery
            then
                equery files --tree "$@"
            else
                emsg "Listfiles requires equery - sudo emerge --ask app-portage/gentoolkit"
                exit 1
            fi;;
        arch|msys2 )
            pacman -Ql "$@";;
    esac
}

doSearch() {
    case "$distro" in
        debian )
            apt search "$@";;
        redhat )
            yum list "$@";;
        gentoo )
            if command -v eix
            then
                eix "$@"
            else
                emsg "You need eix installed to search - sudo emerge eix"
                exit 1
            fi;;
        arch|msys2 )
            pacman -Ss "$@";;
    esac
}

doUpdate() {
    case "$distro" in
        debian )
            sudo apt update
            sudo apt upgrade;;
        redhat )
            sudo yum update;;
        gentoo )
            command -v layman && sudo layman --sync-all
            if command -v eix-sync
            then
                sudo eix-sync
            else
                sudo emerge --sync
            fi
            sudo emerge --ask --update --deep --newuse --with-bdeps=y @world;;
        arch )
            # Prepare for breakage!
            sudo pacman -Syu;;
        msys2 )
            # Prepare for breakage!
            pacman -Syu;;
    esac
}

distro="unknown"
getDistro() {
    if [ -d /etc/portage ]
    then
        distro="gentoo"
    elif [ -f /msys2.exe ]
    then
        distro="msys2"
    else
        for dst in debian redhat arch
        do
            grep -iq "$dst" /etc/*release && distro="$dst" && return
        done
    fi
}
getDistro

if [ "$distro" = "unknown" ]
then
    emsg "Unsupported distro. This script currently supports:"
    emsg "arch, msys2, debian family, redhat family, and portage-based distros"
    exit 1
else
    emsg "Detected distro (or family) $distro"
    emsg ""
fi

case "$1" in
    install )
        shift
        doInstall "$@";;
    libinstall )
        shift
        doLibInstall "$@";;
    listfiles )
        shift
        doListFiles "$@";;
    search )
        shift
        doSearch "$@";;
    update )
        shift
        doUpdate "$@";;
    uninstall)
        shift
        doUninstall "$@";;
    usage )
        usage;;
    help )
        usage;;
    * )
        emsg "Unknown command $1"
        usage
        exit 1;;
esac

# Local Variables:
# indent-tabs-mode: nil
# End:
