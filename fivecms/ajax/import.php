<?php
session_start();
require_once('../../api/Fivecms.php');

class ImportAjax extends Fivecms
{	
	// Соответствие имени колонки и поля в базе
	private $internal_columns_names = array();

	private $import_files_dir      = '../files/import/'; // Временная папка		
	private $import_file           = 'import.csv';       // Временный файл
	private $log_file              = 'import.log';       // Log файл
	private $flog                                ;       // Хендлер Log файла
	private $log_renew             = true;               // Удалять каждый раз
	private $column_delimiter      = ';';
	private $products_count        = 10;
	private $columns               = array();
	private $option_delimiter	   = '#';

	private function log_item($item, $type, $update = true)
	{
		$tms = date('Y.m.d H:i:s');
		$action = $update ? 'upd' : 'add';
		fwrite($this->flog,"$tms [$action] [$type]\t$item\r\n");
	}
	
	public function import()
	{
		if(!$this->managers->access('import'))
			return false;
		
		// стартуем с этой строчки, 0 - сначала
		$from = $this->request->get('from');
		
		// Лог файл обновления
		$log_fn = $this->import_files_dir . $this->log_file;
		if ($from=='0' && file_exists($log_fn))
			unlink($log_fn);
		$this->flog = fopen($log_fn, 'a');

		// Для корректной работы установим локаль UTF-8
		setlocale(LC_ALL, 'ru_RU.UTF-8');
		
		$result = new stdClass;
		
		// Определяем колонки из первой строки файла
		$f = fopen($this->import_files_dir.$this->import_file, 'r');
		$this->columns = fgetcsv($f, null, $this->column_delimiter);

		// Заменяем имена колонок из файла на внутренние имена колонок
		foreach($this->columns as &$column)
		{ 
			if($internal_name = $this->internal_column_name($column))
			{
				$this->internal_columns_names[$column] = $internal_name;
				$column = $internal_name;
			}
		}

		// Если нет названия товара - не будем импортировать
		if(!in_array('name', $this->columns) && !in_array('sku', $this->columns))
			return false;
	 	
		// Переходим на заданную позицию, если импортируем не сначала
		if($from)
			fseek($f, $from);
		
		// Массив импортированных товаров
		$imported_items = array();	
		
		// Проходимся по строкам, пока не конец файла
		// или пока не импортировано достаточно строк для одного запроса
		for($k=0; !feof($f) && $k<$this->products_count; $k++)
		{ 
			// Читаем строку
			$line = fgetcsv($f, 0, $this->column_delimiter);

			$product = null;			

			if(is_array($line))			
			// Проходимся по колонкам строки
			foreach($this->columns as $i=>$col)
			{
				// Создаем массив item[название_колонки]=значение
 				if(isset($line[$i]) && !empty($line) && !empty($col))
					$product[$col] = $line[$i];
			}
			
			// Импортируем этот товар
	 		if($imported_item = $this->import_item($product))
				$imported_items[] = $imported_item;
		}
		
		// Запоминаем на каком месте закончили импорт
 		$from = ftell($f);
 		
 		// И закончили ли полностью весь файл
 		$result->end = feof($f);
		
		fclose($this->flog);

		fclose($f);
		$size = filesize($this->import_files_dir.$this->import_file);
		
		// Создаем объект результата
		$result->from = $from;          // На каком месте остановились
		$result->totalsize = $size;     // Размер всего файла
		$result->items = $imported_items;   // Импортированные товары

		return $result;
	}
	
