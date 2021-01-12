<?php
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

header("Content-type: text/xml; charset=UTF-8");
print '<?xml version="1.0" encoding="utf-8"?><rss version="2.0"><channel>';
print '<title>'.htmlspecialchars($fivecms->settings->site_name).'</title>';
print '<link>'.$fivecms->config->root_url.'</link>';
print '<lastBuildDate>'.date("D, d M Y H:i:s O").'</lastBuildDate>';
print '<language>ru-ru</language>';
print '<description>'.htmlspecialchars($fivecms->settings->site_name).'</description>';

$filter['visible'] = 1;
$rss = $fivecms->blog->get_posts($filter);

$posts_ids = array();
foreach($rss as $r) {
	$posts[$r->id] = $r;
	$posts_ids[] = $r->id;
}

$images = array();
foreach($fivecms->blog->get_images() as $i)
  $images[$i->post_id][] = $i->filename;

foreach($rss as $r) {
	print '<item>';
		print '<title>'.htmlspecialchars($r->name).'</title>';
		print '<link>'.$fivecms->config->root_url.'/blog/'.$r->url.'</link>';
		if ($r->annotation) {
			print '<description><![CDATA['.$r->annotation.']]></description>';
		} else {
			print '<description><![CDATA['.$r->text.']]></description>';
		}
		
		/*$cnt=0;
		foreach($images[$r->id] as $v)
		if($cnt<1){
		print "<image><url>".$fivecms->design->resize_modifier($v, 400, 400, false, $fivecms->config->resized_blog_images_dir)."</url><title>".$r->name."</title><link>".$fivecms->config->root_url."/blog/".$r->url."</link></image>
		";$cnt++;}*/
		
		/*print "<image><url>".$fivecms->design->resize_modifier($images[$r->id][0], 400, 400, false, $fivecms->config->resized_blog_images_dir)."</url><title>".$r->name."</title><link>".$fivecms->config->root_url."/blog/".$r->url."</link></image>
		";*/
	
		print '<guid isPermaLink="false">'.htmlspecialchars($r->name).'</guid>';
		print '<pubDate>'.date("D, d M Y H:i:s O", strtotime($r->date)).'</pubDate>';
		//print '<pubDateUT>'.time(strtotime($r->date)).'</pubDateUT>';
	print '</item>';
}
print ' </channel></rss>';

?>

