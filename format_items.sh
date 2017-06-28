#!/bin/bash

# PROCESS ITEM RECORDS

# ITEM LOOKUP, item record id|name|barcode|PTYPE
perl -F'\t' -lane '
        $F[12] =~ s/^((ar|ax|bl|bx|coll|do|ea|eh|ep|gh|go|ha|hi|hm|ill|in|lo|ma|mn|no|oh|pr|prof|ps|rp|se|talib|tl|ts|wp).*?)$/$2|$1/; # BRANCH|LOCATION
	$F[2] eq "" ? $F[2]=substr($F[1],0,9) : $F[2]=$F[2]; # BARCODE [blank] replaced by item record number with i prefix and check digit
	$F[1]=".".$F[1]; # item record id with dot
        print join q/|/, @F[1,2,7,12]' ../data/millennium_extract-03.txt > ../data/LOOKUP_ITEM.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/LOOKUP_ITEM.txt
# SORT LOOKUP_ITEM
sort -t'|' -k 1 ../data/LOOKUP_ITEM.txt > ../data/SORTED_LOOKUP_ITEM.txt

# ITEM.txt
# TIME CONSUMED: ABOUT 3 MINUTES!
# TODO: check each record for pipe characters, e.g., multiple barcodes, multiple call numbers, and figure out how to eliminate them!
perl -F'\t' -lane '
# DO NOT MIGRATE ITEM STATUS $eghlwz
	$F[3] =~ m/[\$eghlwz]/ ? do {next;} : do { 
# DO NOT MIGRATE ITEM STATUS $eglw
#	$F[3] =~ m/[\$eglw]/ ? do {next;} : do { 
		$F[13] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[13] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/; $F[13] =~ s/^[-\s]+$//; # CREATIONDATE
		$F[13] = "||||".$F[13]."|||"; # INSERT 4 BLANK COLUMNS PRECEDING AND 2 BLANK COLUMNS FOLLOWING CREATIONDATE FOR CALL NUMBER BUCKET 1-4; SUPPRESS; SUPPRESS TYPE; AND A FINAL PIPE
		$F[12] =~ s/^((ar|ax|bl|bx|coll|do|ea|eh|ep|gh|go|ha|hi|hm|ill|in|lo|ma|mn|no|oh|pr|prof|ps|rp|se|talib|tl|ts|wp).*?)$/$2|$1/; # INSERT BRANCH VALUE AT COLUMN 13
		$F[12] =~ s/^(nashv)$/mn|$1/; # INSERT BRANCH VALUE AT COLUMN 13 FOR LOCATION=nashv
# DECIDE ON CALL NUMBER VALUE FOR COLUMN 11 > 
# ITEM CALL NUMBER CONTAINS VALUE, BIB CALL NUMBER CONTAINS VALUE OR NOTHING -> ITEM CALL NUMBER 
# ITEM CALL NUMBER BLANK, VALUE IN BIB CALL NUMBER -> BIB CALL NUMBER
		$F[11] =~ s/\|/^/g; # REPLACE PIPES WITH CARETS FOR MULTIPLE CALL NUMBERS. THESE SHOULD BE ELIMINATED BY MIGRATION: https://trello.com/c/DJYHlqn6
		$F[10] eq "" ? $F[10]=$F[27] : do { $F[11]=$F[10]; $F[10]=$F[27]; } ; # REPLACE WITH USERID, which is the unintuitive column header for INTL USE $F[27] as per https://ww2.tlcdelivers.com/helpdesk/default.asp?TicketID=422395&tid=6
# ITEM PRESTAMP AND VOLUME BELONG IN ITEM CALL NUMBER, NOT BUCKETS: https://trello.com/c/dMP5KXLX
		if ($F[18] ne "") { $F[11] = $F[11] . " " . $F[18]; } # VOLUME
		if ($F[17] ne "") { $F[11] = $F[17] . " " . $F[11]; } # PRESTAMP
		$F[9] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[9] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/; $F[9] =~ s/^[-\s]+$//; # EDITDATE
		$F[6]=$F[5]+$F[6]; # CUMULATIVE CIRCULATIONS = TOT CKOUT + TOT RENEW
		$F[5]=""; # HOLDSHISTORY [blank]
		$F[3]=$F[3]."|"; # STATUS|STATUSDATE [blank]
		$F[2] eq "" ? $F[2]=substr($F[1],0,9) : $F[2]=$F[2]; # BARCODE [blank] replaced by item record number with i prefix and check digit
		$F[1]=".".$F[1]; # item record id with dot
		$F[0]=".".$F[0]; # bibliographic record id with dot
	};
	print join q/|/, @F[0..13]' ../data/millennium_extract-03.txt > ../data/ITEM.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/ITEM.txt
# ADD CARL HEADERS
perl -pi -e 'print "BID|ITEM|ITEMBARCODE|STATUS|STATUSDATE|CIRCHISTORY|HOLDSHISTORY|CUMULATIVEHISTORY|MEDIA|PRICE|EDITDATE|USERID|CN|BRANCH|LOCATION|BUCKET1|BUCKET2|BUCKET3|BUCKET4|CREATIONDATE|SUPPRESS|SUPPRESSTYPE|\n" if $. == 1' ../data/ITEM.txt

