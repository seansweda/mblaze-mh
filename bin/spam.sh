#!/bin/bash
# -s: spam
# -S: undo spam
# -n: notspam
# -N: undo notspam
# -r: refile to spam
# -A: archive

source ${MHBLAZE_BIN}/help.sh

refile=''
bogoflags="-b"
spam="${MHBLAZE_SPAM:-${INBOX}/.spam}"
archive="${MHBLAZE_SPAM_ARCHIVE:-${HOME}/spamdir}"

while getopts vsSnNrA opt; do
    case $opt in
    v)	bogoflags+="v"	# increase verbosity
	;;
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
    *)	echo "usage $0: [ flags ] <msgs>"
	help
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

# no msgs, switch to spam folder
if [ $# -eq 0 ]; then
    ${MHBLAZE_BIN}/scan.sh -d $spam
    exit 0
fi

# ensure at least one level of verbosity
echo $bogoflags | grep -q 'v'
if [ $? -ne 0 ]; then
    bogoflags+="v"
fi

mflag -S $* >/dev/null
mseq -rf $* | bogofilter $bogoflags

# print bogosity after classification
echo $bogoflags | egrep -iq 'n|s'
if [ $? -eq 0 ]; then
    mseq -rf $* | bogofilter -vb
fi

if [ ! -z $refile ]; then
    mseq -rf $* | mrefile $refile
fi

