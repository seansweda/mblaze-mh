#!/bin/bash

if [ $# -eq 0 ]; then
    mshow . && mflag -S .
elif [ "$1" = ".+" -o "$1" = "+" ]; then
    mshow .+ && mflag -S .
elif [ "$1" = ".-" -o "$1" = "-" ]; then
    mshow .- && mflag -S .
else
    mshow $* && mflag -S $*
fi

