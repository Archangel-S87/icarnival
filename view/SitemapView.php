<?PHP

require_once('View.php');

class SitemapView extends View
{
    function fetch()
    {
        $url = $this->request->get('page_url', 'string');
        
        $page = $this->pages->get_page($url);
        
        // Отображать скрытые страницы только админу
        if(empty($page) || (!$page->visible && empty($_SESSION['admin'])))
            return false;
        
        $pages = $this->pages->get_pages(array('visible'=>1));
        $this->design->assign('pages', $pages);
        
    	$links = $this->links->get_links(array('visible'=>1));
        $this->design->assign('links', $links);
        
        $surveys = $this->surveys->get_surveys(array('visible'=>1));
        $this->design->assign('surveys', $surveys);
        
        $posts = $this->blog->get_posts(array('visible'=>1));
        $this->design->assign('posts', $posts);

		$articles = $this->articles->get_articles(array('visible'=>1));
        $this->design->assign('articles', $articles);
        
        $categories = $this->categories->get_categories_tree();
        $categories = $this->cat_tree($categories);
        $this->design->assign('cats', $categories);
        
		$brands = $this->brands->get_brands(array('active'=>1));
		$this->design->assign('brands', $brands);
        
        return $this->design->fetch('sitemap.tpl');
    }
    
    private function cat_tree($categories) {

        foreach($categories AS $k=>$v) {
            if(isset($v->subcategories)) $this->cat_tree($v->subcategories);
            $categories[$k]->products = $this->products->get_products(array('category_id' => $v->id, 'limit'=>5000));  
        } 
        
        return $categories;
    }
}
