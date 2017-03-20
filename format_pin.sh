#!/bin/bash

# PREPARE PATRON_PIN.txt

# TO DO: LOOKUP PATRON BARCODE?

# JOHN
cd john-1.8.0/run/
./john --incremental=digits ../../../data/millennium_extract-patronsWithPins.txt > /dev/null 
./john --show ../../../data/millennium_extract-patronsWithPins.txt | awk -F: '{print "."$1"|"$2"|"}' > ../../../data/PATRON_PIN.txt
cd ../../

# ADD CARL.X HEADER PATRONID|PIN
perl -pi -e 'print "PATRONID|PIN|\n" if $. == 1' ../data/PATRON_PIN.txt

# TO DO: rm files
