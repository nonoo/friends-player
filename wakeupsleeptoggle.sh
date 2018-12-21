#!/bin/bash
self=`readlink "$0"`
if [ -z "$self" ]; then
    self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

cd $scriptdir
scriptdir=`pwd`

status=`vcgencmd display_power | cut -f2 -d'='`
if [[ $status = 1 ]]; then
	./sleep.sh
else
	./wakeup.sh
fi
