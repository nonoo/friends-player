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

if [ -z "$httpsrvport" ]; then
	httpsrvport=80
fi

rm -f /tmp/httpsrv.fifo
mkfifo /tmp/httpsrv.fifo

while true; do
	cat /tmp/httpsrv.fifo | nc -l -p $httpsrvport > >(
		export REQUEST=

		while read -r line; do
			line=$(echo "$line" | tr -d '\r\n')

			 # If line starts with "GET /"
			if echo "$line" | grep -qE '^GET '; then
				# Extract the request.
				REQUEST=$(echo "$line" | cut -d ' ' -f2)
			elif [ -z "$line" ]; then
				# Empty line / end of request.
				echo "got request: $REQUEST"
				./httpsrv-handler.sh > /tmp/httpsrv.fifo
			fi
		done
	)
done
