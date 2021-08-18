#!/bin/bash
# -b: body only
# -r: raw message
# -h: full headers
# -H: raw headers only
# -d: debug headers only

source ${MHBLAZE_BIN}/help.sh

flags=''
d_headers=${MHBLAZE_BIN}/../headers.grep

while getopts brhHd opt; do
    case $opt in
    b)	flags="-N -h ''"	# decoded body only
	;;
    r)	flags="-Hr"		# raw message
	;;
    h)	flags="-L"		# full headers
	;;
    H)	flags="-Hq"		# raw headers only
	export MBLAZE_NOCOLOR=no
	export MBLAZE_PAGER=cat
	;;
    d)	flags="-Lq"		# debug headers
	export MBLAZE_NOCOLOR=no
	export MBLAZE_PAGER="grep -f $d_headers"
	;;
    *)	echo "usage $0: [ flags ]"
	help
	exit 1
    esac
done
shift $(( $OPTIND - 1 ))

if [ $# -eq 0 ]; then
    mshow $flags . && mflag -vS . | mseq -Sf >/dev/null
elif [ "$1" = ".+" -o "$1" = "+" ]; then
    mshow $flags .+ && mflag -vS . | mseq -Sf >/dev/null
elif [ "$1" = ".-" -o "$1" = "-" ]; then
    mshow $flags .- && mflag -vS . | mseq -Sf >/dev/null
else
    mshow $flags $* && mflag -vS $* | mseq -Sf >/dev/null
fi

