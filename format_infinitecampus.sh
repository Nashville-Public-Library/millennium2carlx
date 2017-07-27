# STUDENTS
perl -F'\|' -lane '

# NORMALIZE DATE VALUE FOR EXPIRATION
#	if ($F[23] =~ /(\d{2})\/(\d{2})\/(\d{4})/) { $F[23] =~ s/(\d{2})\/(\d{2})\/(\d{4})/$3-$1-$2/; }
# CHANGE DATE VALUE FOR EXPIRATION TO 2018-08-04
	$F[23] = "2018-08-04";

# FORMAT AS CSV
	foreach (@F) {
		$_ =~ s/[\n\r]+//g;
		$_ =~ s/^\s+//;
		$_ =~ s/\s+$//;
		if ($_ =~ /,/) {$_ = q/"/ . $_ . q/"/;}
	}
# REPLACE PIPE DELIMITERS WITH COMMAS
	print join q/,/, @F' ../data/CARLX_INFINITECAMPUS_STUDENT.txt > ../data/INFINITECAMPUS_STUDENT.txt;
# REPLACE HEADERS
perl -pi -e '$_ = qq/"Patron ID","Borrower type code","Patron last name","Patron first name","Patron middle name","Patron suffix","Primary Street Address","Primary City","Primary State","Primary Zip Code","Secondary Street Address","Secondary City","Secondary State","Secondary Zip Code","Primary Phone Number","Secondary Phone Number","Alternate ID","Non-validated Stats","Default Branch","Validated Stat Codes","Status Code","Registration Date","Last Action Date","Expiration Date","Email Address","Notes","Birth Date","Guardian","Racial or Ethnic Category","Lap Top Check Out","Limitless Library Use","Tech Opt Out","Teacher ID","Teacher Name"\n/ if ( $. == 1 )' ../data/INFINITECAMPUS_STUDENT.txt

# STAFF
perl -F'\|' -lane '

# ADD EMPTY VALUES TO MATCH PATRON LOADER FORMAT
	@filler = ("","","","","","","","","","","","");
	splice @F, 6, 0, @filler;
	@filler = ("","","","","");
	splice @F, 19, 0, @filler;
	@filler = ("","","","","","","","","");
	splice @F, 25, 0, @filler;

# REMOVE SPECTRUM EMPLOYEES - I.E., REMOVE ALL NON-6-DIGIT EMPLOYEE IDS
	if ($F[0] !~ m/^\d{6}$/) { next; }

# CHANGE DATE VALUE FOR EXPIRATION TO 2018-08-04
	$F[23] = "2018-08-04";

# REMOVE STAFF RECORDS ASSOCIATED WITH usd475.org EMAIL
	if ($F[24] =~ m/usd475\.org/) { next; }

# NORMALIZE ALL DATE VALUES

# FORMAT AS CSV
	foreach (@F) {
		$_ =~ s/[\n\r]+//g;
		$_ =~ s/^\s+//;
		$_ =~ s/\s+$//;
		if ($_ =~ /,/) {$_ = q/"/ . $_ . q/"/;}
	}
# REPLACE PIPE DELIMITERS WITH COMMAS
	print join q/,/, @F' ../data/CARLX_INFINITECAMPUS_STAFF.txt > ../data/INFINITECAMPUS_STAFF.txt;
# REPLACE HEADERS
#perl -pi -e '$_ = qq/"Patron ID","Borrower type code","Patron last name","Patron first name","Patron middle name","Patron suffix","Primary Street Address","Primary City","Primary State","Primary Zip Code","Secondary Street Address","Secondary City","Secondary State","Secondary Zip Code","Primary Phone Number","Secondary Phone Number","Alternate ID","Non-validated Stats","Default Branch","Validated Stat Codes","Status Code","Registration Date","Last Action Date","Expiration Date","Email Address","Notes","Birth Date","Guardian","Racial or Ethnic Category","Lap Top Check Out","Limitless Library Use","Tech Opt Out","Teacher ID","Teacher Name"\n/ if ( $. == 1 )' ../data/INFINITECAMPUS_STAFF.txt

# CONCATENATE STUDENT AND STAFF FILES
cat ../data/INFINITECAMPUS_STUDENT.txt ../data/INFINITECAMPUS_STAFF.txt > ../data/INFINITECAMPUS.txt
