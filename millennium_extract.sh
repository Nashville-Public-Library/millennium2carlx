#!/usr/bin/bash

# MILLENNIUM_EXTRACT.sh
# James Staub
# Nashville Public Library
# MILLENNIUM->CARL.X MIGRATION DATA EXTRACTION
# Millennium 2014 2.0.0_15

echo "fix get_patrons_with_fines.exp\n"
echo "fix get_patrons.exp\n"
echo "fix get_bibliographic.exp - the format isn't launching?\n"
#exit

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

# GET PINS (NOT BACKGROUND INITIALLY!)
expect get_pins.exp
./format_pin.sh &

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

# COMPRESS FILES SHOULD WAIT UNTIL fines.sh IS COMPLETE
# bash 7z.sh

# DELIVER FILES
# expect sftp2tlc.exp

exit
