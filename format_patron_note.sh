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
# DO NOT MIGRATE PATRON LIBRARY CARD NOTES
	if ($F[3] =~ m/^.*2?5?192\d{9}.*$/i) {next;} # (DAMAGE|LC|LST|LOST|REPLACE|STOLEN|WORN)
	if ($F[3] =~ m/^card reported (lost|stolen).*$/i) {next;}
	if ($F[3] =~ m/^card (@|at|found|held|is at|in|left).*$/i) {next;}
	if ($F[3] =~ m/^(online (- )?)?ca?rd mail.*$/i) {next;}
# DO NOT MIGRATE MNPS REGISTRATION
	if($F[3] =~ m/^(EDUCATOR CARD APP).+?$/i) {next;}
	if($F[3] =~ m/^(MNPS EDUCATOR \d{6}).+?$/i) {next;}
	if($F[3] =~ m/^(MNPS STUDENT( \d{9})*\; SCHOOL).+?$/i) {next;}
# DO NOT MIGRATE OFF-SITE REGISTRATION
	if($F[3] =~ m/^(APPLICATION OBTAINED THROUGH GROW|BBTL|BOOTH|BRINGING BOOKS TO LIFE|EVENT REGISTRATION|MAYOR.S FIRST DAY OUT|OUTREACH\:|REGISTRATION AT).+?$/i) {next;}

print join q/|/, @F;' ../data/PATRON_NOTE.txt > ../data/PATRON_NOTE_CLEANER.txt
mv -f ../data/PATRON_NOTE_CLEANER.txt ../data/PATRON_NOTE.txt
