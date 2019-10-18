#!/bin/sh
# Every shell hacker has written one of these. This one is mine.
#
# - chame

REVERSE="$(printf "\033[7m")"
NOCOLOR="$(printf "\033[0m")"

################################################################################
#                                headers                                       #
################################################################################
printf "%sfg↓ " "$REVERSE"
printf "bg→ "
for j in $(seq 0 7)
do
    printf " 4%s " "$j"
done
for j in $(seq 0 7)
do
    printf "10%s " "$j"
done
printf "%s\n" "$NOCOLOR"

################################################################################
#                             default fg                                       #
################################################################################
printf "%sdef%s gYw " "$REVERSE" "$NOCOLOR"
for j in $(seq 0 7)
do
    printf "\033[4%smgYw%s " "$j" "$NOCOLOR"
done
for j in $(seq 0 7)
do
    printf "\033[10%smgYw%s " "$j" "$NOCOLOR"
done
printf "\n"

################################################################################
#                                3n fgs                                        #
################################################################################
for i in $(seq 0 7)
do
    printf "%s 3%s%s \033[3%smgYw%s " "$REVERSE" "$i" "$NOCOLOR" "$i" "$NOCOLOR"
    for j in $(seq 0 7)
    do
        printf "\033[4%sm\033[3%smgYw%s " "$j" "$i" "$NOCOLOR"
    done
    for j in $(seq 0 7)
    do
        printf "\033[10%sm\033[3%smgYw%s " "$j" "$i" "$NOCOLOR"
    done
    printf "\n"
done

################################################################################
#                                9n fgs                                        #
################################################################################
for i in $(seq 0 7)
do
    printf "%s 9%s%s \033[9%smgYw%s " "$REVERSE" "$i" "$NOCOLOR" "$i" "$NOCOLOR"
    for j in $(seq 0 7)
    do
        printf "\033[4%sm\033[9%smgYw%s " "$j" "$i" "$NOCOLOR"
    done
    for j in $(seq 0 7)
    do
        printf "\033[10%sm\033[9%smgYw%s " "$j" "$i" "$NOCOLOR"
    done
    printf "\n"
done
