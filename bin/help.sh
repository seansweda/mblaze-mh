help() {
    awk '/^#!/,/^$/' $0
}

if [ "$1" = '--help' ]; then
    help
    exit
fi
