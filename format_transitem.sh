#!/bin/bash

# format_transitem.sh
# TRANSITEM FINES processed in format_transitem_fines.sh

# TRANSITEM HOLDS
perl -F'\t' -lane '
	$F[25] eq "" ? do {next;} : do {
		@H;
	        @H = split(/\|/,$F[25]);
	        foreach(@H) {
			@G;
			@hold = split /, /, $_;
			$G[17] = "||||||" ; # DATAFLAG1|DATAFLAG3|DATAFLAG4|AMOUNTDEBITED|AMOUNTPAID|NOTES|, NOT APPROPRIATE FOR HOLDS
			($G[16],$G[13]) = $F[12] =~ m/^((ar|ax|bl|bx|coll|do|ea|eh|ep|gh|go|ha|hi|hm|ill|in|lo|ma|mn|no|oh|pr|prof|ps|rp|se|talib|tl|ts|wp).*?)$/;
			$G[15] = $F[6]; # MEDIA
			$G[14]; # SITE
			$G[12]; # BRANCH WHERE TRANSACTION OCCURRED, NOT APPROPRIATE FOR HOLDS
			$G[11]; # BORROWERTYPE
			$G[8..10]; # DUEORNOTNEEDEDAFTERDATE, RETURNDATE, LASTACTIONDATE, NOT APPROPRIATE FOR HOLDS
			($G[7]) = @hold[2]=~m/^P=(.+)$/; $G[7] =~ s/^(\d{2})-(\d{2})-(\d{2})$/20$3-$1-$2/; # HOLD PLACED DATE
			($G[6]) = @hold[8]=~m/^PU=(.+)$/; # PICKUP
			$G[5]; # RENEW, NOT APPROPRIATE FOR HOLDS
			$G[4]; # PATRON BARCODE; INSERTED IN join BELOW
			($G[3]) = @hold[0]=~m/^P\#\=(\d+)$/; # PATRON NUMBER patron_num
# Transform 7 digit record number to Millennium dot number with check digit
# Check digit calculation as per IGR #105781
# http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
			@j = split //, $G[3];
			my $sum;
			for my $k (0 .. $#j) {
				$sum += $j[$k]*(8-$k);
			}
			$checksum = $sum % 11;
			if ($checksum == 10) { $checksum = "x"; }
			$G[3] = ".p" . $G[3] . $checksum;
			$F[3] eq "-" ? $G[2] = "R*" : # TRANSCODE - ITEM LEVEL HOLD
			$F[3] eq "t" ? $G[2] = "IH" : # TRANSCODE - IN TRANSIT HOLD
			$F[3] eq "!" ? $G[2] = "H" : # TRANSCODE - HOLD SHELF
			$G[2] = $F[3]; # TRANSCODE = MILLENNIUM ITEM STATUS [probaby f]
			$F[2] eq "" ? $G[1]=substr($F[1],1,9) : $G[1]=$F[2]; # BARCODE [blank] replaced by item record number with i prefix and check digit
			$G[0]=".".$F[1]; # item record id with dot
			print join q/|/, @G;
		};
	}
	' ../data/millennium_extract-03.txt > ../data/TRANSITEM_HOLDS.txt

# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/TRANSITEM_HOLDS.txt
# SORT TRANSITEM_HOLDS
sort -t'|' -k 4 ../data/TRANSITEM_HOLDS.txt > ../data/SORTED_TRANSITEM_HOLDS.txt
# LOOKUP PATRON
join -a 1 -t'|' -1 4 -2 1 -o 1.1 1.2 1.3 1.4 2.3 1.6 1.7 1.8 1.9 1.10 1.11 2.4 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 ../data/SORTED_TRANSITEM_HOLDS.txt ../data/SORTED_LOOKUP_PATRON.txt > ../data/TRANSITEM_HOLDS.txt
# ADD CARL HEADERS
perl -pi -e 'print "ITEM|ITEMBARCODE|TRANSCODE|PATRONID|PATRONBARCODE|RENEW|PICKUP|TRANSDATE|DUEORNOTNEEDEDAFTERDATE|RETURNDATE|LASTACTIONDATE|BORROWERTYPE|BRANCH|HOLDINGBRANCH|SITE|MEDIA|LOCATION|DATAFLAG1|DATAFLAG3|DATAFLAG4|AMOUNTDEBITED|AMOUNTPAID|NOTES|\n" if $. == 1' ../data/TRANSITEM_HOLDS.txt

