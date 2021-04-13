<?php
session_start();
require_once('../../api/Fivecms.php');

class ExportAjax extends Fivecms
{	
	private $columns_names = array(
			'category'=>         'Категория',
			'name'=>             'Товар',
			'price'=>            'Цена',
			'discount'=>     	 'Скидка',
			'discount_date'=>    'До даты',
			'url'=>              'Адрес',
			'visible'=>          'Видим',
			'featured'=>         'Рекомендуемый',
			'is_new'=>			 'Новинка',
			'to_yandex'=>		 'Яндекс маркет',
			'brand'=>            'Бренд',
			'variant'=>          'Вариант',
			'variant1'=>         'Св-во1',
			'variant2'=>         'Цвет',
			'rating'=>           'Рейтинг',
			'votes'=>            'Голосов',
			'compare_price'=>    'Старая цена',
			'sku'=>              'Артикул',
			'stock'=>            'Склад',
			'unit'=>             'Ед-ца измерения',
			'currency_id'=>      'Валюта',
			'meta_title'=>       'Заголовок страницы',
			'meta_keywords'=>    'Ключевые слова',
			'meta_description'=> 'Описание страницы',
			'annotation'=>       'Аннотация',
			'body'=>             'Описание',
			'images'=>           'Изображения',
			'files'=>         	 'Files'
			);
			
	private $column_delimiter = ';';
	private $category_delimiter = '#';
	private $subcategory_delimiter = '/';
	private $products_count = 10;
	private $export_files_dir = '../files/export/';
	private $filename = 'export.csv';
	private $option_delimiter='#';

