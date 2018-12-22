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

if [ ! -d "$bindir" ]; then
	echo "bindir missing from config"
	exit 1
fi
if [ ! -d "$flagdir" ]; then
	echo "flagdir missing from config"
	exit 1
fi

./bg.sh

if [ -z "`which actkbd`" ]; then
	echo "actkbd not found"
else
	killall actkbd &>/dev/null
	cat actkbd.conf.template | sed -e "s/%%bindir%%/${bindir//\//\\/}/g" | sed -e "s/%%flagdir%%/${flagdir//\//\\/}/g" > actkbd.conf
	actkbd -D -c actkbd.conf
fi

killall play.sh &>/dev/null
./play.sh &

killall cron.sh &>/dev/null
./cron.sh &

killall httpsrv.sh  &>/dev/null
./httpsrv.sh &
