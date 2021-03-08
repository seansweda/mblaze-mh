if [ "$1" = '--help' ]; then
    awk '/^#!/,/^$/' $0
    exit
fi
