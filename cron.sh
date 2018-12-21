#!/bin/bash
self=`readlink "$0"`
if [ -z "$self" ]; then
    self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

cd $scriptdir
scriptdir=`pwd`

. config

while [ 1 ]; do
	if [ ! -f "$flagdir/crondisabled.txt" ]; then
		croncheck="`./croncheck.sh`"
		if [[ "$croncheck" == "sleep" ]]; then
			./sleep.sh
		else
			./wakeup.sh
		fi
	fi
	sleep 60
done