	// Импорт одного товара $item[column_name] = value;
	private function import_item($item)
	{
		$imported_item = new stdClass;
		
		// Проверим не пустое ли название и артикул (должно быть хоть что-то из них)
		if(empty($item['name']) && empty($item['sku']))
			return false;

		// Подготовим товар для добавления в базу
		$product = array();
		
		if(isset($item['name']))
			$product['name'] = trim($item['name']);
			
		if(isset($item['typePrefix']) && isset($item['name'])){
			$product['name'] = trim($item['typePrefix']).(!empty($item['brand']) ? ' '.$item['brand'].' ' : ' ').trim($item['name']);
		}

		if(isset($item['meta_title']))
			$product['meta_title'] = trim($item['meta_title']);

		if(isset($item['meta_keywords']))
			$product['meta_keywords'] = trim($item['meta_keywords']);

		if(isset($item['meta_description']))
			$product['meta_description'] = trim($item['meta_description']);

		if(isset($item['annotation']))
			$product['annotation'] = trim($item['annotation']);

		if(isset($item['description']))
			$product['body'] = trim($item['description']);
			
		if(isset($item['rating']))
			$product['rating'] = trim($item['rating']);

		if(isset($item['votes']))
			$product['votes'] = trim($item['votes']);

		if(isset($item['views']))
			$product['views'] = trim($item['views']);
	
		if(isset($item['visible']))
			$product['visible'] = intval($item['visible']);

		if(isset($item['featured']))
			$product['featured'] = intval($item['featured']);
			
		if(isset($item['is_new']))
			$product['is_new'] = intval($item['is_new']);

		if(isset($item['to_yandex']))
			$product['to_yandex'] = intval($item['to_yandex']);
	
		if(!empty($item['url']))
			$product['url'] = trim($item['url']);
	
		// Если задан бренд
		if(!empty($item['brand']))
		{
			$item['brand'] = trim($item['brand']);
			// если не попало пробелов
			if(mb_strlen($item['brand'],'UTF-8') > 0){
				// Найдем его по имени
				$this->db->query('SELECT id FROM __brands WHERE name=?', $item['brand']);
				if(!$product['brand_id'] = $this->db->result('id')){
					// Создадим, если не найден
					$product['brand_id'] = $this->brands->add_brand(array('name'=>$item['brand'], 'meta_title'=>$item['brand'], 'meta_keywords'=>$item['brand']));
					$this->log_item($item['brand'],'brand',FALSE);
				}
			}
		}
		
		// Если задана категория
		$category_delimiter = $this->settings->category_delimiter ? $this->settings->category_delimiter : '#'; // Разделитель категорий
		$category_id = null;
		$categories_ids = array();
		if(!empty($item['category']))
		{
			foreach(explode($category_delimiter, $item['category']) as $c)
				$categories_ids[] = $this->import_category($c);
			$category_id = reset($categories_ids);
		}
	
		// Подготовим вариант товара
		$variant = array();
		
		if(isset($item['variant']))
			$variant['name'] = trim($item['variant']);
			
		if(isset($item['variant1'])){
			$variant['name1'] = trim($item['variant1']);
			$variant['name'] = $variant['name1'];
		}	

		if(isset($item['variant2'])){
			$variant['name2'] = trim($item['variant2']);
			$variant['name'] = ($variant['name1'] ? $variant['name1'].' ' : '').$variant['name2'];
		}
		
		if(!empty($this->settings->import_price))
			$import_price = intval($this->settings->import_price);
		else
			$import_price = 0;
			
		if(isset($item['price'])){
			$variant['price'] = str_replace(',', '.', str_replace(' ', '', trim($item['price'])));
			$variant['price'] = $variant['price'] + $variant['price']*$import_price/100;
		}	
		
		if(isset($item['compare_price'])){
			$variant['compare_price'] = trim($item['compare_price']);
			$variant['compare_price'] = $variant['compare_price'] + $variant['compare_price']*$import_price/100;
		}
			
		if(isset($item['stock']))
			if($item['stock'] == '')
				$variant['stock'] = null;
			else
				$variant['stock'] = trim($item['stock']);
				
		if(isset($item['unit']))
			$variant['unit'] = trim($item['unit']);
			
		// multicurrency	
		if(isset($item['currency_id']))
			$variant['currency_id'] = trim($item['currency_id']);
		// multicurrency end
			
		if(isset($item['sku']))
			$variant['sku'] = trim($item['sku']);
        
        // Если задан артикул варианта, найдем этот вариант и соответствующий товар
        if(!empty($variant['sku']) && !empty($variant['name']))
		{ 
			$this->db->query('SELECT v.id as variant_id, v.product_id FROM __variants v, __products p WHERE v.sku=? AND v.name=? AND v.product_id = p.id LIMIT 1', $variant['sku'], $variant['name']);
			$result = $this->db->result();
			if($result)
			{
				// и обновим товар
				if(!empty($product) && empty($this->settings->update_products)) {
					$this->products->update_product($result->product_id, $product);
					$this->log_item($product['name'], 'product');
				}
				// и вариант
				if(!empty($variant)){
					$this->variants->update_variant($result->variant_id, $variant);
					$this->log_item($variant['name'], 'variant');
				}
				
				$product_id = $result->product_id;
				$variant_id = $result->variant_id;
				// Обновлен
				$imported_item->status = 'updated';
			}
		} elseif(!empty($variant['sku'])) { 
			$this->db->query('SELECT v.id as variant_id, v.product_id FROM __variants v, __products p WHERE v.sku=? AND v.product_id = p.id LIMIT 1', $variant['sku']);
			$result = $this->db->result();
			if($result)
			{
				// и обновим товар
				if(!empty($product) && empty($this->settings->update_products)) {
					$this->products->update_product($result->product_id, $product);
					$this->log_item($product['name'], 'product');
				}
				// и вариант
				if(!empty($variant)){
					$this->variants->update_variant($result->variant_id, $variant);
					$this->log_item($variant['name'], 'variant');
				}
				
				$product_id = $result->product_id;
				$variant_id = $result->variant_id;
				// Обновлен
				$imported_item->status = 'updated';
			}
		}
		
		// Если на прошлом шаге товар не нашелся, и задано хотя бы название товара
		if((empty($product_id) || empty($variant_id)) && isset($item['name']))
		{
			if(!empty($variant['sku']) && empty($variant['name']))
				$this->db->query('SELECT v.id as variant_id, p.id as product_id FROM __products p LEFT JOIN __variants v ON v.product_id=p.id WHERE v.sku=? LIMIT 1', $variant['sku']);			
			elseif(isset($item['variant']))
				$this->db->query('SELECT v.id as variant_id, p.id as product_id FROM __products p LEFT JOIN __variants v ON v.product_id=p.id AND v.name=? WHERE p.name=? LIMIT 1', $item['variant'], $item['name']);
			else
				$this->db->query('SELECT v.id as variant_id, p.id as product_id FROM __products p LEFT JOIN __variants v ON v.product_id=p.id WHERE p.name=? LIMIT 1', $item['name']);			
			
			$r =  $this->db->result();
			if($r)
			{
				$product_id = $r->product_id;
				$variant_id = $r->variant_id;
			}
			// Если вариант найден - обновляем,
			if(!empty($variant_id))
			{
				$this->variants->update_variant($variant_id, $variant);
				if(empty($this->settings->update_products)){
					$this->products->update_product($product_id, $product);
					$this->log_item($product['name'],'product');
				}
				$this->log_item($variant['name'],'variant');
				$imported_item->status = 'updated';		
			}
			// Иначе - добавляем
			elseif(empty($variant_id) && empty($this->settings->update_only))
			{
				if(empty($product_id))
					$product_id = $this->products->add_product($product);

                $this->db->query('SELECT max(v.position) as pos FROM __variants v WHERE v.product_id=? LIMIT 1', $product_id);
                $pos = $this->db->result('pos');

				$variant['position'] = $pos+1;
				$variant['product_id'] = $product_id;
				$variant_id = $this->variants->add_variant($variant);
				$imported_item->status = 'added';
				$this->log_item($product['name'],'product',false);
				$this->log_item($variant['name'],'variant',false);
			}
		}
		// Alternate variant & product import @
		
		if(!empty($variant_id) && !empty($product_id))
		{
			// Нужно вернуть обновленный товар
			$imported_item->variant = $this->variants->get_variant(intval($variant_id));			
			$imported_item->product = $this->products->get_product(intval($product_id));						
	
			// Добавляем категории к товару
			if(!empty($categories_ids))
				foreach($categories_ids as $c_id)
					$this->categories->add_product_category($product_id, $c_id);
	
	 		// Изображения товаров
			if(isset($item['images']))
			{
				// Изображений может быть несколько, через запятую
				$images = explode(',', $item['images']);
				foreach($images as $image)
				{
					$image = trim($image);
					if(!empty($image))
					{
						// Имя файла
						$image_filename = pathinfo($image, PATHINFO_BASENAME);
					
						// Добавляем изображение только если такого еще нет в этом товаре
						$this->db->query('SELECT filename FROM __images WHERE product_id=? AND (filename=? OR filename=?) LIMIT 1', $product_id, $image_filename, $image);
						if(!$this->db->result('filename'))
						{
							$this->products->add_image($product_id, $image);
						}
					}
				}
			}
	 		// Характеристики товаров
			foreach($item as $feature_name=>$feature_value)
			{
				// Если нет такого названия колонки, значит это название свойства
				if(!in_array($feature_name, $this->internal_columns_names))
				{ 
					// Свойство добавляем только если для товара указана категория и непустое значение свойства
					if($category_id && $feature_value!=='')
					{
						$this->db->query('SELECT f.id FROM __features f WHERE f.name=? LIMIT 1', $feature_name);
						if(!$feature_id = $this->db->result('id'))
							$feature_id = $this->features->add_feature(array('name'=>$feature_name));
						
						$this->features->add_feature_category($feature_id, $category_id);				
					
						$query = $this->db->placehold("DELETE FROM __options WHERE feature_id=? AND product_id=?", intval($feature_id), intval($product_id));
						$this->db->query($query);

						$opts=explode($this->option_delimiter, $feature_value);
						if(is_array($opts))foreach ($opts as $opt) {
							$opt=trim($opt);
							if($opt)
								$this->features->update_option2($product_id, $feature_id, $opt);
						}

					}
				
				}
			} 		
 		return $imported_item;
	 	}	
	}
	
