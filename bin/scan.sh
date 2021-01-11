#!/bin/bash

export MBLAZE_PAGER="less +G"

by_date() {
    mlist -t `readlink "$FOLDER"` | msort -d | mseq -Sf | mscan
}

by_thread() {
    mlist -t `readlink "$FOLDER"` | mthread | mseq -Sf | mscan
}

if [ $# -eq 0 ]; then
    by_thread
else
    ${MHBLAZE_BIN}/folder.sh "$1"
    by_thread
fi

