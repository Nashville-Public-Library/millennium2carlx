#!/bin/bash

# PROCESS BRANCH CODES
# Main regex to print only Branches
perl -lp -e 's/^((?!\d)[^\n]+|\d{3} > (?!talib)[\S]{5}[^\n]+)$//' ../data/millennium_extract-01.txt > ../data/BRANCH.txt
# Delete multiple newlines
perl -0777 -pi -e 's/\n\n+/\n/g' ../data/BRANCH.txt
# Delete top newline
perl -0777 -pi -e 's/^\n//' ../data/BRANCH.txt
# Reformat lines for TLC
perl -lpi -e 's/^\d{3} > (.{5})\s{5}([^\n]+)$/|$1|$2|/' ../data/BRANCH.txt
# Add header row
perl -pi -e 'print "BRANCHNUMBER|BRANCHCODE|BRANCHNAME|\n" if $. == 1' ../data/BRANCH.txt

# PROCESS LOCATION CODES
perl -lp -e 's/^(?!\d)[^\n]+$//' ../data/millennium_extract-01.txt > ../data/LOCATION.txt
# Delete multiple newlines
perl -0777 -pi -e 's/\n\n+/\n/g' ../data/LOCATION.txt
# Delete top newline
perl -0777 -pi -e 's/^\n//' ../data/LOCATION.txt
# Reformat lines for TLC
perl -lpi -e 's/^\d{3} > (.{5})\s{5}([^\n]+)$/|$1|$2|/' ../data/LOCATION.txt
# Add header row
perl -pi -e 'print "LOCNUMBER|LOCCODE|LOCNAME|\n" if $. == 1' ../data/LOCATION.txt

# PREPARE FIXED LENGTH CODES FILE
perl -lp -e 's/^(\s{77,79}\d+|\s+FIXED LENGTH CODES\s*|\s+NAME\s+CODE\s+MEANING\s*)$//' ../data/millennium_extract-02.txt > ../data/FIXED_LENGTH_CODES.txt
# Move Fixed-field label
perl -lpi -e 's/^(\d+ > [^\n]+?)\s\s+([^\n]+?)\s\s+([^\n]+?)\s*$/$1\n$2\t$3/' ../data/FIXED_LENGTH_CODES.txt
# Remove leading whitespace from codes
perl -lpi -e 's/^\s+([\S]|\d{3})\s+/$1\t/' ../data/FIXED_LENGTH_CODES.txt
# Delete ^L Form Feed
perl -lpi -e 's/\f//g' ../data/FIXED_LENGTH_CODES.txt
# Delete multiple newlines
perl -0777 -pi -e 's/\n\n+/\n/g' ../data/FIXED_LENGTH_CODES.txt

# PROCESS P TYPE CODES -> BTY
perl -0777 -p -e 's/^.+\n\d+ > P TYPE\s*(.+?)\s*\n\d+ > \S+.+$/$1/s' ../data/FIXED_LENGTH_CODES.txt > ../data/BTY.txt
# Reformat lines for TLC
perl -lpi -e 's/^(\d+)\t(.+?)\s*$/$1||$2|/' ../data/BTY.txt
# Add header row
perl -pi -e 'print "BTYNUMBER|BTYCODE|BTYNAME|\n" if $. == 1' ../data/BTY.txt

# PROCESS I TYPE CODES -> MEDIA
perl -0777 -p -e 's/^.+\n\d+ > I TYPE\s*(.+?)\s*\n\d+ > \S+.+$/$1/s' ../data/FIXED_LENGTH_CODES.txt > ../data/MEDIA.txt
# Reformat lines for TLC
perl -lpi -e 's/^(\d+)\t(.+?)\s*$/$1||$2|/' ../data/MEDIA.txt
# Add header row
perl -pi -e 'print "MEDNUMBER|MEDCODE|MEDNAME|\n" if $. == 1' ../data/MEDIA.txt