	// Отдельная функция для импорта категории
	private function import_category($category)
	{			
		// Поле "категория" может состоять из нескольких имен, разделенных subcategory_delimiter-ом
		// Только неэкранированный subcategory_delimiter может разделять категории
		$subcategory_delimiter = $this->settings->subcategory_delimiter ? $this->settings->subcategory_delimiter : '/';  
		$delimiter = $subcategory_delimiter;
		//original variant
		$regex = "/\\DELIMITER((?:[^\\\\\DELIMITER]|\\\\.)*)/";
		$regex = str_replace('DELIMITER', $delimiter, $regex);
		$names = preg_split($regex, $category, 0, PREG_SPLIT_DELIM_CAPTURE);
		//original variant end

		//aternate variant for ,/ symbols in cat name
		//$names = preg_split('#\s*(?<!\\\)\\'.$delimiter.'\s*#', $category, 0, PREG_SPLIT_DELIM_CAPTURE);
		$id = null;   
		$parent = 0; 
		
		// Для каждой категории
		foreach($names as $name)
		{
			// Заменяем \/ на /
			$name = trim(str_replace("\\$delimiter", $delimiter, $name));
			if(!empty($name))
			{
				// Найдем категорию по имени
				$this->db->query('SELECT id FROM __categories WHERE name=? AND parent_id=?', $name, $parent);
				$id = $this->db->result('id');
				
				// Если не найдена - добавим ее
				if(empty($id)){
					$id = $this->categories->add_category(array('name'=>$name, 'parent_id'=>$parent, 'meta_title'=>$name,  'meta_keywords'=>$name));
					$this->log_item($name, 'category', false);
				}

				$parent = $id;
			}	
		}
		return $id;
	}

