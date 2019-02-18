#!/bin/bash
self=`readlink "$0"`
if [ -z "$self" ]; then
    self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

cd $scriptdir
scriptdir=`pwd`

displayon=`vcgencmd display_power | cut -f2 -d'='`
if [[ "$displayon" = "1" ]]; then
	paused=`./omxdbus.sh status | grep Paused | cut -f2 -d' '`
	if [[ "$paused" != "true" ]]; then
		./omxdbus.sh pause
	fi
	vcgencmd display_power 0
fi
