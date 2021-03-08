#!/bin/bash
# passes flags thru to mflag
# DFPRST: mark
# dfprst: unmark

source ${MHBLAZE_BIN}/help.sh

myflags='-v'

while getopts DFPRSTdfprst opt; do
    case $opt in
    D|F|P|R|S|T|d|f|p|r|s|t)  myflags+="$opt"
	;;
    *)	echo "usage $0: [ -DFPRST | -dfprst ] <msg>"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ $# -eq 0 ]; then
    echo "usage $0: [ -DFPRST | -dfprst ] <msg>"
    exit 1
fi

mflag ${myflags} $* | mseq -Sf >/dev/null

