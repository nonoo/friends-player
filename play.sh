#/bin/bash
self=`readlink "$0"`
if [ -z "$self" ]; then
    self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

cd $scriptdir
scriptdir=`pwd`

. config

if [ -z "`which omxplayer`" ]; then
	echo "omxplayer not found"
	exit 1
fi
if [ ! -d "$flagdir" ]; then
	echo "flagdir does not exist"
	exit 1
fi
if [ ! -d "$videodir" ]; then
	echo "videodir not set"
	exit 1
fi
if [ -z "$videoextensions" ]; then
	echo "videoextensions not set"
	exit 1
fi
if [ -z "$lastplayedfile" ]; then
	echo "lastplayedfile not set"
	exit 1
fi
if [ -z "$playprevfile" ]; then
	echo "playprevfile not set"
	exit 1
fi
if [ -z "$initialvolume" ]; then
	echo "initialvolume not set"
	exit 1
fi
if [ ! -f "$font" ]; then
	echo "font missing"
	exit 1
fi
if [ ! -f "$fontitalic" ]; then
	echo "fontitalic missing"
	exit 1
fi
if [ -z "$fontsize" ]; then
	echo "fontsize not set"
	exit 1
fi

# Reading media files to an array.
echo "scanning media dir"
files=()
while IFS= read -r -d '' -u 9; do
	filename=$(basename -- "$REPLY")
	extension="${filename##*.}"

	extensionallowed=0
	for allowedextension in $videoextensions; do
		if [[ "$allowedextension" = "$extension" ]]; then
			extensionallowed=1
			break
		fi
	done

	if [[ $extensionallowed = 1 ]]; then
		echo "$REPLY"
	    files+=("$REPLY")
	fi
done 9< <( find $videodir -type f -exec printf '%s\0' {} + )
echo "scan done"

# Sort the array.
IFS=$'\n' files=($(sort <<<"${files[*]}"))
unset IFS

# Searching the index of the last played item in the array.
lastplayedfileindex=0
if [ -f "$lastplayedfile" ]; then
	lastplayedfilename=`cat "$lastplayedfile"`

	for i in "${!files[@]}"; do
	   if [[ "${files[$i]}" = "${lastplayedfilename}" ]]; then
	       lastplayedfileindex="$i";
	   fi
	done
fi

# Printing the files array.
#printf '%s\n' "${files[@]}"
files_count=${#files[@]}

while [ 1 ]; do
	filetoplay=${files[$lastplayedfileindex]}
	echo "playing idx $lastplayedfileindex: $filetoplay"

	# Storing the file to play to the last played file.
	echo $filetoplay > $lastplayedfile

	filetoplaywithoutextension="${filetoplay%.*}"
	filenamewithoutextension=`basename $filetoplaywithoutextension`
	if [ ! -z "$gettitlescript" ]; then
		title=`bash $gettitlescript "$filenamewithoutextension"`
	else
		title=$filetoplay
	fi

	if [ -f "$flagdir/volume.txt" ]; then
		initialvolume=`cat $flagdir/volume.txt`
		# Converting to millibels.
		initialvolume=`echo $initialvolume | awk '{print 2000*(log($1)/log(10))}'`
	fi

	# Converting to decibels.
	echo $initialvolume | awk '{print exp(($1/2000)*log(10))}' > $flagdir/volume.txt

	omxplayer -b --vol $initialvolume --font "$font" --italic-font "$fontitalic" \
		--title-font "$titlefont" --subtitles "$filetoplaywithoutextension.srt" \
		--font-size $fontsize --title-font-size $titlefontsize --align center \
		--title "$title" "$filetoplay" --show-time

	./bg.sh

	if [ -f $playprevfile ]; then
		((lastplayedfileindex--))
		if [[ $lastplayedfileindex = -1 ]]; then
			lastplayedfileindex=$((files_count - 1 ))
		fi

		rm $playprevfile
	else
		((lastplayedfileindex++))
		if [[ $lastplayedfileindex = $files_count ]]; then
			lastplayedfileindex=0
		fi
	fi
done
