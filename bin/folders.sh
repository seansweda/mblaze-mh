#!/bin/bash
# -q: quiet
# -r: recurse (list all)
# -u: unseen
# -t: trashed
# -T: trashed after re-index
# -l: custom list

source ${MHBLAZE_BIN}/help.sh

FOLDER_LIST=${MHBLAZE_BIN}/../folders

path_re() {
    echo $* | sed -e 's_/_\\/_g'
}

folders_recurse() {
    mdirs ${INBOX} | cut -c $(( ${#INBOX} + 2 ))- | grep -v ^$ | sort | tee ${FOLDERS}
}

folders_unseen() {
    mlist -i `mdirs -a $INBOX | sort` | grep -v '0 unseen    0 flagged' | sed -e "s/`path_re ${INBOX}`\$/.INBOX/" | sed -e "s/`path_re ${INBOX}`\///"
}

folders_trashed() {
    #mu find -f l flag:t | cut -d / -f 4- | sed -e 's/\/cur.*$//' | sort | uniq -c | awk '{ printf "%6s trashed%40s\n", $1, $2 }'
    mu find -f l flag:t 2>/dev/null | cut -d / -f 4- | sed -e 's/\/cur.*$//' | sort | uniq -c | sed -e "s/`path_re .maildir`\$/.INBOX/" | sed -e "s/`path_re .maildir`\///" | awk '{ printf "%6s trashed %25s%s\n", $1, " ", $2 }'
}

folders_list() {
    mlist -i $* | sed -e "s/`path_re ${INBOX}`\$/.INBOX/" | sed -e "s/`path_re ${INBOX}`\///"
}

while getopts qlrutT opt; do
    case $opt in
    q)	exec 1>/dev/null
	;;
    l)	list=yes
	;;
    r)	recurse=yes
	;;
    u)	unseen=yes
	;;
    t)	trashed=yes
	;;
    T)	trashed=yes
	mu index --lazy-check --nocleanup -q
	;;
    *)	echo "usage $0: [ -r | -ut ] [ -l <folder> ... ]"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ -s $FOLDER_LIST ]; then
    l_folders="`cat $FOLDER_LIST`"
else
    l_folders=$INBOX
fi

if [ $# -eq 0 ]; then
    if [ -z "$recurse" -a -z "$unseen" -a -z "$trashed" -a -z "$list" ]; then
	folders_list $l_folders
	folders_trashed
    else
	if [ ! -z $recurse ]; then
	    folders_recurse
	    exit 0
	fi
	if [ ! -z $list ]; then
	    folders_list $l_folders
	fi
	if [ ! -z $unseen ]; then
	    folders_unseen
	fi
	if [ ! -z $trashed ]; then
	    folders_trashed
	fi
    fi
else
    folders_list $*
fi