	public function fetch()
	{

		if(!$this->managers->access('export'))
			return false;

		// Эксель кушает только 1251
		setlocale(LC_ALL, 'ru_RU.1251');
		$this->db->query('SET NAMES cp1251');
	
		// Страница, которую экспортируем
		$page = $this->request->get('page');
		if(empty($page) || $page==1)
		{
			$page = 1;
			// Если начали сначала - удалим старый файл экспорта
			if(is_writable($this->export_files_dir.$this->filename))
				unlink($this->export_files_dir.$this->filename);
		}
		
		// Открываем файл экспорта на добавление
		$f = fopen($this->export_files_dir.$this->filename, 'ab');
		
		// Добавим в список колонок свойства товаров
		$filter = array('page'=>$page, 'limit'=>$this->products_count);
        $features_filter = array();
        if (($cid = $this->request->get('category_id', 'integer')) && ($category = $this->categories->get_category($cid))) {
            $filter['category_id'] = $features_filter['category_id'] = $category->children;
        }
        if ($brand_id = $this->request->get('brand_id', 'integer')) {
            $filter['brand_id'] = $brand_id;
        }
		
		$features = $this->features->get_features($features_filter);
		foreach($features as $feature)
			$this->columns_names[$feature->name] = $feature->name;
		
		// Если начали сначала - добавим в первую строку названия колонок
		if($page == 1)
		{
			fputcsv($f, $this->columns_names, $this->column_delimiter);
		}
		
		// Все товары
		
		// multicurrency
		$currencies = $this->money->get_currencies(array('enabled'=>1));
		$main_currency = reset($currencies);
		// multicurrency end
		
		$products = array();

 		foreach($this->products->get_products($filter) as $p) 
 		{
 			$products[$p->id] = (array)$p;
 			
	 		// Свойства товаров
	 		$options = $this->features->get_product_options($p->id);
			
			if(is_array($options))
			{
			$temp_options = array();
			foreach($options as $option){
				if(isset($temp_options[$option->feature_id]))
					$temp_options[$option->feature_id]->value .= $this->option_delimiter.$option->value; 
				else
					$temp_options[$option->feature_id] = $option;
			}
			$options = $temp_options;
			}
			
	 		foreach($options as $option)
	 		{
	 			if(!isset($products[$option->product_id][$option->name]))
					//$products[$option->product_id][$option->name] = $option->value;
					$products[$option->product_id][$option->name] = preg_replace('/(\d+),(\d+)/', '$1.$2', trim($option->value));
	 		}

 		}
 		
 		if(!empty($products)) {
 			// Категории товаров
			foreach($products as $p_id=>&$product)
			{
				$categories = array();
				$cats = $this->categories->get_product_categories($p_id);
				foreach($cats as $category)
				{
					$path = array();
					$cat = $this->categories->get_category((int)$category->category_id);
					if(!empty($cat))
					{
						// Вычисляем составляющие категории
						foreach($cat->path as $p)
							$path[] = str_replace($this->subcategory_delimiter, '\\'.$this->subcategory_delimiter, $p->name);
						// Добавляем категорию к товару 
						$categories[] = implode($this->subcategory_delimiter, $path);
					}
				}
				$product['category'] = implode($this->category_delimiter.' ', $categories);
			}
		
			// Изображения товаров
			$images = $this->products->get_images(array('product_id'=>array_keys($products)));
			foreach($images as $image)
			{
				// Добавляем изображения к товару через запятую
				if(empty($products[$image->product_id]['images']))
					$products[$image->product_id]['images'] = $image->filename;
				else
					$products[$image->product_id]['images'] .= ', '.$image->filename;
			}
			
			// Прикрепленные файлы товаров
			$files = $this->files->get_files(array('object_id'=>array_keys($products),'type'=>'product'));
			foreach($files as $file)
			{
				// Добавляем файлы к товару через запятую
				if(empty($products[$file->object_id]['files']))
					$products[$file->object_id]['files'] = $file->filename;
				else
					$products[$file->object_id]['files'] .= ', '.$file->filename;
			}
 
			$variants = $this->variants->get_variants(array('product_id'=>array_keys($products)), 1);

			foreach($variants as $variant)
			{
				if(isset($products[$variant->product_id]))
				{
					$v                   = array();
					$v['variant']        = $variant->name;
					$v['variant1']       = $variant->name1;
					$v['variant2']       = $variant->name2;
					$v['price']          = $variant->oprice;
					$v['discount']   	 = $variant->discount;
					$v['discount_date']  = $variant->discount_date;
					$v['compare_price']  = $variant->compare_oprice;
					$v['sku']            = $variant->sku;
					$v['stock']          = $variant->stock;
					$v['unit']           = $variant->unit;
					// multicurrency
					if($variant->currency_id > 0) {
						$v['currency_id'] = $variant->currency_id;
					} else {
						$v['currency_id'] = $main_currency->id;
					}
					// multicurrency end
					if($variant->infinity)
						$v['stock']           = '';
					$products[$variant->product_id]['variants'][] = $v;
				}
			}
		
			foreach($products as &$product)
			{
				$variants = $product['variants'];
				unset($product['variants']);
			
				if(isset($variants))
				foreach($variants as $variant)
				{
					$result = array();
					$result =  $product;
					foreach($variant as $name=>$value)
						$result[$name]=$value;

					foreach($this->columns_names as $internal_name=>$column_name)
					{
						if(isset($result[$internal_name]))
							$res[$internal_name] = $result[$internal_name];
						else
							$res[$internal_name] = '';
					}
					fputcsv($f, $res, $this->column_delimiter);

				}
			}

		}
		fclose($f);

		$total_products = $this->products->count_products($filter);

        if($this->products_count*$page < $total_products) {
        	return array('end'=>false, 'page'=>$page, 'totalpages'=>$total_products/$this->products_count);
        } else {
            return array('end'=>true, 'page'=>$page, 'totalpages'=>$total_products/$this->products_count);
        }

	}
	
}

$export_ajax = new ExportAjax();
$data = $export_ajax->fetch();
if($data)
{
	header("Content-type: application/json; charset=utf-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");
	
	$json = json_encode($data);
	print $json;
}