#!/bin/bash

# PREPARE PATRON_PIN.txt

# TO DO: LOOKUP PATRON BARCODE?

perl -F'\|' -lane '
# ADD FINAL PIPE
	$F[1].="|";
# Transform 7 digit record number to Millennium dot number with check digit
# Check digit calculation as per IGR #105781
# http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
	if ($F[0] =~ /^\d+$/) { # DO NOT MUNGE HEADER ROW .pPATRONID0|PIN0...
		@j = split //, $F[0];
                my $sum;
                for my $k (0 .. $#j) {
                        $sum += $j[$k]*(8-$k);
                }
                $checksum = $sum % 11;
                if ($checksum == 10) { $checksum = "x"; }
                $F[0] = ".p" . $F[0] . $checksum;
	}
print join q/|/, @F;' ../data/validUserPins.txt > ../data/PATRON_PIN.txt

# TO DO: ADD HEADER PATRON|PIN
# TO DO: ADD PATRON BARCODE?
# TO DO: rm files

