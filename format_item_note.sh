#!/bin/bash

# JAMES IS GETTING LAZY TOWARD GO LIVE...
# RATHER THAN PARSE THE millennium_extract-0x.txt file,
# PARSE THE ITEM_NOTE.txt file

perl -F'\|' -lane '
# DO NOT MIGRATE MISSING FROM HOLDSHELF
	if($F[4] =~ m/^.*(missing|not found).*hold[- ]?shelf.*$/i) {next;}
## MIGRATE RESURFACED
##	if ($F[4] =~ s/^.*resurfaced.*$/i)
# DO NOT MIGRATE REPAIRED
	if($F[4] =~ m/^.*repaired.*$/i) {next;}
	if($F[4] =~ m/^tested.*\b(fine|ok|works)\b.*/i) {next;}

print join q/|/, @F;' ../data/ITEM_NOTE.txt > ../data/ITEM_NOTE_CLEANER.txt
#mv -f ../data/ITEM_NOTE_CLEANER.txt ../data/ITEM_NOTE.txt
