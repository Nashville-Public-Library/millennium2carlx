<?php
// format_authority.php
// James Staub
// Nashville Public Library
// Update MARC records exported from Millennium
// to meet CARL.X import requirements

// 20170119 :
//	changed script name and location	 
//	changed paths to data files
// 20161021 : version 1
//	Make changes to authority record control numbers
//	so all control numbers are LC, not OCLC
//	Verified assumption: all records have 001 with either LC or OCLC value
//	Verified assumption: there are no records with multiple 010 tags
//	Correcting assumption: there are 10 records with OCLC value in 001 and no 010 tag
//	Correcting assumption: all records have one and only one 001 tag
//		there are 10 records with 0 001 tags - should be able to handle these in this script
//	TO DO: correct assumption that all 010 are in correct format
//	TO DO: check for duplicate 001 values in the output file

ini_set('memory_limit', '1024M');
require_once 'File/MARC.php';
date_default_timezone_set('America/Chicago');

$authorityFileInput = "../data/millennium_extract-06.mrc";
$authorityFileOutput = fopen('../data/AUTHORITY.mrc','wb');
$authorityRecords = new File_MARC($authorityFileInput);

while ($authorityRecord = $authorityRecords->next()) {
	foreach ($authorityRecord->getFields() as $field) {
//		if ($field->getTag() == '001' && $field instanceof File_MARC_Control_Field) {
		if ($field->getTag() == '001') {
			$controlNumber = trim($field->getData());
// skip problem record .a11491358
if ($controlNumber == 'oca09296868') { continue; }
//			print "001: $controlNumber\n";
			if (preg_match("/^oca/",$controlNumber,$matches)) {
				$oclcNumber = $controlNumber;
				$LCCN = trim($authorityRecord->getField('010')->getSubfield('a')->getData());
//				print "010: $LCCN\n";
				$field->setData("$LCCN");
				if (!$authorityRecord->getField('035') || preg_match("/$oclcNumber/",$authorityRecord->getField('035'),$matches) == 0) {
					$oclcValues[0] = new File_MARC_Subfield('a', "(OCoLC)$oclcNumber");
					$oclcInsert = new File_MARC_Data_Field('035', $oclcValues, 0, null);
					foreach ($authorityRecord->getFields() as $fieldInList) {
						if ($fieldInList->getTag() > 35) {
							$authorityRecord->insertField($oclcInsert,$fieldInList,true);
							break;
						}
					}
				}
			} else if (preg_match("/^(dg|gf|mp|n|nb|nr|ns|no|sh|sj|sp)/",$controlNumber,$matches)) {
				$lccnNumber = $controlNumber;
				if (!$authorityRecord->getField('010')) {
					$lccnValues[] = new File_MARC_Subfield('a', "$lccnNumber");
					$lccnInsert = new File_MARC_Data_Field('010', $lccnValues, 0, null);
					foreach ($authorityRecord->getFields() as $fieldInList) {
						if ($fieldInList->getTag() > 10) {
							$authorityRecord->insertField($lccnInsert,$fieldInList,true);
							break;
						}
					}
				}
			}
//			$controlNumber = $field->getData();
//			print "NEW 001: $controlNumber\n";
		}
//		print $authorityRecord;
		fwrite($authorityFileOutput, $authorityRecord->toRaw());
	}
}
fclose($authorityFileOutput);
?>
