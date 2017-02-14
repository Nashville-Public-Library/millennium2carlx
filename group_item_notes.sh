perl -F'\|' -lane '

# TRIM
	$F[4] =~ s/^\s+//;
	$F[4] =~ s/\s+$//;

# IN TRANSIT NOTE
	$F[4] =~ s/^.*(in transit from).*$/G:IN TRANSIT STATEMENT/i;

# STAFF USE ONLY
	$F[4] =~ s/^.*(check[- ]?out).*(staff only).*$/G:STAFF USE ONLY/i;

# DUMMY CASE
	$F[4] =~ s/^dummy case.*$/G:DUMMY CASE/i;

# ON DISPLAY NOTE
	$F[4] =~ s/^on display.*$/G:ON DISPLAY/i;

# SHELVING INSTRUCTIONS
	$F[4] =~ s/^shelved (as|at|in|under|with).*$/G:SHELVING INSTRUCTIONS/i;

# DAMAGE STATEMENT
	$F[4] =~ s/^.*(binding .*loose|damage|highlighting|pages? (falling|loose)|stain|t(ee|oo)th marks|tear|torn|underlining|writing).*$/G:DAMAGE STATEMENT/i;

# REQUEST FOR STAFF EVALUATION/REPAIR/ACTION
	$F[4] =~ s/^.*last patron (report|sa(ys|id)).*$/G:REQUEST STAFF ACTION/i;

# REPAIRED
	$F[4] =~ s/^.*repaired.*$/G:REPAIRED/i;
	$F[4] =~ s/^.*resurfaced.*$/G:REPAIRED/i;
	$F[4] =~ s/^tested.*\b(fine|ok|works)\b.*/G:REPAIRED/i;

# REPLACED BARCODE
	$F[4] =~ s/^35192\d{9}.*$/G:REPLACED ITEM BARCODE/i;

# NEEDS LABEL
	$F[4] =~ s/^.*needs.*label.*$/G:NEEDS LABEL/i;

# MISSING PARTS STATEMENT
	$F[4] =~ s/^((contains?|include[ds]?)|(\d+?|one|two|three|four|five|six|seven|eight|nine|ten)) .*(books?|cd(-rom)?s?|dis[ck]s?|dvds?|guides?|kindle|maps?|nook|playaways?|sony reader|sound recordings|teacher.?s guide).*missing.*$/G:MISSING PARTS STATEMENT/i;
# PARTS STATEMENT
	$F[4] =~ s/^((contains?|include[ds]?)|(\d+?|one|two|three|four|five|six|seven|eight|nine|ten)) .*(books?|cd(-rom)?s?|dis[ck]s?|dvds?|guides?|kindle|maps?|nook|playaways?|sony reader|sound recordings|teacher.?s guide).*$/G:PARTS STATEMENT/i;

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
