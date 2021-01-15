#!/bin/bash
# -s: spam
# -S: undo spam
# -n: notspam
# -N: undo notspam
# -r: refile to spam
# -A: archive

refile=''
bogoflags="-vb"
spam="${MHBLAZE_SPAM:-${INBOX}/.spam}"
archive="${MHBLAZE_SPAM_ARCHIVE:-${HOME}/spamdir}"

while getopts sSnNrA opt; do
    case $opt in
    s)	bogoflags+="s"	# spam
	;;
    S)	bogoflags+="S"	# undo spam
	;;
    n)	bogoflags+="n"	# notspam
	;;
    N)	bogoflags+="N"	# undo notspam
	;;
    r)	bogoflags+="sN"	    # refile to spam folder
	refile=${spam}
	;;
    A)	refile=${archive}   # archive
	;;
    *)	echo "usage $0: -sSnNrA <msgs>"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

# no msgs, switch to spam folder
if [ $# -eq 0 ]; then
    ${MHBLAZE_BIN}/scan.sh $spam
    exit 0
fi

mseq -f $* | bogofilter $bogoflags

# print bogosity after classification
echo $bogoflags | egrep -iq 'n|s'
if [ $? -eq 0 ]; then
    mseq -f $* | bogofilter -vb
fi

if [ ! -z $refile ]; then
    mseq -f $* | mrefile $refile
fi

