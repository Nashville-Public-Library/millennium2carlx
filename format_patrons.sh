#!/bin/bash

# PATRON LOOKUP, patron record id|name|barcode|PTYPE
perl -F'\t' -lane '
        $F[15] !~ /\|/ ? do { $F[15] = $F[15] ; }
                : do { $F[15] =~ m/^(?:.+\|)*(190\d{6})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(190\d{6})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 190\d{6} BARCODE
                        : do { $F[15] =~ m/^(?:.+\|)*(\d{6})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(\d{6})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST \d{6} BARCODE
                                : do { $F[15] =~ m/^(?:.+\|)*(25190\d{9})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(25190\d{9})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 25190\d{9} BARCODE
                                        : do { $F[15] =~ m/^(?:.+\|)*(25192\d{9})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(25192\d{9})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 25192\d{9} BARCODE
                                                : do { $F[15] =~m/^(?:.+\|)*(\d{7})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(\d{7})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST \d{7} BARCODE
                                                        : do { $F[15] = $F[15] ; }
        ;};};};};};
	# SIMPLE PATRON NAME PARSING: GRAB THE FIRST FULL NAME
        $F[3] =~ s/^([^|]+?)\|.+?$/$1/;
	$F[0]=".".$F[0]; # patron record id with dot
        print join q/|/, @F[0,3,15,1]' ../data/millennium_extract-05.txt > ../data/LOOKUP_PATRON.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/LOOKUP_PATRON.txt
# SORT PATRON LOOKUP TABLE
sort -t'|' -k 1 ../data/LOOKUP_PATRON.txt > ../data/SORTED_LOOKUP_PATRON.txt

# PATRON.txt
perl -F'\t' -lane '
# 20170306 MILLENNIUM GUARDIAN/GUARANTOR INFORMATION MOVED CARL.X TARGET FIELD FROM SPONSOR TO PATRON NOTE
#        $F[18] =~ s/\|/^/g; $F[18] .= "|"; # SPONSOR AND FINAL PIPE
	$F[18] = "|"; # SPONSOR [BLANK] AND FINAL PIPE
# COLLECTIONSTATUS
        $F[2] eq "c" ? do {$COLLECTIONSTATUS = "2";} : ($F[1] =~ /^(0|2|3|4|5|6|12|15|30)$/ ? do {$COLLECTIONSTATUS = "1";} : do {$COLLECTIONSTATUS = "78"});
        $F[17] = "$COLLECTIONSTATUS|$F[17]";
#
        $F[14] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/; $F[14] =~ s/^[-\s]+$//;
#
        $F[13] eq "a" || $F[13] eq "p" ? do {$F[13]="0";} : ($F[12] ne "" ? do {$F[13]="1";} : do {$F[13]="0";});
        $F[13] ="1|$F[13]";
#
        $F[12] =~ s/[,|]/^/g; $F[12] =~ s/\s//g;
# PHONE
	$allPhone = "$F[10]|$F[11]"; 
	$allPhone =~ s/^\|+//g;
	$allPhone =~ s/\|+$//g;
	$allPhone =~ s/(?:^|\|)#+[^|]*?(?:\||$)//g; # Remove all ## Millennium phone numbers
	$allPhone =~ s/[^\d|]//g;
	@phones = split(/\|/, $allPhone); 
	@phones = grep { length($_) == 7 || length($_) == 10 } @phones;
	if (length @phones[0] == 7) {
		@phones[0] = "615@phones[0]";
	}
	if (length @phones[0] == 10) {
		@phones[0] =~ s/^(\d{3})(\d{3})(\d{4})$/$1-$2-$3/;
		$F[10] = @phones[0];
	} else {
		$F[10] = "";
	}
	if (length @phones[1] == 7) {
		@phones[1] = "615@phones[0]";
	}
	if (length @phones[1] == 10) {
		@phones[1] =~ s/^(\d{3})(\d{3})(\d{4})$/$1-$2-$3/;
		$F[11] = @phones[1];
	} else {
		$F[11] = "";
	}
# USERID IS READING HISTORY OPT IN, Y or N : https://trello.com/c/x9BBcGph
# USERID DEFAULT VALUE IS "N"
# USERID Y FOR APPROPRIATE PATRONS POPULATED IN JOIN BELOW
	$F[10] = "N|$F[10]";
# EDITDATE
        $F[9] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/;
# ACTDATE
        $F[8] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/; $F[8] =~ s/^[-\s]+$//;
# EXPDATE
        $F[7] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[7] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/; $F[7] =~ s/^[-\s]+$//;
# REGDATE
        $F[6] =~ s/^(\d{2})-(\d{2})-(\d{2})$/19$3-$1-$2/; $F[6] =~ s/^(\d{2})-(\d{2})-(\d{4})$/$3-$1-$2/;
