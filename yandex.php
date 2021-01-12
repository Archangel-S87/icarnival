<?php

require_once('api/Fivecms.php');
$fivecms = new Fivecms();

header("Content-type: text/xml; charset=UTF-8");
print (pack('CCC', 0xef, 0xbb, 0xbf));
// Заголовок
print
"<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE yml_catalog SYSTEM 'shops.dtd'>
<yml_catalog date='".date('Y-m-d H:i')."'>
<shop>
<name>".$fivecms->settings->site_name."</name>
<company>".$fivecms->settings->company_name."</company>
<url>".$fivecms->config->root_url."</url>
";

// Валюты
$currencies = $fivecms->money->get_currencies(array('enabled'=>1));
$all_currencies = $fivecms->money->get_currencies();
$main_currency = reset($currencies);
print "<currencies>
";
foreach($currencies as $c) {
	if($c->enabled){
		print "<currency id='".$c->code."' rate='".$c->rate_to/$c->rate_from*$main_currency->rate_from/$main_currency->rate_to."'/>";
	}
}
print "</currencies>";

// Категории
$categories = $fivecms->categories->get_categories();
print "<categories>";
foreach($categories as $c){
	print "<category id='$c->id'";
	if($c->parent_id>0) {
		print " parentId='$c->parent_id'";
	}
	print ">".htmlspecialchars($c->name)."</category>";
}
print "</categories>";

$stock_filter = $fivecms->settings->export_not_in_stock ? '' : ' AND (v.stock >0 OR v.stock is NULL) ';

// Товары
$fivecms->db2->query("SET SQL_BIG_SELECTS=1");

