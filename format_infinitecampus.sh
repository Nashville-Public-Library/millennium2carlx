perl -F'\|' -i.bak -lane '
	$F[0] !~ m/^\d{6}$/ ? do {next;} :
	print join q/|/, @F' ../data/CARLX_INFINITECAMPUS_STAFF.txt;