# ADDRESSES
	$F[5] =~ s/^(\$,\|)*([^|]+?)(\|.*)*$/$2/; # GRAB ONLY THE TOPMOST G/ML ADDR
	$F[4] eq "" && $F[5] ne "" ? $F[4] = $F[5] : do {}; # IF ADDRESS IS EMPTY GRAB G/ML ADDR
	$F[5] = "|||"; # MAKE SECONDARY ADDRESS BLANK
        $F[4] =~ s/^(\$,\|)*([^|]+?)(\|.*)*$/$2/; # GRAB ONLY THE TOPMOST ADDRESS
	$F[4] =~ /^(.*)\$(.+?)[,\s]*\b([A-Za-z]{2})\b[,\s]*(\d{5}-*\d*)\s*$/
		? do { 
			$F[4] =~ s/^(.*)\$(.+?)[,\s]*\b([A-Za-z]{2})\b[,\s]*(\d{5}-*\d*)\s*$/$1|$2|$3|$4/; 
			$F[4] =~ s/\$/, /g;
		}
		: do { $F[4] = "$F[4]|||"; } ;
# PATRON NAME
# TO DO: WORK WITH BOB ON NAME PARSING, E.G., ENSURE WE GRAB PREFERRED AND ID TRANSCRIPTION NAME
	$topName = $F[3];
        $topName =~ s/^([^|]+?)\|.+?$/$1/; # GRABS ONLY THE TOPMOST PATRON NAME
	$topName =~ s/^#+//; # ELIMINATE leading octothorpes # from name
	$topName =~ s/\s\s+/\s/g; 
