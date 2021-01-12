<?php
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

header("Content-type: application/rss+xml; charset=UTF-8");
print '<?xml version="1.0" encoding="utf-8"?>';
print '<rss 
	xmlns:yandex="http://news.yandex.ru"
    xmlns:media="http://search.yahoo.com/mrss/"
    xmlns:turbo="http://turbo.yandex.ru"
    version="2.0">
';
print '<channel>';
print '<turbo:cms_plugin>B72BDECFC64B5820494C626D5455F4B2</turbo:cms_plugin>';
print '<title>'.htmlspecialchars($fivecms->settings->site_name).'</title>';
print '<link>'.$fivecms->config->root_url.'</link>';
print '<description>'.htmlspecialchars($fivecms->settings->site_name).'</description>';
if($fivecms->settings->counters) {
	print '<turbo:analytics id="'.$fivecms->settings->counters.'" type="Yandex"></turbo:analytics>';
}
if($fivecms->settings->analytics) {
	print '<turbo:analytics id="'.$fivecms->settings->counters.'" type="Google"></turbo:analytics>';
}

$filter['visible'] = 1;
$rss = $fivecms->articles->get_articles($filter);

foreach($rss as $r) {
	print '<item turbo="true">';
		print '<title>'.htmlspecialchars($r->name).'</title>';
		print '<link>'.$fivecms->config->root_url.'/article/'.$r->url.'</link>';
		print '<turbo:topic>'.htmlspecialchars($r->name).'</turbo:topic>';
        print '<turbo:source>'.$fivecms->config->root_url.'/article/'.$r->url.'</turbo:source>';
        print '<pubDate>'.$r->last_modify.'</pubDate>'; // D, d M Y H:i:s +0000
		print '<turbo:content><![CDATA[';
		
		$images = array();
   		$images = $fivecms->articles->get_images(array('post_id'=>$r->id));
   		
   		/*// Выводим первое изображение
   		if(!empty($images)){
   			print '<figure><img src="'.$fivecms->design->resize_modifier($images[0]->filename, 400, 400, false, $fivecms->config->resized_articles_images_dir).'"/></figure>';
   		}*/
		
		if(!empty($r->text)) {
			$content = $r->text;
		} elseif(!empty($r->annotation)) {
			$content = $r->annotation;
		} elseif(!empty($r->meta_description)) {
			$content = $r->meta_description;	
		}
		
		if(!empty($content)){
			// Декодируем спецсимволы
			$content = preg_replace('/[\x00-\x1F\x7F]/u', '', $content);
			$content = preg_replace('/«/', '"', $content);
			$content = preg_replace('/»/', '"', $content);
			$content = preg_replace('/&nbsp;/', ' ', $content);
			$content = preg_replace('/&mdash;/', '-', $content);
			$content = preg_replace('/&amp;/', '&', $content);
			$content = preg_replace('/&lt;/', '<', $content);
			$content = preg_replace('/&gt;/', '>', $content);
			$content = preg_replace( '/^\s*\/\/<!\[CDATA\[([\s\S]*)\/\/\]\]>\s*\z/', '$1', $content );
			$content = preg_replace('/<!--(.|\s)*?-->/', '', $content);
			$content = preg_replace('#&[^\s]([^\#])(?![a-z1-4]{1,10};)#i', '&#x26;$1', $content);
			//добавляем alt если его вообще нет в теге img
			/*$pattern = "/<img(?!([^>]*\b)alt=)([^>]*?)>/i";
			$replacement = '<img alt="'.htmlspecialchars($r->name).'"$1$2>';
			$content = preg_replace( $pattern, $replacement, $content );*/
			// устанавливаем alt равным названию записи, если он пустой
			/*$pattern = "/<img alt=\"\" (.*?) \/>/i";
			$replacement = '<img alt="'.htmlspecialchars($r->name).'" $1 />';
			$content = preg_replace($pattern, $replacement, $content);*/
			// оборачиваем изображения в figure
			$content = preg_replace('/(<img\s(.+?)\/?>)/is', '<figure>$1</figure>', $content);
			// преобразуем iframe с видео
			$pattern = "/<iframe title=\"(.*?)\"(.*?) allow=\"(.*?)\"(.*?)><\/iframe>/i";
			$replacement = '<iframe$2 allowfullscreen="true"></iframe>';
			$content = preg_replace($pattern, $replacement, $content);
		
			print $content;
		}

		if(!empty($images)){		  
			print '<div data-block="gallery">';
			foreach($images as $i){
				print '<img src="'.$fivecms->design->resize_modifier($i->filename, 400, 400, false, $fivecms->config->resized_articles_images_dir).'"/>';
			}
			print '</div>';
		}
		
		if(!empty($r->text)){
			print '<button formaction="'.$fivecms->config->root_url.'/article/'.$r->url.'" data-background-color="#0893b9" data-color="#ffffff" data-turbo="false" data-primary="true" >Полная версия ...</button>';
   		}
		
		print ']]></turbo:content>';
		
	print '</item>';
}
print ' </channel></rss>';
?>
