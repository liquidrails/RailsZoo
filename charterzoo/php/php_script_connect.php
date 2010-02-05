<?php # Script - php_script_connect.php

// This file contains the database access information
// This file also establishes a connection to MySQL and selects the database.

DEFINE ('DB_USER', 'root');
DEFINE ('DB_PASSWORD', 'cheri');
DEFINE ('DB_HOST', 'localhost');
DEFINE ('DB_NAME', 'charterzoo_development');

if ($dbc = mysql_connect (DB_HOST, DB_USER, DB_PASSWORD)) {

  if (!mysql_select_db (DB_NAME)) {

    trigger_error("Could not select the database!\nMySQL Error: " . mysql_error());
    exit();

    }

} // End of dbc if


//$query0 = "DELETE FROM postings2 WHERE `return` <= NOW()";

//$result0 = @mysql_query($query0);

//$query = "INSERT INTO postings2
//SELECT *
//FROM postings p1 
//WHERE p1.return <= NOW()";

//$result = @mysql_query($query);

$query2 = "DELETE FROM postings2 WHERE `return` <= NOW() LIMIT 1";

$result2 = @mysql_query($query2);


echo 'All done!
';

mysql_close();

?>
