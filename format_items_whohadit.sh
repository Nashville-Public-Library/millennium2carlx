#!/usr/bin/bash

# ITEM_WHOHADIT.txt
perl -F'\t' -lane '
        # If there is 0 instead of patron number in the 17th column, skip it!
        $F[16] eq "0" ? do {next;} : do {
# Transform 7 digit record number to Millennium dot number with check digit
# Check digit calculation as per IGR #105781
# http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
                @j = split //, $F[16];
                my $sum;
                for my $k (0 .. $#j) {
                        $sum += $j[$k]*(8-$k);
                }
                $checksum = $sum % 11;
                if ($checksum == 10) { $checksum = "x"; }
                $F[16] = ".p" . $F[16] . $checksum;
                $F[15] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[15] =~ s/^(\d{2})-(\d{2})-(\d{4})( \d{1,2}:\d{2})*$/$3-$1-$2$4/; $F[15] =~ s/^[-\s]+$//;
                $F[14] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[14] =~ s/^(\d{2})-(\d{2})-(\d{4})( \d{1,2}:\d{2})*$/$3-$1-$2$4/; $F[14] =~ s/^[-\s]+$//;
		$F[2] eq "" ? $F[2]=substr($F[1],0,9) : $F[2]=$F[2]; # BARCODE [blank] replaced by item record number with i prefix and check digit
		$F[1]=".".$F[1]; # item record id with dot
        };
	print join q/|/, @F[1,2,14..16]' ../data/millennium_extract-03.txt > ../data/ITEM_WHOHADIT.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/ITEM_WHOHADIT.txt
# SORT ITEM_WHOHADIT
sort -t'|' -k 5 ../data/ITEM_WHOHADIT.txt > ../data/SORTED_ITEM_WHOHADIT.txt
# LOOKUP PATRON - AND ADD EMPTY COLUMNS
join -a 1 -t'|' -1 5 -2 1 -o 1.1 1.2 1.3 1.4 1.5 2.3 2.2 2.5 2.5 ../data/SORTED_ITEM_WHOHADIT.txt ../data/SORTED_LOOKUP_PATRON.txt > ../data/ITEM_WHOHADIT.txt
# DELETE SORTED_ITEM_WHOHADIT
rm -f ../data/SORTED_ITEM_WHOHADIT.txt
# ADD CARL HEADERS
perl -pi -e 'print "REFID|ITEMBARCODE|CHARGEDATE|RETURNDATE|PATRONID|PATRONBARCODE|PATRONNAME|PATRONALTID|\n" if $. == 1' ../data/ITEM_WHOHADIT.txt

