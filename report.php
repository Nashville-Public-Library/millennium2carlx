<?php
require 'File/MARC.php';

$authority = new File_MARC('../data/AUTHORITY.mrc');
$a=0;
while ($record = $authority->next()) {
    $a++;
}

print "AUTHORITY record count: $a\n";

$bibliographic = new File_MARC('../data/BIBLIOGRAPHIC.mrc');
$b=0;
while ($record = $bibliographic->next()) {
    $b++;
}

print "BIBLIOGRAPHIC record count: $b";

?> 
