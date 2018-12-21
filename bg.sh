#!/bin/bash
self=`readlink "$0"`
if [ -z "$self" ]; then
    self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

cd $scriptdir
scriptdir=`pwd`

if [ -z "`which fbi`" ]; then
	echo "fbi not found"
	exit 1
fi

fbi -d /dev/fb0 -T 1 -noverbose bg.jpg
