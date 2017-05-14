#!/bin/bash

# PREPARE TITLE_LEVEL_HOLDS.txt

# TO DO: LOOKUP PATRON BARCODE?

perl -F'\t' -lane '
# ADD FINAL PIPE
	$F[7].="|";
# Transform 7 digit record number to Millennium dot number with check digit
# Check digit calculation as per IGR #105781
# http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
	if ($F[2] =~ /^\d+$/) { # DO NOT MUNGE HEADER ROW .bBID0|TRANSCODE|.pPATRONID0|...
		@j = split //, $F[2];
                my $sum;
                for my $k (0 .. $#j) {
                        $sum += $j[$k]*(8-$k);
                }
                $checksum = $sum % 11;
                if ($checksum == 10) { $checksum = "x"; }
                $F[2] = ".p" . $F[2] . $checksum;
# Transform 7 digit record number to Millennium dot number with check digit
# Check digit calculation as per IGR #105781
# http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
                @j = split //, $F[0];
                my $sum;
                for my $k (0 .. $#j) {
                        $sum += $j[$k]*(8-$k);
                }
                $checksum = $sum % 11;
                if ($checksum == 10) { $checksum = "x"; }
                $F[0] = ".b" . $F[0] . $checksum;
	}
print join q/|/, @F;' ../data/holds.txt > ../data/TITLE_LEVEL_HOLDS.txt

#rm -f ../data/holds.txt
#rm -f ../data/holds.dump


