#!/usr/bin/php -ddisplay_errors=E_ALL

<?php

/**
 * Nashville fines and fees Millennium extract via Fines Payment API
 *
 * @author James Staub <james.staub@nashville.gov>
 * 
 * 20160119
 */

/* Millennium Fines Payment API */

$thread = $argv[1];

// Transform 7 digit record number to Millennium record number with check digit
// Check digit calculation as per IGR #105781
// http://csdirect.iii.com/manual_2009b/rmil_records_numbers.html
function rNum2rId ($r,$n) {
	$j = str_split($n);
	foreach ($j as $k=>&$v) {
		$v = $v*(8-$k);
	}
	unset($k);
	$z = array_sum($j) % 11;
	if ($z == 10) { $z = "x"; }
	return ".$r$n$z";
}

$patronIds = file("../data/fines-patronIds.$thread", FILE_IGNORE_NEW_LINES);

$output = fopen("../data/fines-output.$thread","w");
$errlog = fopen("../data/fines-errors.$thread","w");
$count = 0;
$buffer = "";
$errors = "";

$uri              = "http://webapps.iii.com/wsclient/patronio";
$hostname         = "https://waldo.library.nashville.org";
$port             = "443";
$path             = "/iii/patronio/services/PatronIO";
$username         = "milwsp";
$password         = "milwsp";
//$librarycard      = "b999003";

$columns = array (
	"item",
	"itembarcode",
	"transcode",
	"patronid",
	"patronbarcode",
	"renew",
	"pickup",
	"transdate",
	"dueornotneededafterdate",
	"returndate",
	"lastactiondate",
	"borrowertype",
	"branch",
	"holdingbranch",
	"site",
	"media",
	"location",
	"dataflag1",
	"dataflag3",
	"dataflag4",
	"amountdebited",
	"amountpaid",
	"notes"
);

//$buffer .= implode("|",$columns)."\n";

foreach ($patronIds as $id) {

	$id = ".$id";

	if ($count==10) {
		fwrite($output, $buffer);
		$buffer="";	
		fwrite($errlog, $errors);
		$errors="";
		$count=0;
	}
	$patron = new stdClass();
	try {
		$client = new SoapClient(null, array('location' => "$hostname:$port$path", 'uri' => $uri));
		$result = $client->searchPatrons($username, $password, $id);
//var_dump($result);
	} catch (SoapFault $fault) {
		// III Patron Web Services errors documented at http://techdocs.iii.com/patronws_api_errorhandling.shtml
		if (!isset($result)) {
			$result = new stdClass();
		}
		$result->error = "$id : Online Payment is currently not available for this patron.";
//var_dump($fault->faultstring);
		$failcode[1] = "No error code found";
		preg_match('/code = (\d+),/',$fault->faultstring,$failCode);
		$result->error .= " Error #$failCode[1]. ";
		preg_match('/desc = (.+)$/',$fault->faultstring,$failCode);
		$result->error .= $failCode[1];
		//var_dump($result);
		$errors .= $result->error . "\n";
	}
	$patronField = (array) $result;
	//$patron->patronID = $patronField['patronID'];
	foreach($patronField['patronFields'] AS $field) {
		// Millennium patron record BARCODE
		if($field->fieldTag == "b") {
			$patron->barcode = $field->value;
		} else {
			$patron->barcode = "";
		}
		// Millennium patron record P TYPE
		if($field->fieldTag == 47) {
			$patron->pType = $field->value;
		}
	}
	foreach($patronField['patronFines'] AS $fine) {
		// RECORD ONLY Lost Book, Manual and NOT lost card, and Replacement fines
	   if ($fine->chargeType == "LostBook" || ($fine->chargeType == "Manual" && preg_match('/\bCARD\b/i',$fine->description)===0) || $fine->chargeType == "Replacement") {
		if ($fine->itemRecordNum > 0) {
			$fine->itemRecordNum = rNum2rId("i",$fine->itemRecordNum);
		} else {
			$fine->itemRecordNum = "";
		}
		// Millennium Fines Payment API assigns NOW() to transferDate if the patron is the original patron. The conditional below corrects for this.
		if ($fine->originalPatronID == 0) {
			$fine->originalPatronID = "";
			$fine->transferDate = "";
		}
		// Millennium Fines Payment API assigns NOW() to itemDateReturned if the item is not returned. The conditional below corrects for this.
		if (time() - strtotime($fine->itemDateReturned) < 60) {
			$dateReturned = "";
		} else {
			$dateReturned = date('c', strtotime($fine->itemDateReturned));
		}
		$fineTypeAmounts = array(
			"billingFee" => $fine->billingFee,
			"itemCharge" => $fine->itemCharge,
			"processingFee" => $fine->processingFee
		);
		foreach($fineTypeAmounts as $fineType => $fineAmount) {
			if ($fineAmount > 0) {
				// allocate partial payment across fine types in a single invoice
				$fineAmountPaid = 0;
				if ($fine->amountPaid > 0 && $fine->amountPaid >= $fineAmount) {
					$fineAmountPaid = $fineAmount;
					$fine->amountPaid -= $fineAmount;
				} elseif ($fine->amountPaid > 0 && $fine->amountPaid < $fineAmount) {
					$fineAmountPaid = $fine->amountPaid;
					$fine->amountPaid = 0;
				}
//echo "INVOICE: $fine->invoice|TYPE: $fineType|AMOUNT: $fineAmount|PAID: $fineAmountPaid|LEFT IN fine-amountPaid: $fine->amountPaid\n";
				$record = array(
					$fine->itemRecordNum,
					"",
					$fineType . ": " . $fine->chargeType,
					rNum2rId("p",$fine->patronID),
					$patron->barcode,
					"",
					"",
					date('c', strtotime($fine->dateAssessed)),
					date('c', strtotime($fine->itemDueDate)),
					$dateReturned,
					date('c', strtotime($fine->dateAssessed)),
					$patron->pType,
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					"",
					sprintf("%.2f", $fineAmount/100),
					sprintf("%.2f", $fineAmountPaid/100),
					"description: " . $fine->description . "^invoice: " . $fine->invoice . "^itemCheckoutDate: " . $fine->itemCheckoutDate . "^itemLoanRule: " . $fine->itemLoanRule . "^originalPatronID: " . $fine->originalPatronID . "^transferDate: " . $fine->transferDate
				);
				$buffer .= implode("|", $record)."\n";
			}
		}
	   }
	}
	$count++;	
//	echo ".";
}

fwrite($output, $buffer);
$buffer="";	
fwrite($errlog, $errors);
$errors="";
$count=0;

fclose($output);
fclose($errlog);

//echo date("c")." : Thread $thread complete.\n";
exit;
