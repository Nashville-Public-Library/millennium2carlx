perl -F'\|' -lane '

	if ($F[1] ne "") {next;}

# APPROVED USER
	$F[3] =~ s/^.*(APPROVED|AUTHORIZED) USER.*$/G:APPROVED USER/i;

# VERIFIED ADDRESS WITHIN LIBRARY SERVICE AREA
	$F[3] =~ s/.*(IN DAVIDSON CO|GO CITY LIMIT|WITHIN GOODLETTSVILLE).*/G:VERIFIED ADDRESS WITHIN LIBRARY SERVICE AREA/i;

# TRANSITIONAL HOUSING
	$F[3] =~ s/^s*31\s*Lindsley.*$/G:TRANSITIONAL HOUSING NOTE/i; # Restoration House
	$F[3] =~ s/^s*99\s*Spring.*$/G:TRANSITIONAL HOUSING NOTE/i; # Knights Inn
	$F[3] =~ s/^s*102\s*Cude.*$/G:TRANSITIONAL HOUSING NOTE/i; # Recovery Within Reach
	$F[3] =~ s/^s*102\s*Graeme.*$/G:TRANSITIONAL HOUSING NOTE/i; # Women of Worth Transitional Home (WOW)
	$F[3] =~ s/^s*109\s*Eve.s Cir.*$/G:TRANSITIONAL HOUSING NOTE/i; # Eagles Nest
	$F[3] =~ s/^s*111\s*N(o(rth)?)? 1st St.*$/G:TRANSITIONAL HOUSING NOTE/i; # TrAvl Centers of America
	$F[3] =~ s/^s*118\s*Emmitt.*$/G:TRANSITIONAL HOUSING NOTE/i; # Madison Square Inn Motel
	$F[3] =~ s/^s*120\s*Rayon.*$/G:TRANSITIONAL HOUSING NOTE/i; # Recovery Within Reach
	$F[3] =~ s/^s*128\s*8th Ave? S .*$/G:TRANSITIONAL HOUSING NOTE/i; # The Next Door
	$F[3] =~ s/^s*140\s*N(o(rth)?)? 1st St.*$/G:TRANSITIONAL HOUSING NOTE/i; # Salvation Army
	$F[3] =~ s/^s*146\s*Green.*$/G:TRANSITIONAL HOUSING NOTE/i; # UNKNOWN
	$F[3] =~ s/^s*148\s*Luna.*$/G:TRANSITIONAL HOUSING NOTE/i; # Peace Unlimited in Recovery
	$F[3] =~ s/^s*177\s*1st Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Nashville Downtown Hostel
	$F[3] =~ s/^s*208\s*Glenrose.*$/G:TRANSITIONAL HOUSING NOTE/i; # Operation Stand Down
	$F[3] =~ s/^s*220\s*Raymond.*$/G:TRANSITIONAL HOUSING NOTE/i; # Turning Point Recovery
	$F[3] =~ s/^s*229\s*Largo.*$/G:TRANSITIONAL HOUSING NOTE/i; # Layman Lessons Inc. Rehab Services
	$F[3] =~ s/^s*242\s*Wiley.*$/G:TRANSITIONAL HOUSING NOTE/i; # Recovery Community
	$F[3] =~ s/^s*302\s*Lutie.*$/G:TRANSITIONAL HOUSING NOTE/i; # Turning Point
	$F[3] =~ s/^s*309\s*W(est)? Trinity.*$/G:TRANSITIONAL HOUSING NOTE/i; # Hallmark Inns of America
	$F[3] =~ s/^s*315\s*Polk.*$/G:TRANSITIONAL HOUSING NOTE/i; # Restoration House
	$F[3] =~ s/^s*319\s*S(o(uth)?)? 4th St.*$/G:TRANSITIONAL HOUSING NOTE/i; # Samaritan Recovery Community
	$F[3] =~ s/^s*339\s*E(ast)? Thompson Lane.*$/G:TRANSITIONAL HOUSING NOTE/i; # Christian Home Ministries
	$F[3] =~ s/^s*342\s*Valeria.*$/G:TRANSITIONAL HOUSING NOTE/i; # Harpeth Recovery
	$F[3] =~ s/^s*342\s*Valeria.*$/G:TRANSITIONAL HOUSING NOTE/i; # Turning Point Recovery
	$F[3] =~ s/^s*347\s*Flora Maxwell.*$/G:TRANSITIONAL HOUSING NOTE/i; # Rehabilitation Facility
	$F[3] =~ s/^s*366\s*Glenrose.*$/G:TRANSITIONAL HOUSING NOTE/i; # Restoration House
	$F[3] =~ s/^s*406\s*Glengary.*$/G:TRANSITIONAL HOUSING NOTE/i; # Christian Home Ministries
	$F[3] =~ s/^s*414\s*Williams.*$/G:TRANSITIONAL HOUSING NOTE/i; # R & R Transitional Housing
	$F[3] =~ s/^s*420\s*Murfreesboro.*$/G:TRANSITIONAL HOUSING NOTE/i; # Drake Motel
	$F[3] =~ s/^s*500\s*(Dr.? )?D.? ?B.? ?Todd.*$/G:TRANSITIONAL HOUSING NOTE/i; # Evolutions Recovery House
	$F[3] =~ s/^s*501\s*Moore.*$/G:TRANSITIONAL HOUSING NOTE/i; # Shipley House for Men
	$F[3] =~ s/^s*511\s*S(o(uth)?)? 8th St.*$/G:TRANSITIONAL HOUSING NOTE/i; # Community Care Fellowship
	$F[3] =~ s/^s*512\s*Hamilton.*$/G:TRANSITIONAL HOUSING NOTE/i; # Angels Entry
	$F[3] =~ s/^s*525\s*40th Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Light House Mission Ministries/Safe Harbor
	$F[3] =~ s/^s*532\s*8th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Campus for Human Development
	$F[3] =~ s/^s*561\s*Owendale.*$/G:TRANSITIONAL HOUSING NOTE/i; # Grandpa’s House
	$F[3] =~ s/^s*601\s*Lischey.*$/G:TRANSITIONAL HOUSING NOTE/i; # Group Home
	$F[3] =~ s/^s*602\s*Rudolph.*$/G:TRANSITIONAL HOUSING NOTE/i; # Recovery Community
	$F[3] =~ s/^s*603\s*Ben Allen.*$/G:TRANSITIONAL HOUSING NOTE/i; # Peace Unlimited and Recovery
	$F[3] =~ s/^s*625\s*Benton.*$/G:TRANSITIONAL HOUSING NOTE/i; # Matthew:25 Program
	$F[3] =~ s/^s*629\s*3rd Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Anchor Fellowship Church
	$F[3] =~ s/^s*631\s*Dickerson.*$/G:TRANSITIONAL HOUSING NOTE/i; # Salvation Army
	$F[3] =~ s/^s*639\s*Lafayette.*$/G:TRANSITIONAL HOUSING NOTE/i; # Nashville Rescue Mission
	$F[3] =~ s/^s*654\s*W(est)? Iris.*$/G:TRANSITIONAL HOUSING NOTE/i; # Harbor House Residential Facility
	$F[3] =~ s/^s*701[- ]?A Chickasaw.*$/G:TRANSITIONAL HOUSING NOTE/i; # Galaxy Star Services
	$F[3] =~ s/^s*702\s*51st Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Reconciliation Ministry
	$F[3] =~ s/^s*705\s*Drexel.*$/G:TRANSITIONAL HOUSING NOTE/i; # Campus for Human Development
	$F[3] =~ s/^s*801\s*12th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Park Center Safe HAvns
	$F[3] =~ s/^s*807\s*Main.*$/G:TRANSITIONAL HOUSING NOTE/i; # East Nashville Cooperative; Cooperative Ministries
	$F[3] =~ s/^s*807\s*Winthorne.*$/G:TRANSITIONAL HOUSING NOTE/i; # Operation Stand Down, Inc.
	$F[3] =~ s/^s*808\s*Lea.*$/G:TRANSITIONAL HOUSING NOTE/i; # Diersen Charities, Inc (Dismas, Inc)
	$F[3] =~ s/^s*816\s*S(o(uth)?)? 6th St.*$/G:TRANSITIONAL HOUSING NOTE/i; # Set Free Church
	$F[3] =~ s/^s*817\s*Shelby.*$/G:TRANSITIONAL HOUSING NOTE/i; # The Mary Parrish Center
	$F[3] =~ s/^s*818\s*Ramsey.*$/G:TRANSITIONAL HOUSING NOTE/i; # Rivera House Transition Home for Women
	$F[3] =~ s/^s*819\s*Shelby.*$/G:TRANSITIONAL HOUSING NOTE/i; # The Mary Parrish Center
	$F[3] =~ s/^s*821\s*Murfreesboro.*$/G:TRANSITIONAL HOUSING NOTE/i; # Days Inn Hotel
	$F[3] =~ s/^s*826\s*Meridan.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oxford House
	$F[3] =~ s/^s*840\s*Youngs.*$/G:TRANSITIONAL HOUSING NOTE/i; # Transitional Living Inc
	$F[3] =~ s/^s*893\s*Murfreesboro.*$/G:TRANSITIONAL HOUSING NOTE/i; # Rodeway Inn
	$F[3] =~ s/^s*901\s*Broadway.*$/G:TRANSITIONAL HOUSING NOTE/i; # General Delivery (NOT A VALID ADDRESS FOR CARD)
	$F[3] =~ s/^s*906\s*Gallatin.*$/G:TRANSITIONAL HOUSING NOTE/i; # Welcome Home House
	$F[3] =~ s/^s*913\s*Chicamauga.*$/G:TRANSITIONAL HOUSING NOTE/i; # Harmony House Development
	$F[3] =~ s/^s*919\s*N 12th St.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*923\s*Phillips.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts
	$F[3] =~ s/^s*925\s*McClurkin.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*929\s*43rd Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts
	$F[3] =~ s/^s*935\s*McClurkin.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*972[- ]*[AB] Strouse.*$/G:TRANSITIONAL HOUSING NOTE/i; # Transitions
	$F[3] =~ s/^s*981\s*Murfreesboro.*$/G:TRANSITIONAL HOUSING NOTE/i; # Quality Inn
	$F[3] =~ s/^s*1000\s*Albion.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts
	$F[3] =~ s/^s*1001\s*McKennie.*$/G:TRANSITIONAL HOUSING NOTE/i; # Grace House of Nashville
	$F[3] =~ s/^s*1001\s*Villa.*$/G:TRANSITIONAL HOUSING NOTE/i; # Villa House
	$F[3] =~ s/^s*1003\s*43rd Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts
	$F[3] =~ s/^s*1004\s*43rd Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts
	$F[3] =~ s/^s*1004\s*Cahal.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*1005\s*(Dr.? )?D.? ?B.? ?Todd.*$/G:TRANSITIONAL HOUSING NOTE/i; # Lloyd C Elam Mental Health Center
	$F[3] =~ s/^s*1012\s*Douglas.*$/G:TRANSITIONAL HOUSING NOTE/i; # Douglas Housing
	$F[3] =~ s/^s*1034\s*Granada.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*1036\s*Granada.*$/G:TRANSITIONAL HOUSING NOTE/i; # Welcome Home House
	$F[3] =~ s/^s*1039\s*Sharpe.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oxford House
	$F[3] =~ s/^s*1101\s*Edgehill.*$/G:TRANSITIONAL HOUSING NOTE/i; # Operation Stand Down
	$F[3] =~ s/^s*1102\s*Caruthers.*$/G:TRANSITIONAL HOUSING NOTE/i; # Supportive Housing Systems, LL
	$F[3] =~ s/^s*1103\s*Holly.*$/G:TRANSITIONAL HOUSING NOTE/i; # Cornerstone Home
	$F[3] =~ s/^s*1104\s*Ordway.*$/G:TRANSITIONAL HOUSING NOTE/i; # Park Center, Inc.
	$F[3] =~ s/^s*1115\s*McGavock.*$/G:TRANSITIONAL HOUSING NOTE/i; # Our House Transitional Housing for Men
	$F[3] =~ s/^s*1117\s*McGavock.*$/G:TRANSITIONAL HOUSING NOTE/i; # Re-Entry Recovery Residences of TN
	$F[3] =~ s/^s*1120\s*McGavock.*$/G:TRANSITIONAL HOUSING NOTE/i; # Our House Transitional Housing for Men
	$F[3] =~ s/^s*1121\s*Cahal.*$/G:TRANSITIONAL HOUSING NOTE/i; # Transitions Housing
	$F[3] =~ s/^s*1124\s*4th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Aphesis House, Inc
	$F[3] =~ s/^s*1125\s*12th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Operation Stand Down
	$F[3] =~ s/^s*1126\s*Harold.*$/G:TRANSITIONAL HOUSING NOTE/i; # Project Return
	$F[3] =~ s/^s*1209\s*N(o(rth)?)? 5th St.*$/G:TRANSITIONAL HOUSING NOTE/i; # Guardian Angels Outreach Ministries
	$F[3] =~ s/^s*1210\s*Murfreesboro.*$/G:TRANSITIONAL HOUSING NOTE/i; # Crossland Economy Studios
	$F[3] =~ s/^s*1212\s*Graycroft.*$/G:TRANSITIONAL HOUSING NOTE/i; # Aphesis House
	$F[3] =~ s/^s*1220\s*8th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Hermitage Hall
	$F[3] =~ s/^s*1221\s*16th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oasis Center
	$F[3] =~ s/^s*1234\s*3rd Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Safe HAvn
	$F[3] =~ s/^s*1261\s*1st Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Evolutions Recovery House
	$F[3] =~ s/^s*1300\s*Riverside.*$/G:TRANSITIONAL HOUSING NOTE/i; # Turning Point Recovery
	$F[3] =~ s/^s*1304\s*9th.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*1317\s*Love Joy.*$/G:TRANSITIONAL HOUSING NOTE/i; # New Life Transitional House
	$F[3] =~ s/^s*1328\s*Cheyenne.*$/G:TRANSITIONAL HOUSING NOTE/i; # Spiritual Hope N Faith
	$F[3] =~ s/^s*1402\s*Ashwood.*$/G:TRANSITIONAL HOUSING NOTE/i; # Operation Stand Down
	$F[3] =~ s/^s*1406\s*County Hospital.*$/G:TRANSITIONAL HOUSING NOTE/i; # DC 4
	$F[3] =~ s/^s*1415\s*17th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oasis Center
	$F[3] =~ s/^s*1513\s*16th Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Dismas House
	$F[3] =~ s/^s*1601\s*1.2 Porter.*$/G:TRANSITIONAL HOUSING NOTE/i; # Excellent Way Recovery House
	$F[3] =~ s/^s*1605\s*(Dr.? )?D.? ?B.? ?Todd.*$/G:TRANSITIONAL HOUSING NOTE/i; # Hannah’s House of Sober Living
	$F[3] =~ s/^s*1608\s*Woodmont.*$/G:TRANSITIONAL HOUSING NOTE/i; # YWCA
	$F[3] =~ s/^s*1618\s*22nd Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # The Atonement House
	$F[3] =~ s/^s*1620\s*(Dr.? )?D.? ?B.? ?Todd.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oxford  House Affiliates
	$F[3] =~ s/^s*1704\s*Charlotte.+200.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oasis
	$F[3] =~ s/^s*1716\s*Rosa (L.? )?Parks.*$/G:TRANSITIONAL HOUSING NOTE/i; # Hope Center
	$F[3] =~ s/^s*1805\s*Hailey.*$/G:TRANSITIONAL HOUSING NOTE/i; # Opportunity House
	$F[3] =~ s/^s*1810\s*County Hospital.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oxford House Affiliates
	$F[3] =~ s/^s*1812\s*County Hospital.*$/G:TRANSITIONAL HOUSING NOTE/i; # New Beginnings Transitional
	$F[3] =~ s/^s*1812\s*Morena.*$/G:TRANSITIONAL HOUSING NOTE/i; # Recovery Consultants of Nashville Inc.
	$F[3] =~ s/^s*1815\s*Underwood.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oxford House Affiliates
	$F[3] =~ s/^s*1826\s*Scovel.*$/G:TRANSITIONAL HOUSING NOTE/i; # New Start Outreach Ministry
	$F[3] =~ s/^s*1903\s*9th Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Ankh House
	$F[3] =~ s/^s*1907\s*Hailey.*$/G:TRANSITIONAL HOUSING NOTE/i; # Opportunity House
	$F[3] =~ s/^s*1908\s*21st Ave? S.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oxford House Affiliates
	$F[3] =~ s/^s*1910\s*County Hospital.*$/G:TRANSITIONAL HOUSING NOTE/i; # Choices
	$F[3] =~ s/^s*1911\s*Hailey.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mary & Martha Restoration Clinic
	$F[3] =~ s/^s*1925\s*Seminole.*$/G:TRANSITIONAL HOUSING NOTE/i; # Restoration House
	$F[3] =~ s/^s*2014\s*Hutton.*$/G:TRANSITIONAL HOUSING NOTE/i; # Restoration House
	$F[3] =~ s/^s*2072\s*Whitney.*$/G:TRANSITIONAL HOUSING NOTE/i; # Restoration House
	$F[3] =~ s/^s*2224\s*Scott.*$/G:TRANSITIONAL HOUSING NOTE/i; # Rock of Ages Recovery Ct
	$F[3] =~ s/^s*2317\s*23rd Ave? N.*$/G:TRANSITIONAL HOUSING NOTE/i; # Quest Care Group Home
	$F[3] =~ s/^s*2405\s*Brasher.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*2418\s*Brasher.*$/G:TRANSITIONAL HOUSING NOTE/i; # Middle Tennessee Residential
	$F[3] =~ s/^s*2429\s*Brasher.*$/G:TRANSITIONAL HOUSING NOTE/i; # Boarding House
	$F[3] =~ s/^s*2910\s*Berry Hill.*$/G:TRANSITIONAL HOUSING NOTE/i; # Oasis Center
	$F[3] =~ s/^s*2914\s*Dickerson.*$/G:TRANSITIONAL HOUSING NOTE/i; # Congress Inn
	$F[3] =~ s/^s*2914\s*Dickerson .*$/G:TRANSITIONAL HOUSING NOTE/i; # Congress Inn
	$F[3] =~ s/^s*3003\s*Albion.*$/G:TRANSITIONAL HOUSING NOTE/i; # Greater Christ Temple Church
	$F[3] =~ s/^s*3012\s*Sunny View.*$/G:TRANSITIONAL HOUSING NOTE/i; # Orion House
	$F[3] =~ s/^s*3410\s*Clarksville.*$/G:TRANSITIONAL HOUSING NOTE/i; # Renewal House
	$F[3] =~ s/^s*3900\s*Katherine.*$/G:TRANSITIONAL HOUSING NOTE/i; # Katherine House
	$F[3] =~ s/^s*3904\s*Meadow.*$/G:TRANSITIONAL HOUSING NOTE/i; # Opportunity House
	$F[3] =~ s/^s*4048\s*Matilda.*$/G:TRANSITIONAL HOUSING NOTE/i; # Eagles Nest Refuge Center
	$F[3] =~ s/^s*4302\s*Albion.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts Inc.
	$F[3] =~ s/^s*4305\s*Albion.*$/G:TRANSITIONAL HOUSING NOTE/i; # Mending Hearts Inc.
	$F[3] =~ s/^s*4316\s*Summer Crest.*$/G:TRANSITIONAL HOUSING NOTE/i; # Healthy Living Development Group, Inc.
	$F[3] =~ s/^s*4555\s*Trousdale.*$/G:TRANSITIONAL HOUSING NOTE/i; # AGAPE Christian Counseling
	$F[3] =~ s/^s*4908\s*Kentucky.*$/G:TRANSITIONAL HOUSING NOTE/i; # House of Mercy
	$F[3] =~ s/^s*5333\s*Ash Lawn.*$/G:TRANSITIONAL HOUSING NOTE/i; # TLC Housing
	$F[3] =~ s/^s*6547\s*Thunderbird.*$/G:TRANSITIONAL HOUSING NOTE/i; # UNKNOWN
	$F[3] =~ s/^s*P[. ]*O[. ]*Box 23336-37202.*$/G:TRANSITIONAL HOUSING NOTE/i; # The Next Door
	$F[3] =~ s/^s*P[. ]*O[. ]*Box 68518.*$/G:TRANSITIONAL HOUSING NOTE/i; # Recovery Community
	$F[3] =~ s/^s*P[. ]*O[. ]*Box 281754.*$/G:TRANSITIONAL HOUSING NOTE/i; # Eagles Nest Refuge Center

