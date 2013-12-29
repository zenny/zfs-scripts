#!/usr/local/bin/bash

# set to your zpool location
ZPOOL_LOCATION='/sbin/zpool'

# start scrubbing each specified zpool
$ZPOOL_LOCATION scrub zroot

#$ZPOOL_LOCATION scrub tank
#$ZPOOL_LOCATION scrub etc
