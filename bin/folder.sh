#!/bin/bash

is_maildir() {
    if [ -d "$1" -a -d "$1"/cur ]; then
	return 0
    else
	return 1
    fi
}

blaze_folder() {
    if [ -e $FOLDER -a ! -L $FOLDER ]; then
	return 1
    fi

    if [ $# -eq 0 -a ! -e $FOLDER ]; then
	ln -sf $INBOX $FOLDER
    fi

    if [ $# -eq 1 ]; then
	if ( is_maildir "$1" ); then
	    rm $FOLDER
	    ln -s "$1" $FOLDER
	elif ( is_maildir "$INBOX/$1" ); then
	    rm $FOLDER
	    ln -s "$INBOX/$1" $FOLDER
	else
	    return 1
	fi
    fi
    readlink $FOLDER
}

blaze_folders() {
    mdirs ${INBOX} | cut -c $(( ${#INBOX} + 2 ))- | grep -v ^$ | sort | tee ${FOLDERS}
}

basename $0 | grep -q ^folders
if [ $? -eq 0 ]; then
    blaze_folders
    exit
fi

case "$1" in
    .|inbox|INBOX)
	blaze_folder $INBOX
	;;
    *)
	blaze_folder $*
	;;
esac