# ITEM_NOTE_MESSAGE
# TO DO: CATEGORIZE MESSAGES
perl -F'\t' -lane '
	my %month = ("Jan"=>"01",
		"Feb"=>"02",
		"Mar"=>"03",
		"Apr"=>"04",
		"May"=>"05",
		"Jun"=>"06",
		"Jul"=>"07",
		"Aug"=>"08",
		"Sep"=>"09",
		"Oct"=>"10",
		"Nov"=>"11",
		"Dec"=>"12");
	$F[19] eq "" ? do {next;} : do {
	$F[2] eq "" ? $F[2]=substr($F[1],0,9) : $F[2]=$F[2]; # BARCODE [blank] replaced by item record number with i prefix and check digit
	$F[1]=".".$F[1]; # item record id with dot
	@f = split(/\|/,$F[19]);
	foreach(@f) {
		if ( $_ =~ m/^(.*)\b((\d{1,2})[-\/.](\d{1,2})[-\/.](\d{2,4}))(.*)$/ ) {
			if (length($3) == 1) { $notem = "0".$3; } elsif (length($3) == 2) { $notem = $3; }
			if (length($4) == 1) { $noted = "0".$4; } elsif (length($4) == 2) { $noted = $4; }
			if (length($5) == 2) { if (substr($5,0,1) <2) { $notey = "20".$5; } elsif (substr($5,0,1) == 9) { $notey = "19".$5; }} elsif (length($5) == 4) { $notey = $5; }
			$_ = "|1|$notey-$notem-$noted|$1$2$6";
		} elsif ( $_ =~ m/^((?:Sun|Mon|Tue|Wed|Thu|Fri|Sat) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{2}) (\d{4}) ((?:\d{2}):(?:\d{2})(?:AM|PM)))(.+?)$/ ) {
			$notem = $month{$2};
			$noted = $3;
			$notey = $4;
			$notet = $5;
			$_ = "|2|$notey-$notem-$noted $notet|$1$6";
		} else {
			$_ = "|1||$_";
		}
		$_ = $F[1]."|".$F[2].$_."|";
		print $_;
		};
	};
	' ../data/millennium_extract-03.txt > ../data/ITEM_NOTE_MESSAGE.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/ITEM_NOTE_MESSAGE.txt

# ITEM_NOTE_NOTE
# TO DO: CATEGORIZE NOTES
perl -F'\t' -lane '
	my %month = ("Jan"=>"01",
		"Feb"=>"02",
		"Mar"=>"03",
		"Apr"=>"04",
		"May"=>"05",
		"Jun"=>"06",
		"Jul"=>"07",
		"Aug"=>"08",
		"Sep"=>"09",
		"Oct"=>"10",
		"Nov"=>"11",
		"Dec"=>"12");
	$F[24] eq "" ? do {next;} : do {
	$F[2] eq "" ? $F[2]=substr($F[1],0,9) : $F[2]=$F[2]; # BARCODE [blank] replaced by item record number with i prefix and check digit
	$F[1]=".".$F[1]; # item record id with dot
	@f = split(/\|/,$F[24]);
	foreach(@f) {
		if ( $_ =~ m/^(.*)\b((\d{1,2})[-\/.](\d{1,2})[-\/.](\d{2,4}))(.*)$/ ) {
			if (length($3) == 1) { $notem = "0".$3; } elsif (length($3) == 2) { $notem = $3; }
			if (length($4) == 1) { $noted = "0".$4; } elsif (length($4) == 2) { $noted = $4; }
			if (length($5) == 2) { if (substr($5,0,1) <2) { $notey = "20".$5; } elsif (substr($5,0,1) == 9) { $notey = "19".$5; }} elsif (length($5) == 4) { $notey = $5; }
			$_ = "|2|$notey-$notem-$noted|$1$2$6";
		} elsif ( $_ =~ m/^((?:Sun|Mon|Tue|Wed|Thu|Fri|Sat) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{2}) (\d{4}) ((?:\d{2}):(?:\d{2})(?:AM|PM)))(.+?)$/ ) {
			$notem = $month{$2};
			$noted = $3;
			$notey = $4;
			$notet = $5;
			$_ = "|2|$notey-$notem-$noted $notet|$1$6";
		} else {
			$_ = "|2||$_";
		}
		$_ = $F[1]."|".$F[2].$_."|";
		print $_;
		};
	};
	' ../data/millennium_extract-03.txt > ../data/ITEM_NOTE_NOTE.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/ITEM_NOTE_NOTE.txt

# TO DO: MODEL NUMBER
# TO DO: ORDER NUMBER
# TO DO: SERIAL NUMBER

# CONCATENATE ITEM_NOTE FILES
cat ../data/ITEM_NOTE_MESSAGE.txt > ../data/ITEM_NOTE.txt
cat ../data/ITEM_NOTE_NOTE.txt >> ../data/ITEM_NOTE.txt
# ADD CARL HEADERS
perl -pi -e 'print "REFID|ITEMBARCODE|NOTETYPE|TIMESTAMP|TEXT|\n" if $. == 1' ../data/ITEM_NOTE.txt
# REMOVE ITEM NOTE FILES
rm -f ../data/ITEM_NOTE_*.txt

bash format_item_note.sh
