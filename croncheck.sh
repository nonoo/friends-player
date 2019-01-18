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

if [ -z "$starthour" ]; then
	echo "starthour is not defined"
	exit 1
fi
if [ -z "$startminute" ]; then
	echo "startminute is not defined"
	exit 1
fi
if [ -z "$stophour" ]; then
	echo "stophour is not defined"
	exit 1
fi
if [ -z "$stopminute" ]; then
	echo "stopminute is not defined"
	exit 1
fi
if [ ! -d "$flagdir" ]; then
	echo "flagdir does not exist"
	exit 1
fi

hour=`date +%H`
minute=`date +%M`

# Remove leading zeroes.
hour=${hour##+(0)}
minute=${minute##+(0)}

stop=0
if (( $hour > $stophour )); then
	stop=1
elif (( $hour == $stophour && $minute >= $stopminute )); then
	stop=1
elif (( $hour < $starthour )); then
	stop=1
elif (( $hour == $starthour && $minute < $startminute )); then
	stop=1
fi
if [[ $stop == 1 ]]; then
	echo "sleep"
else
	echo "wakeup"
fi