# PHONE NUMBER STUFF
	$F[3] =~ s/^(business phone: )?(\d{3}-)*\d{3}-\d{4} ?(EXT|X) ?\d+.*$/G:PHONE NUMBER WITH EXTENSION/i;
	$F[3] =~ s/^\d{3}-\d{3}-\d{4}.*$/G:PHONE NUMBER TO DELETE FROM NOTE/i;
	$F[3] =~ s/^(EXT|WORK\:? (PHONE|EXT)?).*$/G:WORK PHONE OR EXTENSION IN NOTE/i;

# REMOVE DATES
	$F[3] =~ s/^\d{1,2}[-\/.]\d{1,2}[-\/.]\d{2,4}[-: ]*(.+?)$/$1/; # DATE AT START OF NOTE
	$F[3] =~ s/^... ... \d{2} \d{4}: (.+?)$/$1/; # DATE AT START OF NOTE, III STANDARD
	$F[3] =~ s/\W+\d{1,2}[-\/.]\d{1,2}[-\/.]\d{2,4}.+?$//; # DATE AT END OF NOTE

# ONLINE PATRON SELF-REGISTRATION
	$F[3] =~ s/^\d{7}$/G:ONLINE BARCODE CONVERTED TO NOTE/;
	$F[3] =~ s/^(1\. ELECTRONIC|2\. IF PATRON|3\. IF DUPLICATE|4\. REQUEST|5\. IF PATRON|6\. |7\.|8\. CHANGE|9\. ADD|10\. DO NOT|10\. DELETE|11\. DELETE).*$/G:ONLINE REGISTRATION NOTES/;

