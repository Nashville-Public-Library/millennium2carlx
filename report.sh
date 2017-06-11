echo "*** MARC ***"
php report.php

echo "*** HOLDS ***"
TLHR=`awk '{print $1}' ../data/TITLE_LEVEL_HOLDS.txt | wc -l`
echo "TITLE_LEVEL_HOLDS records: $TLHR"
THR=`awk '{print $1}' ../data/TRANSITEM_HOLDS.txt | wc -l`
echo "TRANSITEM_HOLDS records: $THR"

echo "*** ITEM ***"
#IM=`wc -l ../data/millennium_extract-03.txt | awk '{print $1}'`
#echo "Raw records: $IM"
IR=`wc -l ../data/ITEM.txt | awk '{print $1}'`
echo "ITEM records: $IR"
#IUI=`awk '{print $1}' ../data/ITEM.txt | sort | uniq | wc -l`
#echo "ITEM unique IDs: $IUI"
INR=`wc -l ../data/ITEM_NOTE.txt | awk '{print $1}'`
echo "ITEM_NOTE records: $INR"
IWR=`wc -l ../data/ITEM_WHOHADIT.txt | awk '{print $1}'`
echo "ITEM_WHOHADIT records: $IWR"

echo "*** PATRON ***"
PR=`wc -l ../data/PATRON.txt | awk '{print $1}'`
echo "PATRON records: $PR"
PNR=`wc -l ../data/PATRON_NOTE.txt | awk '{print $1}'`
echo "PATRON_NOTE records: $PNR"
PRHR=`wc -l ../data/LOOKUP_PATRON_READING_HISTORY_OPT_IN.txt | awk '{print $1}'`
echo "LOOKUP_PATRON_READING_HISTORY_OPT_IN records: $PRHR"
PRHR2=`awk -F'|' '$22 ~ /Y/ { print $22 }' ../data/PATRON.txt | wc -l`
echo "PATRON USERID = Y records: $PRHR2"

echo "*** PINS ***"
cd john-1.8.0/run/
PC=`./john --show ../../../data/millennium_extract-patronsWithPins.txt | wc -l`
cd ../../
PT=`wc -l < ../data/millennium_extract-patronsWithPins.txt`
PU=$(( $PT - $PC ))
echo "Patrons with PINs: $PT"
echo "PINs cracked: $PC"
echo "PINs uncracked: $PU"

echo "*** TRANSITEM_CHECKOUT ***"
TCM=`wc -l ../data/millennium_extract-04.txt | awk '{print $1}'`
echo "Raw records: $TCM"
TCMU=`sort ../data/millennium_extract-04.txt | uniq | wc -l`
echo "Unique raw records: $TCMU"
TCR=`wc -l ../data/TRANSITEM_CHECKOUT.txt | awk '{print $1}'`
echo "TRANSITEM_CHECKOUT records: $TCR"
TCRU=`sort ../data/TRANSITEM_CHECKOUT.txt | uniq | wc -l`
echo "Unique TRANSITEM_CHECKOUT records: $TCRU"
TCIU=`awk -F'|' '{print $1}' ../data/TRANSITEM_CHECKOUT.txt | sort | uniq | wc -l`
echo "Unique TRANSITEM_CHECKOUT items: $TCIU"

echo "*** TRANSITEM_FINES ***"
TFR=`wc -l < ../data/TRANSITEM_FINES.txt`
echo "TRANSITEM_FINES records: $TFR"
TFO=`perl -F'\|' -lane '$o+=$F[-3]; END { print "$o"; }' ../data/TRANSITEM_FINES.txt`
echo "TRANSITEM FINES total owed: $TFO"
TFP=`perl -F'\|' -lane '$p+=$F[-2]; END { print "$p"; }' ../data/TRANSITEM_FINES.txt`
echo "TRANSITEM FINES total paid: $TFP"
#TFT=$(( $TFO - $TFP ))
#echo "TRANSITEM FINES total: $TFT"

echo "*** INFINITECAMPUS ***"
IC1R=`wc -l < ../data/INFINITECAMPUS_STUDENT.txt`
echo "INFINITECAMPUS STUDENT records: $IC1R"
IC2R=`wc -l < ../data/INFINITECAMPUS_STAFF.txt`
echo "INFINITECAMPUS STAFF records: $IC2R"

