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

if [[ $REQUEST == "/?cmd=volumeup" ]]; then
	./volumeup.sh &>/dev/null
fi

if [[ $REQUEST == "/?cmd=volumedown" ]]; then
	./volumedown.sh &>/dev/null
fi

if [[ $REQUEST == "/?cmd=off" ]]; then
	if [[ "`./croncheck.sh`" == "wakeup" ]]; then
		touch $flagdir/crondisabled.txt
	else
		rm -f $flagdir/crondisabled.txt
	fi
	./sleep.sh &>/dev/null
fi

if [[ $REQUEST == "/?cmd=on" ]]; then
	# If cron allows the player to be on.
	if [[ "`./croncheck.sh`" == "wakeup" ]]; then
		rm -f $flagdir/crondisabled.txt
		./wakeup.sh &>/dev/null
	fi
fi

echo -e "HTTP/1.0 200 OK\nContent-length: 0\n"
