#!/bin/sh
fatal() {
	printf "%s: %s\n" "$0" "$1" 1>&2
	exit $2
}

FRAMENW="┌"
FRAMENE="┐"
FRAMESW="└"
FRAMESE="┘"
FRAMEN="─"
FRAMES="─"
FRAMEE="│"
FRAMEW="│"
EYES="oo"
TONGUE="  "
THOUGHTS="╲"
LINES=1
TWIDTH=0

COW="kona1"
FRAME="unicode"

while getopts W:b:f:e:t:l o
do
	case "$o" in
		b) FRAME="$OPTARG";;
		f) COW=$(basename -s .cow "$OPTARG");;
		l) basename -s.cow /usr/share/cows/*.cow | xargs echo
			exit 0;;
		e) EYES="$OPTARG";;
		t) TONGUE="$OPTARG";;
		W) TWIDTH="$OPTARG";;
	esac
done
shift $((OPTIND-1))

COWFILE="/usr/share/cows/${COW}.cow"
if [ ! -f "$COWFILE" ]
then
	fatal "Can't find cowfile $cow!" 1
fi
case "$FRAME" in
	unicode);;
	rounded) FRAMENW="╭";FRAMENE="╮";FRAMESE="╯";FRAMESW="╰";;
	think) FRAMENW=" ";FRAMESW=" ";FRAMENE=" ";FRAMESE=" ";FRAMEE=")";FRAMEW="(";THOUGHTS="o";;
	classic) FRAMENW=" ";FRAMESW=" ";FRAMENE=" ";FRAMESE=" ";FRAMEE=">"; FRAMES="-" FRAMEN="_"
		FRAMEW="<";THOUGHTS='\\';;
	classicish) FRAMENW=" ";FRAMESW=" ";FRAMENE=" ";FRAMESE=" ";FRAMEE=">"; FRAMES="-" FRAMEN="_"
		FRAMEW="<";THOUGHTS='\\';;
	say) FRAMENW=" ";FRAMESW=" ";FRAMENE=" ";FRAMESE=" ";FRAMEE="|";FRAMEW="|";THOUGHTS='\\';;
	thick) FRAMENW="┏";FRAMESW="┗";FRAMENE="┓";FRAMESE="┛";FRAMEE="┃";FRAMEW="┃";FRAMEN="━";FRAMES="━";;
	list) printf "%s\n" "classic classicish rounded say thick think unicode"; exit 0;;
	preview) cat << 'EOF'
 _________
< classic >
 ---------
    \
 ____________
< classicish >
 ------------
    \
╭─────────╮
│ rounded │
╰─────────╯
    ╲
 _____
| say |
 ─────
    \
┏━━━━━━━┓
┃ thick ┃
┗━━━━━━━┛
    ╲
 _______
( think )
 ───────
    o
┌─────────┐
│ unicode │
└─────────┘
    ╲
EOF
		exit 0
		;;
	*) fatal "No such border $FRAME" 1 ;;
esac

if [ -z "$@" ]
then
	INPUT=$(cat | sed -e "s/\t/    /g")
else
	INPUT="$@"
fi

if [ "$TWIDTH" -gt 0 ]
then
	INPUT=$(printf "%s\n" "$INPUT" | fold -s -w $TWIDTH)
fi

if [ "$FRAME" = "classic" ]
then
	LINES=$(printf "%s\n" "$INPUT" | wc -l)
fi

WIDTH=$(printf "%s\n" "$INPUT" | awk '{ print length($0); }' | sort -n -r | head -n1)
bar() {
	printf "%s" "$1$2"
	for i in $(seq 1 $WIDTH)
	do
		printf "%s" "$2"
	done
	printf "%s\n" "$2$3"
}

bar "$FRAMENW" "$FRAMEN" "$FRAMENE"
if [ "$LINES" -gt 1 ]
then
	printf "%s\n" "$INPUT" | awk '{printf("%s",$0);n='$WIDTH'-length($0); for (i=0;i<n;i++) {printf("%s"," ");}print ""}'\
		| sed -e "s/^/| /" -e "s/$/ |/" -e'1s/^./\//' -e'1s/.$/\\/'  -e $LINES's/^./\\/' -e $LINES's/.$/\//'
else
	printf "%s\n" "$INPUT" | awk '{printf("%s",$0);n='$WIDTH'-length($0); for (i=0;i<n;i++) {printf("%s"," ");}print ""}'\
		| sed -e "s/^/$FRAMEW /" -e "s/$/ $FRAMEE/"
fi
bar "$FRAMESW" "$FRAMES" "$FRAMESE"

sed -e '/^$the_cow/d' -e '/^EOC/d' -e "s/\$thoughts/$THOUGHTS/g" -e"s/\$\?tongue/$TONGUE/g" -e"s/\$\?eyes/$EYES/g" < "$COWFILE"
