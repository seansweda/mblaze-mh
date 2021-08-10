#!/bin/bash
# -A: all folders
# -l: list filenames
# -t: include trashed

source ${MHBLAZE_BIN}/help.sh

mu index --lazy-check --nocleanup -q
folder=`readlink $FOLDER | sed -e "s_${INBOX}__"`
folder="maildir:${folder:-/}"

list=''
trashed="not flag:trashed"
scanf="%c%u%r %-3n %10d %17f %t %2i%s"

while getopts Alt opt; do
    case $opt in
    A)	folder="not maildir:/.expunged"
	scanf="%-3n %15F %10d %17f %s"
	;;
    l)	list="yes"
	;;
    t)	trashed=""
	;;
    *)	echo "usage $0: [ -Alt ] < mu-query >"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ -z "$list" ]; then
    mu find -f l ${folder} ${trashed} $* | msort -d | mseq -Sf | mscan -f "$scanf"
else
    mu find -f l ${folder} ${trashed} $*
fi