# OFF-SITE REGISTRATION
	$F[3] =~ s/^(APPLICATION OBTAINED THROUGH GROW|BBTL|BOOTH|BRINGING BOOKS TO LIFE|EVENT REGISTRATION|MAYOR.S FIRST DAY OUT|OUTREACH\:|REGISTRATION AT).+?$/G:REGISTRATION OFF-SITE/; 

# MNPS REGISTRATION
	$F[3] =~ s/^(EDUCATOR CARD APP).+?$/G:EDUCATOR CARD APPLICATION/; 
	$F[3] =~ s/^(MNPS EDUCATOR \d{6}).+?$/G:MNPS EDUCATOR/; 
	$F[3] =~ s/^(MNPS STUDENT( \d{9})*\; SCHOOL).+?$/G:MNPS STUDENT/; 

# PATRON LIBRARY CARD NOTES
	$F[3] =~ s/^.*2?5?192\d{9}.*$/G:REPLACEMENT CARD/i; # (DAMAGE|LC|LST|LOST|REPLACE|STOLEN|WORN)
	$F[3] =~ s/^card reported (lost|stolen).*$/G:REPLACEMENT CARD/i;
	$F[3] =~ s/^card (@|at|found|held|is at|in|left) .*$/G:CARD FOUND/i;
	$F[3] =~ s/^(online (- )?)?ca?rd mail.*$/G:CARD MAILED/i;

