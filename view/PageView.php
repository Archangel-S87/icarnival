<?PHP
/**
 * @copyright 	5CMS
 * @link 		http://5cms.ru
 * Этот класс использует шаблон page.tpl
 */
require_once('View.php');

class PageView extends View
{
	function fetch()
	{
		$url = $this->request->get('page_url', 'string');
		$page = $this->pages->get_page($url);
		
		// Отображать скрытые страницы только админу
		if(empty($page) || (!$page->visible && empty($_SESSION['admin'])))
			return false;
		
		$this->design->assign('page', $page);
		$this->design->assign('meta_title', $page->meta_title);
		$this->design->assign('meta_keywords', $page->meta_keywords);
		$this->design->assign('meta_description', $page->meta_description);
		
		// Метаданные страниц
		$currentURL=$_SERVER['REQUEST_URI'];
		$metadata_page=$this->metadatapages->get_metadata_page($currentURL);
        if(!empty($metadata_page)) {
            $this->design->assign('metadata_page',$metadata_page);
            if(!empty($metadata_page->meta_title)) 
            	$this->design->assign('meta_title', $metadata_page->meta_title);
            if(!empty($metadata_page->meta_keywords)) 
				$this->design->assign('meta_keywords', $metadata_page->meta_keywords);
			if(!empty($metadata_page->meta_description)) 
				$this->design->assign('meta_description', $metadata_page->meta_description);
			if(!empty($metadata_page->h1_title)) 
				$this->design->assign('h1_title', $metadata_page->h1_title);				
		}
		
		if($page->url == 'catalog')
			$this->setHeaderLastModify($page->last_modify, 604800); // expires 604800 - week
		else
			$this->setHeaderLastModify($page->last_modify, 2592000); // expires 2592000 - month
		
		return $this->design->fetch('page.tpl');
	}
}