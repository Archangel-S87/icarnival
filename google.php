<?php

require_once('api/Fivecms.php');
$fivecms = new Fivecms();

header("Content-type: text/xml; charset=UTF-8");

// Заголовок
print
"<?xml version='1.0'?>
<rss xmlns:g='http://base.google.com/ns/1.0' version='2.0'>

<channel>
<title>".$fivecms->settings->site_name."</title>
<link>".$fivecms->config->root_url."</link>
<description>".$fivecms->settings->company_name."</description>
";

// Валюты
$currencies = $fivecms->money->get_currencies(array('enabled'=>1));
$all_currencies = $fivecms->money->get_currencies();
$main_currency = reset($currencies);
$currency_code = $main_currency->code;

// Категории (1)
/*$categories = array();
foreach($simpla->categories->get_categories() as $c){
  $categories[$c->id][] = $c->name;
  $parent_categories[$c->id][] = $c->parent_id;
}*/

// Товары
$fivecms->db->query("SET SQL_BIG_SELECTS=1");
// Товары
$fivecms->db->query("SELECT v.price, v.id as variant_id, p.name as product_name, v.name as variant_name, v.position as variant_position, v.sku AS variant_sku, v.currency_id, p.id as product_id, p.url, p.annotation, pc.category_id, i.filename as image
					FROM __variants v LEFT JOIN __products p ON v.product_id=p.id
					
					LEFT JOIN __products_categories pc ON p.id = pc.product_id AND pc.position=(SELECT MIN(position) FROM __products_categories WHERE product_id=p.id LIMIT 1)	
					LEFT JOIN __images i ON p.id = i.product_id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)	
					WHERE p.visible AND (v.stock >0 OR v.stock is NULL) AND p.to_yandex GROUP BY v.id ORDER BY p.id, v.position ");

// В цикле мы используем не results(), a result(), то есть выбираем из базы товары по одному,
// так они нам одновременно не нужны - мы всё равно сразу же отправляем товар на вывод.
// Таким образом используется памяти только под один товар
$prev_product_id = null;
while($p = $fivecms->db->result())
{
	$variant_url = '';
	if ($prev_product_id === $p->product_id)
		$variant_url = '?variant='.$p->variant_id;
	$prev_product_id = $p->product_id;

	//$price = round($fivecms->money->convert($p->price, $main_currency->id, false),2);

	if($p->currency_id > 0) {
		$price = round($p->price * $all_currencies[$p->currency_id]->rate_to / $all_currencies[$p->currency_id]->rate_from,2);
	} else {
		$price = round($fivecms->money->convert($p->price, $main_currency->id, false),2);
	}

	print
	"
	<item>
		<g:id>".$p->variant_id."</g:id>
		<g:title>".htmlspecialchars($p->product_name).($p->variant_name?' '.htmlspecialchars($p->variant_name):'')."</g:title>
		<g:description>".htmlspecialchars(strip_tags($p->annotation))."</g:description>
		<g:link>".$fivecms->config->root_url.'/products/'.$p->url.$variant_url."</g:link>";
		print "
		<g:price>$price $currency_code</g:price>
		<g:condition>new</g:condition>
		<g:availability>in stock</g:availability>
		";
		if($p->image)
		print "<g:image_link>".$fivecms->design->resize_modifier($p->image, 800, 600, w)."</g:image_link>
		";
		if($p->brand)
			print "<g:brand>".$p->brand."</g:brand>";
	
		// Категории (2)
		/*if(isset($categories[$p->category_id])){
			$c = $categories[$p->category_id];
		}	

		if(isset($parent_categories[$p->category_id])){
			$parent_id = $parent_categories[$p->category_id];
			$p_id = $parent_id[0];
			$parentc = $categories[$p_id];
		}	

		if(!empty($parentc[0]))
			$path = $parentc[0].' &gt; '.$c[0];
		else
			$path = $c[0];

		if(!empty($path))
			print "<g:product_type>$path</g:product_type>";*/
		// Категории @ (2)

		if(!empty($p->variant_sku))	
			print "<g:mpn>$p->variant_sku</g:mpn>";
		else
			print "<g:mpn>$p->variant_id</g:mpn>";

		print "<g:adult>no</g:adult>";	

	print "</item>";
}
print "</channel>
";

print "</rss>
";