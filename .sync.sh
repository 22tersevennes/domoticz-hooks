#!/bin/bash

FROM="domoticz:google-cal-event"
TARGET="fraise:/home/pi"

RSYNC="rsync -avz --exclude-from=.sync.exclude"
[ ! -z $DEBUG ] && RSYNC="$RSYNC --dry-run"

for target in $(echo $FROM | tr ":" "\n"); do
    $RSYNC -r "$target/" "$TARGET/$target/"
done
#