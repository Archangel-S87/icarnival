<?php

require_once('api/Fivecms.php');
$fivecms = new Fivecms();



// Заголовок
print
"<!DOCTYPE HTML>

<html>
<head>
<base href='".$fivecms->config->root_url."'/>
<title>Прайс-лист</title>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
<meta http-equiv='Cache-Control' content='public'>
<style>
body {font-size: 13px; font-family: arial, verdana; margin-left: 50px;}
p {margin: 0; padding: 10px 0 0 0;}
td {border: 1px solid #dadada; padding: 5px;}
table {border-spacing: 0px; border: 1px solid #dadada;}
a {color: navy;}

</style>
</head>
<body>

<p>".$fivecms->settings->company_name."</p>
<p>".$fivecms->config->root_url."</p>
<p><strong>Прайс-лист ".date('d-m-Y')."</strong></p><p> </p><br />

";



$currencies = $fivecms->money->get_currencies(array('enabled'=>1));
$all_currencies = $fivecms->money->get_currencies();
$main_currency = reset($currencies);
$sign = $main_currency->sign;

$fivecms->db->query("SET SQL_BIG_SELECTS=1");

$fivecms->db->query("SELECT v.price, v.currency_id, v.id AS variant_id, p.name AS product_name, v.name AS variant_name, v.position AS variant_position, v.sku AS variant_sku, v.unit, p.id AS product_id, p.url
					FROM __variants v LEFT JOIN __products p ON v.product_id=p.id
					WHERE p.visible AND (v.stock >0 OR v.stock is NULL) GROUP BY v.id ORDER BY p.name, v.position ");

print "<table><tbody><tr><td><strong>Наименование</strong></td><td><strong>Артикул</strong></td><td><strong>Цена</strong></td><td><strong>Валюта</strong></td></tr>";

$prev_product_id = null;
while($p = $fivecms->db->result())
{

	$variant_url = '';
	if ($prev_product_id === $p->product_id)
		$variant_url = '?variant='.$p->variant_id;
	$prev_product_id = $p->product_id;

	//$price = round($fivecms->money->convert($p->price, $main_currency->id, false),2);
	// Multicurrency
	if($p->currency_id > 0) {
		$price = round($p->price * $all_currencies[$p->currency_id]->rate_to / $all_currencies[$p->currency_id]->rate_from,2);
	} else {
		$price = round($fivecms->money->convert($p->price, $main_currency->id, false),2);
	}

	print "

	<tr>

	<td>
	<a href='".$fivecms->config->root_url.'/products/'.$p->url."' target='_blank'>".htmlspecialchars($p->product_name).($p->variant_name?' '.htmlspecialchars($p->variant_name):'')."</a>
	</td>

	<td>$p->variant_sku</td>

	<td>$price</td>

	<td>$sign</td>

	</tr>

	";

}

print "</tbody></table></body></html>";

