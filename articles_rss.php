<?php
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

header("Content-type: text/xml; charset=UTF-8");
print '<?xml version="1.0" encoding="utf-8"?><rss version="2.0"><channel>';
print '<title>'.htmlspecialchars($fivecms->settings->site_name).'</title>';
print '<link>'.$fivecms->config->root_url.'</link>';
print '<lastBuildDate>'.date("D, d M Y H:i:s O").'</lastBuildDate>';
print '<description>'.htmlspecialchars($fivecms->settings->site_name).'</description>';

$filter['visible'] = 1;
$art = $fivecms->articles->get_articles($filter);
foreach($art as $r) {
	print '<item>';
	print '<title>'.htmlspecialchars($r->name).'</title>';
	print '<link>'.$fivecms->config->root_url.'/article/'.$r->url.'</link>';
	if ($r->annotation) {
		//print '<description>'.htmlspecialchars($r->annotation).'</description>';
		print '<description><![CDATA['.$r->annotation.']]></description>';
	} else {
		print '<description><![CDATA['.$r->text.']]></description>';
	}
	print '<guid isPermaLink="false">'.htmlspecialchars($r->name).'</guid>';
	print '<pubDate>'.date("D, d M Y H:i:s O", strtotime($r->date)).'</pubDate>';
	print '</item>';
}
print ' </channel></rss>';


?>

