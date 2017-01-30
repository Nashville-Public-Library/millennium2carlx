#!/usr/bin/bash

# get_pins.sh
# usage
# bash get_pins.sh numThreads
# e.g., 
# bash get_pins.sh 25
# 100 threads causes performance lags in Millennium; James ain't sure there's much advantage for more than 25

# James Staub
# Nashville Public Library
# 20160126
# Launch multiple get_pins.php processes which
# verify Millennium patron PINs stored in Pika
# and clobber Millennium patron api for the rest

#echo "Start time"
#date

# TO DO : retrieve pika mysql user table and run query for Millennium users and PINs
#SELECT username,cat_password
#FROM vufind.user
#WHERE source="ils"
#ORDER BY username;

# TO DO : another sql query to get PINs in order of their frequency, 
# eliminating PINs with fewer than 3 appearances
# and fill in all remaining 4-digit PINs
#SELECT cat_password AS PIN, count(cat_password) AS COUNT
#FROM vufind.user
#WHERE source="ils"
#AND count(cat_password) > 2
#GROUP BY cat_password
#ORDER BY COUNT DESC, PIN;

function pikaPinVerification {
	pikaUsersFile="../data/pikaUsers.txt"
	total_lines=$(wc -l <$pikaUsersFile)
	((lines_per_file = (total_lines + $1 - 1) / $1))

	#echo "Chunks          = $1"
	#echo "File            = $pikaUsersFile"
	#echo "Total lines     = ${total_lines}"
	#echo "Lines  per file = ${lines_per_file}" 

	MAX=$(($1-1))
	#echo ${#MAX} # number of digits in the number of the last chunk
	split --suffix-length=${#MAX} --numeric-suffixes --lines=${lines_per_file} $pikaUsersFile $pikaUsersFile.

	for i in $(seq -w 0 $MAX )
	do
	#	echo $i
		php get_pins_pika.php $i &
	done

	while pgrep -f 'get_pins_pika.php [0-9]' | wc -l >/dev/null
	do 
		PROCS=$(pgrep -f 'get_pins_pika.php [0-9]' | wc -l)
	#	echo -ne "still running: $PROCS\r"
		if [[ $PROCS = 0 ]] ; then 
			break
		fi
		sleep 30
	done

	#echo "\n\n"

	# TO DO: make file shuffling paths derive from args
	rm -f ../data/invalidUserPins.txt
	cat ../data/invalidUserPins.txt.* >> ../data/invalidUserPins.txt
	rm -f ../data/invalidUserPins.txt.*
	rm -f ../data/validUserPins.txt
	cat ../data/validUserPins.txt.* >> ../data/validUserPins.txt
	rm -f ../data/validUserPins.txt.*
	rm -f ../data/pikaUsers.txt.*

	# TO DO: add data to PATRON.txt or something else
}

function millenniumPinClobber {
	patronsWithPinsFile="../data/millennium_extract-patronsWithPins.txt"
	# Create and retrieve Millennium create list of patrons with PIN != ""
	expect get_pins.exp

	total_lines=$(wc -l <$patronsWithPinsFile)
	((lines_per_file = (total_lines + $1 - 1) / $1))

	#echo "Chunks          = $1"
	#echo "File            = $patronsWithPinsFile"
	#echo "Total lines     = ${total_lines}"
	#echo "Lines  per file = ${lines_per_file}" 

	MAX=$(($1-1))
	#echo ${#MAX} # number of digits in the number of the last chunk
	split --suffix-length=${#MAX} --numeric-suffixes --lines=${lines_per_file} $patronsWithPinsFile $patronsWithPinsFile.

	for i in $(seq -w 0 $MAX )
	do
	#	echo $i
		php get_pins.php $i &
	done

	while pgrep -f 'get_pins.php [0-9]' | wc -l >/dev/null
	do 
		PROCS=$(pgrep -f 'get_pins.php [0-9]' | wc -l)
	#	echo -ne "still running: $PROCS\r"
		if [[ $PROCS = 0 ]] ; then 
			break
		fi
		sleep 30
	done

	#echo "\n\n"

	# TO DO: make file shuffling paths derive from args
#	rm -f ../data/invalidUserPins.txt
#	cat ../data/invalidUserPins.txt.* >> ../data/invalidUserPins.txt
#	rm -f ../data/invalidUserPins.txt.*
#	rm -f ../data/validUserPins.txt
#	cat ../data/validUserPins.txt.* >> ../data/validUserPins.txt
#	rm -f ../data/validUserPins.txt.*
#	rm -f ../data/pikaUsers.txt.*

	# TO DO: add data to PATRON.txt or something else
}
