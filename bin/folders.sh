#!/bin/bash

l_folders=${MHBLAZE_BIN}/../folders

path_re() {
    echo $* | sed -e 's_/_\\/_g'
}

folders_recurse() {
    mdirs ${INBOX} | cut -c $(( ${#INBOX} + 2 ))- | grep -v ^$ | sort | tee ${FOLDERS}
}

folders_unseen() {
    mlist -i `mdirs -a $INBOX | sort` | grep -v '0 unseen    0 flagged' | sed -e "s/`path_re ${INBOX}`\$/.INBOX/" | sed -e "s/`path_re ${INBOX}`\///"
}

folders_list() {
    mlist -i $* | sed -e "s/`path_re ${INBOX}`\$/.INBOX/" | sed -e "s/`path_re ${INBOX}`\///"
}

while getopts qrul opt; do
    case $opt in
    q)	exec 1>/dev/null
	;;
    r)	recurse=yes
	;;
    u)	unseen=yes
	;;
    l)	;;
    *)	echo "usage $0: [ -r | -u ] [ -l <folder> ... ]"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ $# -eq 0 ]; then
    if [ ! -z $recurse ]; then
	folders_recurse
    elif [ ! -z $unseen ]; then
	folders_unseen
    elif [ -s $l_folders ]; then
	folders_list `cat $l_folders`
    else
	folders_list $INBOX
    fi
else
    folders_list $*
fi