$images = array();
foreach($fivecms->products->get_images() as $i){
  //$images[$i->product_id][] = $i->filename;
  $images[$i->product_id][$i->filename] = $i->color;
}
// Товары
$fivecms->db2->query("SELECT v.price, v.id AS variant_id, p.name AS product_name, v.name AS variant_name, v.name1 AS size, v.name2 AS color, v.position AS variant_position, v.sku AS variant_sku, v.stock, (v.stock IS NULL) as infinity, v.compare_price, v.unit, v.currency_id, p.id AS product_id, p.url, p.annotation, p.body, pc.category_id, b.name AS brand
					FROM __variants v LEFT JOIN __products p ON v.product_id=p.id
					LEFT JOIN __brands b ON b.id = p.brand_id
					LEFT JOIN __products_categories pc ON p.id = pc.product_id
					WHERE p.visible AND p.to_yandex $stock_filter GROUP BY v.id ORDER BY p.id, v.position ");
print "<offers>
";

$currency_code = $main_currency->code;

$prev_product_id = null;
$products = $fivecms->db2->results();

foreach ($products as $p)
{
	$variant_url = '';
	if($prev_product_id === $p->product_id)
		$variant_url = '?variant='.$p->variant_id;
	$prev_product_id = $p->product_id;
	
	// Multicurrency
	if($p->currency_id > 0) {
		$price = round($p->price * $all_currencies[$p->currency_id]->rate_to / $all_currencies[$p->currency_id]->rate_from,2);
	} else {
		$price = round($fivecms->money->convert($p->price, $main_currency->id, false),2);
	}
	
	if ($fivecms->settings->vendor_model == 1) {
		$type = " type='vendor.model'";
	} else {
		$type = "";
	}
	
	if($p->variant_name && !empty($p->category_id)) {
		print "<offer id='$p->variant_id'".$type." group_id='$p->product_id' available='".(((($p->infinity == 0) && ($p->stock == 0)) ) ? 'false' : 'true')."'>";
	} elseif(!empty($p->category_id)) {
		print "<offer id='$p->variant_id'".$type." available='".(((($p->infinity == 0) && ($p->stock == 0)) ) ? 'false' : 'true')."'>";
	}
	
	print "<url>".$fivecms->config->root_url.'/products/'.$p->url.$variant_url."</url>";
	print "<price>$price</price>";
	
	if($p->compare_price > 0)
		$proc_price = 100-(100*$p->price/$p->compare_price);

	if(($p->compare_price > 0) && ($p->compare_price > $p->price) && ($proc_price > 5) && ($proc_price < 95)) {
			print "<oldprice>";
			if($p->currency_id > 0) {
				print round($p->compare_price * $all_currencies[$p->currency_id]->rate_to / $all_currencies[$p->currency_id]->rate_from,2);
			} else {
				print round($fivecms->money->convert($p->compare_price, $main_currency->id, false),2);
			}
			print "</oldprice>";
	}
	
	print "<currencyId>".$currency_code."</currencyId>";
	
	print "<categoryId>".$p->category_id."</categoryId>";
	
	if(isset($images[$p->product_id])) {
		$cnt=0;
		if(!empty($p->color)){
			foreach($images[$p->product_id] as $v=>$col) {
				if($cnt<10 && ($p->color == $col || empty($col))){
					print "<picture>".$fivecms->design->resize_modifier($v, 800, 600, w)."</picture>";$cnt++;
				} 
			}
		}
		else {
			foreach($images[$p->product_id] as $v=>$col) {
				if($cnt<10){
					print "<picture>".$fivecms->design->resize_modifier($v, 800, 600, w)."</picture>";$cnt++;
				}
			}
		}	
	}
	
	if ($fivecms->settings->vendor_model == 0) {
		print "<name>".htmlspecialchars($p->product_name).($p->variant_name?' ('.htmlspecialchars($p->variant_name).')':'')."</name>";
	} else {
		print "<typePrefix>".htmlspecialchars($categories[$p->category_id]->name, ENT_QUOTES)."</typePrefix>";
		print "<model>".htmlspecialchars($p->product_name).($p->variant_name?' ('.htmlspecialchars($p->variant_name).')':'')."</model>";
	}
	
	$descr = "<description><![CDATA[".$p->body."]]></description>";
	//$annot = "<description>".htmlspecialchars(strip_tags($p->annotation))."</description>";
	$annot = "<description><![CDATA[".$p->annotation."]]></description>";
	
	if(empty($annot) && !empty($descr))
		$annot = $descr;
		
	if(empty($descr) && !empty($annot))
		$descr = $annot;
	
	print $fivecms->settings->short_description ? $descr : $annot;
    
    print ($fivecms->settings->sales_notes ? "<sales_notes>".htmlspecialchars(strip_tags($fivecms->settings->sales_notes))."</sales_notes>" : "")."";
	
    print "<store>".($fivecms->settings->for_retail_store ? 'true' : 'false')."</store>
    <pickup>".($fivecms->settings->for_reservation ? 'true' : 'false')."</pickup>
    <delivery>".($fivecms->settings->ym_delivery ? 'true' : 'false')."</delivery>";

	if(!empty($p->brand)) 
		print "<vendor>".htmlspecialchars($p->brand)."</vendor>";

	if(!empty($p->variant_sku))
		print "<vendorCode>".htmlspecialchars($p->variant_sku)."</vendorCode>"; 

	if (!empty($p->variant_name))
		print "<param name='Вариант'>".htmlspecialchars($p->variant_name)."</param>"; 
	
	if(!empty($p->size)) 
		print "<param name='Размер' unit='RU'>".htmlspecialchars($p->size)."</param>";
	if(!empty($p->color)) 
		print "<param name='Цвет'>".htmlspecialchars($p->color)."</param>";
		
	$features[$p->product_id] = $fivecms->features->get_product_options(array('product_id'=>$p->product_id));
	if (!empty($features[$p->product_id])) {
		foreach($features[$p->product_id] as $feature) {
			print "<param name='".htmlspecialchars($feature->name)."'>".htmlspecialchars($feature->value)."</param>";
		}
	}
	
	print "
    <manufacturer_warranty>".($fivecms->settings->manufacturer_warranty ? 'true' : 'false')."</manufacturer_warranty>
    <seller_warranty>".($fivecms->settings->seller_warranty ? 'true' : 'false')."</seller_warranty>
    ";
	 
	print "</offer>";
}

print "</offers>";
print "</shop>
</yml_catalog>
";
