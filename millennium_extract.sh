#!/usr/bin/bash

# MILLENNIUM_EXTRACT.sh
# James Staub
# Nashville Public Library
# MILLENNIUM->CARL.X MIGRATION DATA EXTRACTION
# Millennium 2014 2.0.0_15

# DELETE FILES FROM SOLARIS LEST OLD FILES GET APPENDED
expect cleanup.exp

# GET AUTHORITY FILE
expect get_authority.exp &

# GET BIBLIOGRAPHIC FILE
expect get_bibliographic.exp &

# GET TITLE LEVEL HOLDS
expect get_title_level_holds.exp &

# GET CODES LISTS
expect get_codes.exp &

# GET ITEMS (NOT BACKGROUND!)
expect get_items.exp

# GET PATRONS (NOT BACKGROUND!)
expect get_patrons.exp

# MONITOR BACKGROUND EXPECT GET_*.EXP PROCESSES. BIBLIOGRAPHIC SHOULD BE THE LAST TO FINISH
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

# COMPRESS FILES
bash 7z.sh

# DELIVER FILES

exit
