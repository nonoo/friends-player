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

while [ ! -d "$bindir" ]; do
	echo "waiting for $bindir..."
	sleep 1
done

$bindir/init.sh
