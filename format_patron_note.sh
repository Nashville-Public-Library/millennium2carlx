#!/bin/bash

# JAMES IS GETTING LAZY TOWARD GO LIVE...
# RATHER THAN PARSE THE millennium_extract-05.txt file,
# PARSE THE PATRON_NOTE.txt file

perl -F'\|' -lane '
# DO NOT MIGRATE Patron contact information verification
        if ($F[3] =~ m/^.*((ADDRESS|ID) VERIFIED|(CONTACT|PATRON|PERSONAL)?.*INFO.*(CONFIRM|UPDATE|VERIF)).*/i) {next;}
        if ($F[3] =~ m/^(PLEASE )(CHECK|VERIFY).*$/i) {next;}
        if ($F[3] =~ m/^(DELIVERY FAILED|E-?MAIL (NOTICE )*(RET.D|RETURNED|RTD)|FAILED DELIVERY).*$/i) {next;}
        if ($F[3] =~ m/^MAIL RET.D FROM.*$/i) {next;}

print join q/|/, @F;' ../data/PATRON_NOTE.txt > ../data/PATRON_NOTE_CLEANER.txt

