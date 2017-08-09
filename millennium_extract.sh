#!/usr/bin/bash

# MILLENNIUM_EXTRACT.sh
# James Staub
# Nashville Public Library
# MILLENNIUM->CARL.X MIGRATION DATA EXTRACTION
# Millennium 2014 2.0.0_15

# DELETE FILES FROM SOLARIS LEST OLD FILES GET APPENDED
expect cleanup.exp

# GET INFINITE CAMPUS
# expect get_infinitecampus.exp &

# GET AUTHORITY FILE
expect get_authority.exp &

# GET BIBLIOGRAPHIC FILE
expect get_bibliographic.exp &

# GET TITLE LEVEL HOLDS
expect get_title_level_holds.exp &

# GET CODES LISTS
expect get_codes.exp &

# GET PATRONS READING HISTORY OPT IN
expect get_patron_reading_history_opt_in.exp &

# GET PINS (NOT BACKGROUND INITIALLY!)
sleep 1
expect get_pins.exp
bash format_pin.sh &

# GET ITEMS (NOT BACKGROUND!)
expect get_items.exp

# GET PATRONS (NOT BACKGROUND!)
expect get_patrons.exp

# ENSURE RELEVANT PROCESSES HAVE COMPLETED

# DETERMINE WHETHER FINES EXTRACT IS RUNNING
while pgrep -f 'bash fines.sh' | wc -l >/dev/null
do
	BFINES=$(pgrep -f 'bash fines.sh' | wc -l)
	if [[ $BFINES = 0 ]] ; then
		break
	fi
	sleep 30
done

# MONITOR BACKGROUND EXPECT GET_*.EXP PROCESSES. BIBLIOGRAPHIC SHOULD BE THE LAST TO FINISH
# ALL SHOULD FINISH LONG BEFORE FINES BUT FORMAT_PATRONS.SH WILL WAIT ON FINES TO COMPLETE
while pgrep -f 'expect get_' | wc -l >/dev/null
do
        PROCS=$(pgrep -f 'expect get_' | wc -l)
#       echo -ne "still running: $PROCS\r"
        if [[ $PROCS = 0 ]] ; then
                break
        fi
        sleep 30
done

# DELETE FILES FROM SOLARIS 
expect cleanup.exp

# SET ALL DATA FILES TO CHMOD 700
chmod 700 ../data/*

# REPORT
bash report.sh >> ../data/millennium_extract.log

# COMPRESS FILES SHOULD WAIT UNTIL fines.sh IS COMPLETE
bash 7z.sh

# DELIVER FILES
expect sftp2tlc.exp

exit
