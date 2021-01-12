<?php

chdir(__DIR__);
require_once('api/Fivecms.php');
$fivecms = new Fivecms();
define("MAX_URLS", 50000);

/*
 * чтобы сгенерировать файлы с браузера нужно в браузере перейти по ссылке
 * http://domain.com/sitemap.php?output=file
 */
$params = array();
if (!empty($argv)) {
    $params['output'] = 'file';
    for ($i = 1; $i < count($argv); $i++) {
        $arg = explode("=", $argv[$i]);
        $params[$arg[0]] = $arg[1];
    }
    $params['root_url'] = trim($params['root_url']);
    $params['root_url'] = preg_replace("~^(https?://[^/]+)/.*$~", "$1", $params['root_url']);
} else {
    if (isset($_GET['output']) && $_GET['output']=='file') {
        $params['output'] = 'file';
    } else {
        $params['output'] = 'browser';
    }
    $params['root_url'] = $fivecms->config->root_url;
}

$main_url = $params['root_url'].'/';

if ($params['output'] == 'file') {
    $sub_sitemaps = glob($fivecms->config->root_dir . "/sitemap_*.xml");
    if (is_array($sub_sitemaps)) {
        foreach ($sub_sitemaps as $sitemap) {
            @unlink($sitemap);
        }
    }
    if (file_exists($fivecms->config->root_dir . "/sitemap_big.xml")) {
        @unlink($fivecms->config->root_dir . "sitemap_big.xml");
    }
} else {
    header("Content-type: text/xml; charset=UTF-8");
}

$sitemap_index = 1;
$url_index = 0;
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
write("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");
$s = "\t<url>\n";
$s .= "\t\t<loc>$main_url</loc>\n";
$s .= "\t\t<changefreq>daily</changefreq>\n";
$s .= "\t\t<priority>1.0</priority>\n";
$s .= "\t</url>\n";
write($s, true);

// Страницы
foreach($fivecms->pages->get_pages(array('visible'=>1)) as $p) {
    if($p->url && $p->url != '404') {
        $url = $main_url.esc($p->url);
        
        $last_modify = array();
        if ($p->url == 'blog') {
            $fivecms->db2->query("SELECT b.last_modify FROM __blog b");
            $last_modify = $fivecms->db2->results('last_modify');
        } elseif ($p->url == 'articles') {
            $fivecms->db2->query("SELECT c.last_modify FROM __articles_categories c");
            $last_modify = $fivecms->db2->results('last_modify');
        } elseif ($p->url == 'surveys') {
            $fivecms->db2->query("SELECT c.last_modify FROM __surveys_categories c");
            $last_modify = $fivecms->db2->results('last_modify');
        } elseif ($p->url == 'services') {
            $fivecms->db2->query("SELECT c.last_modify FROM __services_categories c");
            $last_modify = $fivecms->db2->results('last_modify');
        } elseif ($p->url == 'catalog') {
            $fivecms->db2->query("SELECT c.last_modify FROM __categories c");
            $last_modify = $fivecms->db2->results('last_modify');
        }
		$last_modify[] = $p->last_modify;
		$last_modify = max($last_modify);
		$last_modify = substr($last_modify, 0, 10);
        
        $s = "\t<url>\n";
        $s .= "\t\t<loc>$url</loc>\n";
        $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
        $s .= "\t\t<changefreq>daily</changefreq>\n";
        $s .= "\t\t<priority>1.0</priority>\n";
        $s .= "\t</url>\n";
        write($s, true);
    }
}

// Категории блога
foreach($fivecms->blog_categories->get_categories(array('visible'=>1)) as $bc)
{
	$url = $main_url.'sections/'.esc($bc->url);
	$s = "\t<url>"."\n";
	$s .= "\t\t<loc>$url</loc>"."\n";
	$last_modify = substr($bc->last_modify, 0, 10);
	if($last_modify)
		$s .= "\t\t<lastmod>$last_modify</lastmod>"."\n";
	$s .= "\t\t<changefreq>weekly</changefreq>"."\n";
	$s .= "\t\t<priority>1.0</priority>"."\n";
	$s .= "\t</url>"."\n";
	write($s, true);
}

// Блог
$posts_count = $fivecms->blog->count_posts(array('visible'=>1));
foreach($fivecms->blog->get_posts(array('visible'=>1, 'limit'=>$posts_count)) as $p) {
    $url = $main_url.'blog/'.esc($p->url);
    $last_modify = substr($p->last_modify, 0, 10);
    $s = "\t<url>\n";
    $s .= "\t\t<loc>$url</loc>\n";
    $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
    $s .= "\t\t<changefreq>daily</changefreq>\n";
    $s .= "\t\t<priority>1.0</priority>\n";
    $s .= "\t</url>\n";
    write($s, true);
}

// Категории статей
foreach($fivecms->articles_categories->get_articles_categories(array('visible'=>1)) as $ac)
{
	if($ac->visible)
	{
		$url = $main_url.'articles/'.esc($ac->url);
		$s = "\t<url>"."\n";
		$s .= "\t\t<loc>$url</loc>"."\n";
		$last_modify = substr($ac->last_modify, 0, 10);
		if($last_modify)
			$s .= "\t\t<lastmod>$last_modify</lastmod>"."\n";
		$s .= "\t\t<changefreq>weekly</changefreq>"."\n";
		$s .= "\t\t<priority>1.0</priority>"."\n";
		$s .= "\t</url>"."\n";
		write($s, true);
	}
}

