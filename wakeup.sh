#!/bin/bash
self=`readlink "$0"`
if [ -z "$self" ]; then
    self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

cd $scriptdir
scriptdir=`pwd`

vcgencmd display_power 1
paused=`./omxdbus.sh status | grep Paused | cut -f2 -d' '`
if [[ "$paused" = "true" ]]; then
	sleep 2
	./omxdbus.sh pause
fi
