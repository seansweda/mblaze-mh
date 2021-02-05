#!/bin/bash
# -c|-k: keep copy

myflags=''

while getopts ckv opt; do
    case $opt in
    c|k)  myflags+="k"
	;;
    v)	myflags+="v"
	;;
    *)	echo "usage $0: [ -kv ] <folder>"
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ $# -eq 0 ]; then
    echo "usage $0: [ -kv ] <folder>"
    exit 1
fi

if [ ${#myflags} -gt 0 ]; then
    myflags="-${myflags}"
fi

echo "${@:$#}" | egrep -q '^(\/|\~)'
if [ $? -ne 0 ]; then
    mrefile ${myflags} ${@:1:$(($#-1))} ${INBOX}/${@:$#}
else
    mrefile ${myflags} $*
fi

