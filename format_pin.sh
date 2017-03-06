#!/bin/bash

# PREPARE PATRON_PIN.txt

# TO DO: LOOKUP PATRON BARCODE?

# FOR NOW...
cd john-1.8.0/run/
./john --show ../../../data/20170217_millennium_patrons_with_pins.txt | awk -F: '{print "."$1"|"$2"|"}' > ../../../data/PATRON_PIN.txt
cd ../../

# ADD CARL.X HEADER PATRON|PIN
perl -pi -e 'print "PATRON|PIN|\n" if $. == 1' ../data/PATRON_PIN.txt

# TO DO: rm files

