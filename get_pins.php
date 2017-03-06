<?php

require "patronapi.php";

// TO DO: MAKE phase 2 threadish
//$thread = $argv[1];

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

//echo date("c")."\n";

/*****
// phase 1: check PINs stored in Pika. If error, move user to phase 2

$validUserPinsFile = fopen("../data/validUserPins.txt.$thread", "w");
$invalidUserPinsFile = fopen("../data/invalidUserPins.txt.$thread", "w");
$pikaUsers = file("../data/pikaUsers.txt.$thread", FILE_IGNORE_NEW_LINES);
foreach ($pikaUsers as $user) {
	$u = explode("\t",$user);
//	echo "$u[0]\t$u[1]\n";
	$r=check_validation(".p$u[0]",$u[1]);
// TO DO: catch PHP Warning:  file_get_contents(https://waldo.library.nashville.org:54620/PATRONAPI/.p1872341/0033/pintest): failed to open stream: HTTP request failed!  in /home/jstaub/millennium_extract/bin/patronapi.php on line 38
//PHP Notice:  Undefined offset: 1 in /home/jstaub/millennium_extract/bin/patronapi.php on line 28
//PHP Notice:  Undefined index: ERRNUM in /home/jstaub/millennium_extract/bin/get_pins.php on line 37
//PHP Notice:  Undefined index: ERRMSG in /home/jstaub/millennium_extract/bin/get_pins.php on line 37

//	var_dump($r);
	if (isset($r["RETCOD"]) && $r["RETCOD"]==0) {
		fwrite($validUserPinsFile, "$u[0]|$u[1]\n");
//echo ".";
	} else {
		fwrite($invalidUserPinsFile, "$u[0]\t$u[1]\t".$r["ERRNUM"]."\t".$r["ERRMSG"]."\n");
	}
}
fclose($validUserPinsFile);
fclose($invalidUserPinsFile);
// *****
*/

// phase 2: clobber patronapi for PINs not stored in Pika. Seed list = create list patron PIN != "". EXCEPT patron/pin pairs in phase 1

$users = file('../data/millennium_extract-patronsWithPins.txt', FILE_IGNORE_NEW_LINES);
$header = array_shift($users);

// TO DO: remove duplicates from pins.txt
$pins = file('../data/pins.txt', FILE_IGNORE_NEW_LINES);
array_unshift($pins,"BIRTH_DATE");

foreach ($users as $user) {
	$u = explode("\t",$user);
	isset($u[2]) ? $pins[0]=substr($u[2],0,2).substr($u[2],3,2) : $pins[0]=2016;
echo "$u[0]|$pins[0]\n";
	foreach ($pins as $p) {
		echo "$p ";
		$r=check_validation(".".substr($u[0],0,8),$p);
		if ($r["RETCOD"]==1&&$r["ERRNUM"]=4) { continue; }
//		var_dump($r);
		if (isset($r["RETCOD"]) && $r["RETCOD"]==0) {
			echo "\n\n$u[0]:$p\n";
			echo date("c")."\n";
			break;
		}
	}
}

// TO DO: update pins.txt sequence with new frequency findings

?>
