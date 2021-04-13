<?php

error_reporting(E_ALL);
ini_set("display_errors", 1);

ini_set('max_execution_time', 0);
set_time_limit (0);

session_start();
$_SESSION['id'] = session_id();

header('content-type: text/html; charset=UTF-8');

require_once 'ImportJson.php';

$Export = new ImportJson();

//echo $Export->import_categories(0);

//echo $Export->import_brands();

echo $Export->import_products(0);

//echo $Export->import_users();

//echo $Export->import_orders();
