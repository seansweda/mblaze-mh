#!/bin/bash
# -s: scan seq (not folder)
# -d: sort by date
# -f: only flagged
# -t: only trashed
# -u: only unseen

source ${MHBLAZE_BIN}/help.sh

export MBLAZE_PAGER="less +G"

lflags="-"
sorted=by_thread
list=mlist
scanf="%c%u%r %-3n %10d %17f %t %2i%s"

by_date() {
    msort -d | mseq -Sf | mscan -f "$scanf"
}

by_thread() {
    mthread | mseq -Sf | mscan -f "$scanf"
}

while getopts dfstu opt; do
    case $opt in
    d)	sorted=by_date
	;;
    f)	lflags+="F"	    # flagged
	;;
    s)	list=mseq
	;;
    t)	lflags+="T"	    # trashed
	;;
    u)	lflags+="s"	    # unseen
	;;
    *)	echo "usage $0: [ -dfstu ]"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ $# -gt 0 ]; then
    ${MHBLAZE_BIN}/folder.sh "$1"
fi

# no trashed unless set in lflags
echo $lflags | grep -q "T"
if [ $? -ne 0 ]; then
    lflags+="t"
fi

if [ "$list" = "mseq" ]; then
    mseq | $sorted
else
    mlist $lflags `readlink "$FOLDER"` | $sorted
fi