// Статьи
$articles_count = $fivecms->articles->count_articles(array('visible'=>1));
foreach($fivecms->articles->get_articles(array('visible'=>1, 'limit'=>$articles_count)) as $p) {
	$url = $main_url.'article/'.esc($p->url);
	$s = "\t<url>"."\n";
	$s .= "\t\t<loc>$url</loc>"."\n";
    $last_modify = substr($p->last_modify, 0, 10);
    if($last_modify)
    	$s .= "\t\t<lastmod>$last_modify</lastmod>"."\n";
    $s .= "\t\t<changefreq>monthly</changefreq>"."\n";
    $s .= "\t\t<priority>1.0</priority>"."\n";
	$s .= "\t</url>"."\n";
	write($s, true);
}

foreach($fivecms->services_categories->get_services_categories() as $sc)
{
	if($sc->visible)
	{
		$url = $main_url.'services/'.esc($sc->url);
		$s = "\t<url>"."\n";
		$s .= "\t\t<loc>$url</loc>"."\n";
		$last_modify = substr($sc->last_modify, 0, 10);
		if($last_modify)
			$s .= "\t\t<lastmod>$last_modify</lastmod>"."\n";
		$s .= "\t\t<changefreq>monthly</changefreq>"."\n";
		$s .= "\t\t<priority>1.0</priority>"."\n";
		$s .= "\t</url>"."\n";
		write($s, true);
	}
}

foreach($fivecms->links->get_links(array('visible'=>1)) as $ln)
{
		$url = $main_url.'pages/'.esc($ln->url);
		$s = "\t<url>"."\n";
		$s .= "\t\t<loc>$url</loc>"."\n";
		$s .= "\t</url>"."\n";
		write($s, true);
}

foreach($fivecms->surveys->get_surveys(array('visible'=>1)) as $sr)
{
	$url = $main_url.'survey/'.esc($sr->url);
	$s = "\t<url>"."\n";
	$s .= "\t\t<loc>$url</loc>"."\n";
    $last_modify = substr($sr->last_modify, 0, 10);
    if($last_modify)
    	$s .= "\t\t<lastmod>$last_modify</lastmod>"."\n";
    $s .= "\t\t<changefreq>monthly</changefreq>"."\n";
    $s .= "\t\t<priority>1.0</priority>"."\n";
	$s .= "\t</url>"."\n";
	write($s, true);
}

// Категории
foreach($fivecms->categories->get_categories() as $c) {
    if($c->visible) {
        $url = $main_url.'catalog/'.esc($c->url);
        $last_modify = array();
        $fivecms->db2->query("SELECT p.last_modify
            FROM __products p
            INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)
            WHERE 1
            GROUP BY p.id", $c->children);
        $res = $fivecms->db2->results('last_modify');
        if (!empty($res)) {
            $last_modify = $res;
        }
        $last_modify[] = $c->last_modify;
        $last_modify = substr(max($last_modify), 0, 10);
        $s = "\t<url>\n";
        $s .= "\t\t<loc>$url</loc>\n";
        $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
        $s .= "\t\t<changefreq>daily</changefreq>\n";
        $s .= "\t\t<priority>1.0</priority>\n";
        $s .= "\t</url>\n";
        write($s, true);
    }
}

// Бренды
foreach($fivecms->brands->get_brands(array('active'=>1)) as $b) {
    $url = $main_url.'brands/'.esc($b->url);
    $last_modify = array();
    $fivecms->db2->query("SELECT p.last_modify
        FROM __products p
        WHERE p.brand_id=?", $b->id);
    $res = $fivecms->db2->results('last_modify');
    if (!empty($res)) {
        $last_modify = $res;
    }
    $last_modify[] = $b->last_modify;
    $last_modify = substr(max($last_modify), 0, 10);
    $s = "\t<url>\n";
    $s .= "\t\t<loc>$url</loc>\n";
    $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
    $s .= "\t\t<changefreq>daily</changefreq>\n";
    $s .= "\t\t<priority>1.0</priority>\n";
    $s .= "\t</url>\n";
    write($s, true);
}

// Товары
$fivecms->db2->query("SELECT url, created FROM __products WHERE visible=1");
foreach($fivecms->db2->results() as $p) {
    $url = $main_url.'products/'.esc($p->url);
    $last_modify = substr($p->created, 0, 10);
    $s = "\t<url>\n";
    $s .= "\t\t<loc>$url</loc>\n";
    $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
    $s .= "\t\t<changefreq>weekly</changefreq>\n";
    $s .= "\t\t<priority>0.5</priority>\n";
    $s .= "\t</url>\n";
    write($s, true);
}

write("</urlset>\n");

if ($params['output'] == 'file') {
    $last_modify = date("Y-m-d");
    $file = 'sitemap_big.xml';
    file_put_contents($file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    file_put_contents($file, "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n", FILE_APPEND);
    for ($i = 1; $i <= $sitemap_index; $i++) {
        $url = $params['root_url'].'/sitemap_'.$i.'.xml';
        file_put_contents($file, "\t<sitemap>"."\n", FILE_APPEND);
        file_put_contents($file, "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
        file_put_contents($file, "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
        file_put_contents($file, "\t</sitemap>"."\n", FILE_APPEND);
    }
    file_put_contents($file, '</sitemapindex>'."\n", FILE_APPEND);
}

function esc($s) {
    return(htmlspecialchars($s, ENT_QUOTES, 'UTF-8'));
}

function write ($str, $count_url = false) {
    global $params, $sitemap_index, $url_index;
    if ($params['output'] == 'file') {
        $file = 'sitemap_'.$sitemap_index.'.xml';
        file_put_contents($file, $str, FILE_APPEND);
        if ($count_url && ++$url_index == MAX_URLS) {
            file_put_contents($file, '</urlset>'."\n", FILE_APPEND);
            $url_index=0;
            $sitemap_index++;
            $file = 'sitemap_'.$sitemap_index.'.xml';
            file_put_contents($file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            file_put_contents($file, "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n", FILE_APPEND);
        }
    } else {
        print $str;
    }
}

