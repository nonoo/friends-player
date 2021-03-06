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

./omxdbus.sh volumedown
./omxdbus.sh volume | cut -d' ' -f2 > $flagdir/volume.txt
