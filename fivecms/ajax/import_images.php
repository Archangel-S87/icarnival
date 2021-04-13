<?php
session_start();
require_once('../../api/Fivecms.php');

class ImportAjax extends Fivecms
{	
	
	public function import()
	{
		if(!$this->managers->access('import'))
			return false;
		
		// стартуем с этой строчки, 0 - сначала
		$from = $this->request->get('from', 'integer');
		
		$result = new stdClass;

		// Получаем массив товаров и изображений		
		$filter = array();
		$filter['page'] = max(1, $from);
		$filter['limit'] = $this->request->get('step', 'integer');
		
		$products_count = $this->products->count_products($filter);
	  	
		if($filter['limit']>0)	 
	  	$pages_count = ceil($products_count/$filter['limit']);
		else
		  	$pages_count = 0;
		  	
		$products = array();
		foreach($this->products->get_products($filter) as $p)
			$products[$p->id] = $p;  	
		
		if(!empty($products))
		{	
			$products_ids = array_keys($products);
			$images = $this->products->get_images(array('product_id'=>$products_ids));
			// Проверка загрузки всех изображений из интернета
				foreach($images as $url){
					if(!empty($url->filename) && (substr($url->filename,0,7) == 'http://' || substr($url->filename,0,8) == 'https://')){
						$new_name=$this->image->download_image($url->filename);
					}
				}
			//	Проверка загрузки всех изображений из интернета @
		}
		// Получаем массив товаров и изображений @
		
		// Создаем объект результата
		
 		$result->end = $pages_count;
		$result->from = $from + 1;          // На каком месте остановились

		return $result;
	}
	
}

$import_ajax = new ImportAjax();
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		
		
$json = json_encode($import_ajax->import());
print $json;
