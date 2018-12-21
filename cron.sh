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

while [ 1 ]; do
	hour=`date +%H`
	minute=`date +%M`
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
		./sleep.sh
	else
		./wakeup.sh
	fi
	sleep 60
done
