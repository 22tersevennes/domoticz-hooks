#!/bin/bash

[ -z "$1" ] && {
    echo "usage: $0 ssh-target"
    exit
}

FROM="domoticz:google-cal-event"
TARGET="$1:/home/pi"

RSYNC="rsync -avz --exclude-from=.sync.exclude"
[ ! -z $DEBUG ] && RSYNC="$RSYNC --dry-run"

for target in $(echo $FROM | tr ":" "\n"); do
    $RSYNC -r "$target/" "$TARGET/$target/"
done
#