	private function translit($text)
	{
		$ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я"); 
		$en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");

	 	$res = str_replace($ru, $en, $text);
		$res = preg_replace("/[\s]+/ui", '-', $res);
		$res = preg_replace('/[^\p{L}\p{Nd}\d-]/ui', '', $res);
	 	$res = strtolower($res);
	    return $res;  
	}
	
	// Возвращает внутреннее название колонки по названию колонки в файле
	private function internal_column_name($name)
	{
		// Дефолтные имена колонок
		$d_name = $this->settings->d_name ? $this->settings->d_name : 'товар';
		$d_category = $this->settings->d_category ? $this->settings->d_category : 'категория';
		$d_brand = $this->settings->d_brand ? $this->settings->d_brand : 'бренд';
		$d_variant = $this->settings->d_variant ? $this->settings->d_variant : 'вариант';
		$d_variant1 = $this->settings->d_variant1 ? $this->settings->d_variant1 : 'св-во1';
		$d_variant2 = $this->settings->d_variant2 ? $this->settings->d_variant2 : 'цвет';
		$d_price = $this->settings->d_price ? $this->settings->d_price : 'цена';
		$d_sku = $this->settings->d_sku ? $this->settings->d_sku : 'артикул';
		$d_stock = $this->settings->d_stock ? $this->settings->d_stock : 'склад';
		$d_unit = $this->settings->d_unit ? $this->settings->d_unit : 'ед-ца измерения';
		$d_currency_id = $this->settings->d_currency_id ? $this->settings->d_currency_id : 'валюта';
		$d_meta_title = $this->settings->d_meta_title ? $this->settings->d_meta_title : 'заголовок страницы';
		$d_meta_description = $this->settings->d_meta_description ? $this->settings->d_meta_description : 'описание страницы';
		$d_annotation = $this->settings->d_annotation ? $this->settings->d_annotation : 'аннотация';
		$d_description = $this->settings->d_description ? $this->settings->d_description : 'описание';
		$d_images = $this->settings->d_images ? $this->settings->d_images : 'изображения';
	
		// Соответствие полей в базе и имён колонок в файле
		$columns_names = array(
			'name'=>             array('name', $d_name),
			'url'=>              array('url', 'адрес'),
			'visible'=>          array('visible', 'видим'),
			'featured'=>         array('featured', 'рекомендуемый'),
			'is_new'=>			 array('is_new', 'новинка'),
			'to_yandex'=>		 array('to_yandex', 'яндекс маркет'),
			'category'=>         array('category', $d_category),
			'brand'=>            array('brand', $d_brand),
			'variant'=>          array('variant', $d_variant),
			'variant1'=>         array('variant1', $d_variant1),
			'variant2'=>         array('variant2', $d_variant2),
			'rating'=>           array('rating', 'рейтинг'),
			'votes'=>            array('votes', 'голосов'),
			'views'=>            array('views', 'просмотров'),
			'price'=>            array('price', $d_price),
			'compare_price'=>    array('compare price', 'старая цена'),
			'sku'=>              array('sku', $d_sku),
			'stock'=>            array('stock', $d_stock),
			'unit'=>			 array('unit', $d_unit),
			'currency_id'=>		 array('currency_id', 'currency', $d_currency_id),
			'meta_title'=>       array('meta title', $d_meta_title),
			'meta_keywords'=>    array('meta keywords', 'ключевые слова'),
			'meta_description'=> array('meta description', $d_meta_description),
			'annotation'=>       array('annotation', $d_annotation),
			'description'=>      array('description', $d_description),
			'images'=>           array('images', $d_images),
			'typePrefix'=>       array('typePrefix')
		);
	
 		$name = trim($name);
 		$name = str_replace('/', '', $name);
 		$name = str_replace('\/', '', $name);
		foreach($columns_names as $i=>$names)
		{
			foreach($names as $n)
				if(!empty($name) && preg_match("/^".preg_quote($name)."$/ui", $n))
					return $i;
		}
		return false;				
	}
}

$import_ajax = new ImportAjax();
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		
		
$json = json_encode($import_ajax->import());
print $json;