# TRANSITEM CHECKOUT
perl -F'\t' -lane '
	$F[10] =~ s/^((ar|ax|bl|bx|coll|do|ea|eh|ep|gh|go|ha|hi|hm|ill|in|lo|ma|mn|no|oh|pr|prof|ps|rp|se|talib|tl|ts|wp|).*?)$/$2||$F[11]|$1|||||||/;
	$F[8] = "||";
	$F[7] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[7] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/; $F[7] =~ s/^[-\s]+$//;
	$F[6] =~ s/^(\d{2})-(\d{2})-(\d{2})( \d{1,2}:\d{2})*$/19$3-$1-$2$4/; $F[6] =~ s/^(\d{2})-(\d{2})-(\d{4})( \d{1,2}:\d{2})*$/$3-$1-$2$4/; $F[6] =~ s/^[-\s]+$//;
	$F[5] =~ s/^(.*?)$/$1|/;
	$F[4] !~ /\|/ ? do { $F[4] = $F[4] ; }
		: do { $F[4] =~ m/^(?:.+\|)*(190\d{6})(?:\||$)(?:.+?)*$/ ? do { $F[4] =~ s/^(?:.+\|)*(190\d{6})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 190\d{6} BARCODE
			: do { $F[4] =~ m/^(?:.+\|)*(\d{6})(?:\||$)(?:.+?)*$/ ? do { $F[4] =~ s/^(?:.+\|)*(\d{6})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST \d{6} BARCODE
				: do { $F[4] =~ m/^(?:.+\|)*(25190\d{9})(?:\||$)(?:.+?)*$/ ? do { $F[4] =~ s/^(?:.+\|)*(25190\d{9})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 25190\d{9} BARCODE
					: do { $F[4] =~ m/^(?:.+\|)*(25192\d{9})(?:\||$)(?:.+?)*$/ ? do { $F[4] =~ s/^(?:.+\|)*(25192\d{9})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 25192\d{9} BARCODE
						: do { $F[4] =~m/^(?:.+\|)*(\d{7})(?:\||$)(?:.+?)*$/ ? do { $F[4] =~ s/^(?:.+\|)*(\d{7})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST \d{7} BARCODE
							: do { $F[4] = $F[4] ; }
	;};};};};};
	$F[3]=".".$F[3]; # patron record id with dot
	$F[1] eq "" ? $F[1]=substr($F[0],0,9) : $F[1]=$F[1]; # BARCODE [blank] replaced by item record number with i prefix and check digit
	$F[0]=".".$F[0]; # item record id with dot
	print join q/|/, @F[0..10]' ../data/millennium_extract-04.txt > ../data/TRANSITEM_CHECKOUT.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/TRANSITEM_CHECKOUT.txt
# ADD CARL HEADERS
perl -pi -e 'print "ITEM|ITEMBARCODE|TRANSCODE|PATRONID|PATRONBARCODE|RENEW|PICKUP|TRANSDATE|DUEORNOTNEEDEDAFTERDATE|RETURNDATE|LASTACTIONDATE|BORROWERTYPE|BRANCH|HOLDINGBRANCH|SITE|MEDIA|LOCATION|DATAFLAG1|DATAFLAG3|DATAFLAG4|AMOUNTDEBITED|AMOUNTPAID|NOTES|\n" if $. == 1' ../data/TRANSITEM_CHECKOUT.txt

