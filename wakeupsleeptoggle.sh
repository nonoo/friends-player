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

if [ ! -d "$flagdir" ]; then
	echo "flagdir does not exist"
	exit 1
fi

status=`vcgencmd display_power | cut -f2 -d'='`
croncheck="`./croncheck.sh`"
if [[ $status = 1 ]]; then
	if [[ "$croncheck" == "wakeup" ]]; then
		touch $flagdir/crondisabled.txt
	else
		rm -f $flagdir/crondisabled.txt
	fi
	./sleep.sh
else
	if [[ "$croncheck" == "sleep" ]]; then
		touch $flagdir/crondisabled.txt
	else
		rm -f $flagdir/crondisabled.txt
	fi
	./wakeup.sh
fi
