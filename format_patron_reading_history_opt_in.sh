#!/bin/bash

# PREPARE PATRON_READING_HISTORY_OPT_IN.txt

# TO DO: LOOKUP PATRON BARCODE?

perl -F'\t' -lane '
# ADD FINAL PIPE
	$F[1].="|";
# Transform 7 digit record number to Millennium dot number with check digit
# Check digit calculation as per IGR #105781
# http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
	if ($F[0] =~ /^\d+$/) { # DO NOT MUNGE HEADER ROW .bBID0|TRANSCODE|.pPATRONID0|...
		@j = split //, $F[0];
                my $sum;
                for my $k (0 .. $#j) {
                        $sum += $j[$k]*(8-$k);
                }
                $checksum = $sum % 11;
                if ($checksum == 10) { $checksum = "x"; }
                $F[0] = ".p" . $F[0] . $checksum;
	}
print join q/|/, @F;' ../data/patron_reading_history_opt_in.txt > ../data/LOOKUP_PATRON_READING_HISTORY_OPT_IN.txt

rm -f ../data/patron_reading_history_opt_in.txt
rm -f ../data/patron_reading_history_opt_in.dump