#	$F[1] eq "4" || $F[1] eq "8" # EXCLUDE INSTITUTIONS AND ILL LIBRARIES FROM NAME PARSING
	$F[1] eq "8" # ILL LIBRARIES NAME PARSING
		? do { $topName = "$topName|||"; }
		: do {
			$last="";$penultimate="";$first="";$middle="";$suffix="";
			# capture suffixes, excepting I, V, X which are likely to be initials
			$topName =~ s/\s*\b(1ST|2ND|3RD|4TH|5TH|6TH|7TH|8TH|9TH|II|III|IV|JR|SR|VI|VII|VIII|IX)\b\.*//i
				? do { $suffix = $1 ; }
				: do { $suffix = "" ; } ;
			$topName =~ m/^([^,]+?),\s*(.+?)$/
				? do {
					$last = $1;
					$penultimate = $2;
					$penultimate =~ /^(\S+?)\s+?(\S+?)$/
						? do { $first = $1 ; $middle = $2 ; }
						: do { $first = $penultimate ; } ;
				}
				: do { $last = $topName; $first = ""; $middle = "" } ;
			if ($F[3] =~ m/(^|\|)#+/ ) { $last = "##" . $last; }
			$topName = "$last|$first|$middle|$suffix";
		};
	$F[3] = "N|$topName";
# PATRONBARCODE
        $F[15] !~ /\|/ ? do { $F[15] = $F[15] ; }
                : do { $F[15] =~ m/^(?:.+\|)*(190\d{6})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(190\d{6})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 190\d{6} BARCODE
                        : do { $F[15] =~ m/^(?:.+\|)*(\d{6})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(\d{6})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST \d{6} BARCODE
                                : do { $F[15] =~ m/^(?:.+\|)*(25190\d{9})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(25190\d{9})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 25190\d{9} BARCODE
                                        : do { $F[15] =~ m/^(?:.+\|)*(25192\d{9})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(25192\d{9})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST 25192\d{9} BARCODE
                                                : do { $F[15] =~m/^(?:.+\|)*(\d{7})(?:\||$)(?:.+?)*$/ ? do { $F[15] =~ s/^(?:.+\|)*(\d{7})(?:\||$)(?:.+?)*$/$1/;} # PICK THE LAST \d{7} BARCODE
                                                        : do { $F[15] = $F[15] ; }
        ;};};};};};
        $F[0] .= "|$F[15]"; # ADD PATRON BARCODE COLUMN
	$F[0]=".".$F[0]; # patron record id with dot
        $F[15] = ""; # REMOVE PATRON BARCODE VALUE FROM ALTID

        print join q/|/, @F[0..18];' ../data/millennium_extract-05.txt > ../data/PATRON.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/PATRON.txt
# SORT PATRON files for join
sort -t'|' -k 1 ../data/PATRON.txt > ../data/SORTED_PATRON.txt
sort -t'|' -k 1 ../data/LOOKUP_PATRON_READING_HISTORY_OPT_IN.txt > ../data/SORTED_LOOKUP_PATRON_READING_HISTORY_OPT_IN.txt
# LOOKUP PATRON READING HISTORY
join -a 1 -t'|' -j 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 2.2 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.30 1.31 1.32 1.33 ../data/SORTED_PATRON.txt ../data/SORTED_LOOKUP_PATRON_READING_HISTORY_OPT_IN.txt > ../data/PATRON.txt
# INSERT CARL HEADERS
perl -pi -e 'print "PATRONID|PATRONBARCODE|BTY|STATUS|ADDR|LAST NAME|FIRST NAME|MIDDLE NAME|SUFFIX|STREET1|CITY1|STATE1|ZIP1|STREET2|CITY2|STATE2|ZIP2|REGDATE|EXPDATE|ACTDATE|EDITDATE|USERID|PH1|PH2|EMAIL|LANGUAGE|EMAILNOTICES|BIRTHDATE|ALTERNATEID|DEFAULTBRANCH|COLLECTIONSTATUS|PREFERRED_BRANCH|SPONSOR|\n" if $. == 1' ../data/PATRON.txt

# PATRON_NOTE.txt

# PATRON NOTE GUARANTOR/GUARDIAN
perl -F'\t' -lane '
        $F[18] eq "" ? do {next;} : do {
		$F[0]=".".$F[0]; # patron record id with dot
                @f = split(/\|/,$F[18]);
                foreach(@f) {
                        $_ = "|600||$_";
                        $_ = $F[0].$_."|";
                        print $_;
                };
        };
	' ../data/millennium_extract-05.txt > ../data/PATRON_NOTE_GUARANTOR.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/PATRON_NOTE_GUARANTOR.txt

# PATRON NOTE MESSAGE
# TO DO : CATEGORIZE MESSAGES
perl -F'\t' -lane '
        $F[19] eq "" ? do {next;} : do {
		$F[0]=".".$F[0]; # patron record id with dot
                @f = split(/\|/,$F[19]);
                foreach(@f) {
                        if ( $_ =~ m/^(.*)\b((\d{1,2})[-\/.](\d{1,2})[-\/.](\d{2,4}))(.*)$/ ) {
                                if (length($3) == 1) { $notem = "0".$3; } elsif (length($3) == 2) { $notem = $3; }
                                if (length($4) == 1) { $noted = "0".$4; } elsif (length($4) == 2) { $noted = $4; }
                                if (length($5) == 2) { if (substr($5,0,1) <2) { $notey = "20".$5; } elsif (substr($5,0,1) == 9) { $notey = "19".$5; }} elsif (length($5) == 4) { $notey = $5; }
                                $_ = "|800|$notey-$notem-$noted|$1$2$6";
                        } else {
                                $_ = "|800||$_";
                        }
                        $_ = $F[0].$_."|";
                        print $_;
                };
        };
	' ../data/millennium_extract-05.txt > ../data/PATRON_NOTE_MESSAGE.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/PATRON_NOTE_MESSAGE.txt

# PATRON NOTE NOTE
# TO DO : CATEGORIZE NOTES
perl -F'\t' -lane '
        $F[20] eq "" ? do {next;} : do {
		$F[0]=".".$F[0]; # patron record id with dot
                @f = split(/\|/,$F[20]);
                foreach(@f) {
			$NOTETYPE = "";
			# APPROVED USER
	        	if ( $_ =~ s/^\s*\"*(.*?)\"*(?:[-.:]*\s*(?:ARE|IS|AN)*\s*(?:APPROV(?:AL|E|ED|ER)|AUTHORIZED)\s+USE(?:D|R)*S*(?: ON THIS ACC\S+)*[-.:]*)(.*)\s*$/APPROVED USER: $1$2/i ) {
				$_ =~ s/  +/ /g;
				$NOTETYPE = "110";
			}
# TO DO: determine whether a single date is USER DOB or staffer note entry. Right way? only accept a date more recent than the created date
                        if ( $_ =~ m/^(.*)\b((\d{1,2})[-\/.](\d{1,2})[-\/.](\d{2,4}))(.*)?$/ ) {
                                if (length($3) == 1) { $notem = "0".$3; } elsif (length($3) == 2) { $notem = $3; }
                                if (length($4) == 1) { $noted = "0".$4; } elsif (length($4) == 2) { $noted = $4; }
                                if (length($5) == 2) { if (substr($5,0,1) <2) { $notey = "20".$5; } elsif (substr($5,0,1) == 9) { $notey = "19".$5; }} elsif (length($5) == 4) { $notey = $5; }
                                $_ = "|$NOTETYPE|$notey-$notem-$noted|$1$2$6";
                        } else {
                                $_ = "|$NOTETYPE||$_";
                        }
                        $_ = $F[0].$_."|";
                        print $_;
                };
        };
	' ../data/millennium_extract-05.txt > ../data/PATRON_NOTE_NOTE.txt
# REMOVE MILLENNIUM HEADERS
perl -pi -e '$_ = "" if ( $. == 1 )' ../data/PATRON_NOTE_NOTE.txt
# CONCATENATE ALL PATRON_NOTE FILES
cat ../data/PATRON_NOTE_GUARANTOR.txt > ../data/PATRON_NOTE.txt
cat ../data/PATRON_NOTE_MESSAGE.txt >> ../data/PATRON_NOTE.txt
cat ../data/PATRON_NOTE_NOTE.txt >> ../data/PATRON_NOTE.txt
# REMOVE PATRON NOTE FILES
rm -f ../data/PATRON_NOTE_*.txt
# ADD CARL HEADERS
perl -pi -e 'print "REFID|NOTETYPE|TIMESTAMP|TEXT|\n" if $. == 1' ../data/PATRON_NOTE.txt
