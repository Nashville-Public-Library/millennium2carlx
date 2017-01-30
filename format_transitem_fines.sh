#!/bin/bash

# TRANSITEM FINES
# TRANSFORM TRANSITEM FINES DATA TO CARL.X FORMAT
#echo "PROCESSING TRANSITEM FINES"
rm -f ../data/TRANSITEM_FINES.txt
perl -F'\|' -lane '
# TO DO: CHANGE DATE FORMAT ON TIMESTAMP COLUMNS
        print join q/|/, @F' ../data/fines-output > ../data/TRANSITEM_FINES.txt
# PATRON LOOKUP BARCODE [sort by patron] - AND ADD EMPTY COLUMN FOR FINAL PIPE
sort -t'|' -k 4 ../data/TRANSITEM_FINES.txt > ../data/SORTED_TRANSITEM_FINES.txt
join -a 1 -t'|' -1 4 -2 1 -o 1.1 1.2 1.3 1.4 2.3 1.6 1.7 1.8 1.9 1.10 1.11 2.4 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 ../data/SORTED_TRANSITEM_FINES.txt ../data/SORTED_LOOKUP_PATRON.txt > ../data/TRANSITEM_FINES.txt
# ITEM LOOKUP FOR HOLDINGBRANCH, MEDIA, LOCATION - AND ADD EMPTY COLUMN FOR FINAL PIPE
sort -t'|' -k 1 ../data/TRANSITEM_FINES.txt > ../data/SORTED_TRANSITEM_FINES.txt
join -a 1 -t'|' -1 1 -2 1 -o 1.1 2.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 2.4 1.15 2.3 2.5 1.18 1.19 1.20 1.21 1.22 1.23 1.24 ../data/SORTED_TRANSITEM_FINES.txt ../data/SORTED_LOOKUP_ITEM.txt > ../data/TRANSITEM_FINES.txt
# DELETE SORTED	TRANSITEM FINES
rm -f ../data/SORTED_TRANSITEM_FINES

# ADD CARL HEADERS
perl -pi -e 'print "ITEM|ITEMBARCODE|TRANSCODE|PATRONID|PATRONBARCODE|RENEW|PICKUP|TRANSDATE|DUEORNOTNEEDEDAFTERDATE|RETURNDATE|LASTACTIONDATE|BORROWERTYPE|BRANCH|HOLDINGBRANCH|SITE|MEDIA|LOCATION|DATAFLAG1|DATAFLAG3|DATAFLAG4|AMOUNTDEBITED|AMOUNTPAID|NOTES|\n" if $. == 1' ../data/TRANSITEM_FINES.txt

