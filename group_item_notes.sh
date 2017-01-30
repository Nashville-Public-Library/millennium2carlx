perl -F'\|' -lane '

# IN TRANSIT NOTE
	$F[4] =~ s/^.*(in transit from).*$/G:IN TRANSIT STATEMENT/i;

# STAFF USE ONLY
	$F[4] =~ s/^.*(check[- ]?out).*(staff only).*$/G:STAFF USE ONLY/i;

# DAMAGE STATEMENT
	$F[4] =~ s/^.*(damage|stain).*$/G:DAMAGE STATEMENT/i;

# REPAIRED
	$F[4] =~ s/^.*(repaired).*$/G:REPAIRED/i;
	$F[4] =~ s/^.*(dis[ck]s? resurfaced).*$/G:REPAIRED/i;

# REPLACED BARCODE
	$F[4] =~ s/^35192\d{9}.*$/G:REPLACED ITEM BARCODE/i;

# NEEDS LABEL
	$F[4] =~ s/^.*needs.*label.*$/G:NEEDS LABEL/i;

# PARTS STATEMENT
	$F[4] =~ s/^((contains?|includes?)|(\d+?|one|two|three|four|five|six|seven|eight|nine|ten)) .*(books?|cd(-rom)?s?|dis[ck]s?|dvds?|guides?|kindle|maps?|nook|playaways?|sony reader).*$/G:PARTS STATEMENT/i;

# MISSING FROM HOLDSHELF
	$F[4] =~ s/^.*(missing|not found).*hold[- ]?shelf.*$/G:MISSING FROM HOLDSHELF/i;

# REMOVE DATES
	$F[4] =~ s/^\d{1,2}[-\/.]\d{1,2}[-\/.]\d{2,4}[-: ]*(.+?)$/$1/; # DATE AT START OF NOTE
	$F[4] =~ s/^... ... \d{2} \d{4}( \d{2}:\d{2}[AP]M)?: (.+?)$/$1/; # DATE AT START OF NOTE, III STANDARD
	$F[4] =~ s/\W+\d{1,2}[-\/.]\d{1,2}[-\/.]\d{2,4}.+?$//; # DATE AT END OF NOTE

# TRUNCATE TO 40 CHARACTERS
	$F[4] =~ s/^(.{40}).*?$/$1/; 

	print $F[4]' ../data/ITEM_NOTE.txt > ../data/group_item_notes.txt
sort ../data/group_item_notes.txt | uniq -c | sort -nr > ../data/group_item_notes_count.txt
