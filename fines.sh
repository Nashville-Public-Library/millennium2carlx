#!/usr/bin/bash

# fines.sh
# usage
# bash fines.sh numThreads pathAndFileOfPatronIds 
# e.g., 
# bash fines.sh 25 ../data/fines-patronIds

# James Staub
# Nashville Public Library
# 20160119
# Get list of patrons with fines.
# Launch multiple fines.php processes which
# Extract Millennium patron fines data via Fines Payment API

# TO DO: RERUN PATRONS WITH ERRORS

#echo "Start time"
#date

expect get_patrons_with_fines.exp

perl -F'\t' -lane '$F[1]=substr($F[1],1); $o+=$F[1]; END { print "TOTAL FINES: $o\n"; }' ../data/millennium_extract-patronsWithFines.txt 
perl -F'\t' -lane 'print $F[0]' ../data/millennium_extract-patronsWithFines.txt > ../data/fines-patronIds

total_lines=$(wc -l <$2)
((lines_per_file = (total_lines + $1 - 1) / $1))

#echo "Chunks          = $1"
#echo "File            = $2"
#echo "Total lines     = ${total_lines}"
#echo "Lines  per file = ${lines_per_file}" 

MAX=$(($1-1))
#echo ${#MAX} # number of digits in the number of the last chunk
split --suffix-length=${#MAX} --numeric-suffixes --lines=${lines_per_file} $2 $2.

for i in $(seq -w 0 $MAX )
do
#	echo $i
	php fines.php $i &
done

while pgrep -f 'fines.php [0-9]' | wc -l >/dev/null
do 
	PROCS=$(pgrep -f 'fines.php [0-9]' | wc -l)
#	echo -ne "still running: $PROCS\r"
	if [[ $PROCS = 0 ]] ; then 
		break
	fi
	sleep 30
done

#echo "\n\n"

# TO DO: make file shuffling paths derive from args
rm -f ../data/fines-errors
cat ../data/fines-errors.* >> ../data/fines-errors
rm -f ../data/fines-errors.*
rm -f ../data/fines-output
cat ../data/fines-output.* >> ../data/fines-output
rm -f ../data/fines-output.*
rm -f ../data/fines-patronIds.*

bash format_transitem_fines.sh


