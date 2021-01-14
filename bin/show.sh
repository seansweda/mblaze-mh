#!/bin/bash

flags=''

if [ $# -eq 0 ]; then
    mshow $flags . && mflag -vS . | mseq -Sf
elif [ "$1" = ".+" -o "$1" = "+" ]; then
    mshow $flags .+ && mflag -vS . | mseq -Sf
elif [ "$1" = ".-" -o "$1" = "-" ]; then
    mshow $flags .- && mflag -vS . | mseq -Sf
else
    mshow $flags $* && mflag -vS $* | mseq -Sf
fi

