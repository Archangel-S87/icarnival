<?PHP

require_once('View.php');

class ServicesView extends View
{
	public function fetch()
	{
		$url = $this->request->get('service_url', 'string');
		
		return $this->fetch_services($url);
	}
	
	// Отображение списка постов
	private function fetch_services()
	{

		$filter = array();
	
		// GET-Параметры
		$category_url = $this->request->get('category', 'string');
		
		// Выберем текущую категорию
		if (!empty($category_url))
		{
			$category = $this->services_categories->get_services_category((string)$category_url);
			if (empty($category) || (!$category->visible && empty($_SESSION['admin'])))
				return false;
			$this->design->assign('category', $category);
			
			$filter['category_id'] = $category->children;
			// изображения 
			$service = new \stdClass();
			$service->images = $this->services_categories->get_images(array('post_id'=>$category->id));
			$this->design->assign('service', $service);
			// изображения end
		}    	

		// поиск по услугам
		$keyword = $this->request->get('keyword', 'string');
        if (!empty($keyword))
        {
            $this->design->assign('keyword', $keyword);
            $filter['keyword'] = $keyword;
            $filter['visible'] = 1;
            $serviceskey = $this->services_categories->get_services($filter);
            $this->design->assign('serviceskey', $serviceskey);
        }
		// поиск по услугам end

		/*// Сортировка, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
		if($sort = $this->request->get('services_sort', 'string'))
			$_SESSION['services_sort'] = $sort;		
		if (!empty($_SESSION['services_sort']))
			$filter['sort'] = $_SESSION['services_sort'];			
		else
			$filter['sort'] = 'position';			
		$this->design->assign('sort', $filter['sort']);*/
	
		
		// Устанавливаем мета-теги и заголовки в зависимости от запроса
		if(isset($this->page->url) && $this->page->url == 'services')
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);

			$this->db->query("SELECT c.last_modify FROM __services_categories c");
			$last_modify = $this->db->results('last_modify');
			$last_modify[] = $this->page->last_modify;
			$this->setHeaderLastModify(max($last_modify), 604800); // expires 604800 - week
		}
		elseif($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			$this->setHeaderLastModify($this->page->last_modify, 2592000); // expires 2592000 - month
		}
		elseif(isset($category))
		{
			$this->design->assign('meta_title', $category->meta_title);
			$this->design->assign('meta_keywords', $category->meta_keywords);
			$this->design->assign('meta_description', $category->meta_description);
			$this->setHeaderLastModify($category->last_modify, 2592000); // expires 2592000 - month
		}
		
		$body = $this->design->fetch('services.tpl');
		
		return $body;
	}	
}