# PATRON CONTACT INFORMATION VERIFICATION
	$F[3] =~ s/^.*((ADDRESS|ID) VERIFIED|(CONTACT|PATRON|PERSONAL)?.*INFO.*(CONFIRM|UPDATE|VERIF)).*/G:STAFF CONFIRMATION/i;
	$F[3] =~ s/^(PLEASE )(CHECK|VERIFY).*$/G:REQUEST FOR STAFF VERIFICATION/i;
	$F[3] =~ s/^(DELIVERY FAILED|E-?MAIL (NOTICE )*(RET.D|RETURNED|RTD)|FAILED DELIVERY).*$/G:EMAIL RETURNED/i;
	$F[3] =~ s/^MAIL RET.D FROM.*$/G:MAIL RETURNED/i;

# PATRON INFORMATION EXPLANATIONS
	$F[3] =~ s/^.*MIDDLE (NAME|INITIAL ONLY).*$/G:MIDDLE NAME/i;
	$F[3] =~ s/^.*MAIDEN NAME.*$/G:MAIDEN NAME/i;
	$F[3] =~ s/^Merged with \.p.*$/G:MERGED PATRON NOTE/i;

# NON RESIDENT FEE
	$F[3] =~ s/^.*((N-?R|NON[- ]?RES(IDENT)*) FEE.*P(AID|D)|P(AID|D) (\$?50(\.00)? )?((NON[- ]?RES(IDENT)*|N-?R) FEE)|NRF).*$/G:NON RESIDENT FEE PAID/i;

# WAIVE
	$F[3] =~ s/^.*(FOOD FOR FINES|TEEN READ|WAIVE|WAVIE).*$/G:WAIVE/i;

# BAD PATRON BEHAVIOR
	$F[3] =~ s/^(SEE PATRON FILE).+?$/G:SEE PATRON FILE/i; 
	$F[3] =~ s/^Claim(ed|s) returned.*$/G:CLAIMS RETURNED/i;
	$F[3] =~ s/^court(esy|sey) ((check|chk|ck).?out|c\/o|renew).*$/G:COURTESY CHECKOUT/i;

# CUT REMAINING NOTES TO 40 CHARACTERS
	$F[3] =~ s/^(.{40}).*?$/$1/; 
	print $F[3]' ../data/PATRON_NOTE.txt > ../data/group_patron_notes.txt

sort ../data/group_patron_notes.txt | uniq -c | sort -nr > ../data/group_patron_notes_count.txt
