<?php
session_start();
require_once('../../api/Fivecms.php');

class ImportSubscribersAjax extends Fivecms
{	
	// Соответствие полей в базе и имён колонок в файле
	private $columns_names = array(
			'name'=>             array('name'),
			'email'=>              array('email')
			);
	
	// Соответствие имени колонки и поля в базе
	private $internal_columns_names = array();

	private $import_files_dir      = '../files/import/'; // Временная папка		
	private $import_file           = 'importsub.csv';           // Временный файл
	private $column_delimiter      = ';';
	private $products_count        = 10;
	private $columns               = array();

	public function import()
	{
		if(!$this->managers->access('mailuser'))
			return false;

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

		// Если нет имени и email - не будем импортировать
		if(!in_array('name', $this->columns) && !in_array('email', $this->columns))
			return false;
	 	
		// Переходим на заданную позицию, если импортируем не сначала
		if($from = $this->request->get('from'))
			fseek($f, $from);
		
		// Массив импортированных объектов
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

		fclose($f);
		$size = filesize($this->import_files_dir.$this->import_file);
		
		// Создаем объект результата
		$result->from = $from;          // На каком месте остановились
		$result->totalsize = $size;     // Размер всего файла
		$result->items = $imported_items;   // Импортированные объекты
	
		return $result;
	}
	
	// Импорт одного объекта $item[column_name] = value;
	private function import_item($item)
	{
		$imported_item = new stdClass;

		// Проверим не пустое ли название и артинкул (должно быть хоть что-то из них)
		if(empty($item['name']) && empty($item['email']))
			return false;

		// Подготовим для добавления в базу
		$product = array();

		if(!empty($item['name'])) {
			$product['name'] = trim($item['name']);
		} else {
			$product['name'] = "";
		}

		if(!empty($item['email'])) 
			$product['email'] = trim($item['email']);

		// Если на прошлом шаге подписчик не нашелся, и задано хотя бы email
		if(!empty($product['email']))
		{
			$this->db->query('SELECT id FROM __maillist WHERE email=? LIMIT 1', $product['email']);				
			
			$r =  $this->db->result();
			if($r)
			{
				$id = $r->id;
			}
			// Если подписчик не найден - добавляем,
			if(empty($id))
			{
				$id = $this->mailer->add_mail($product['name'], $product['email']);
	  			$this->mailer->get_mail(intval($id));	
				$imported_item->status = 'added';
			}
		}

	}
	
	// Фозвращает внутреннее название колонки по названию колонки в файле
	private function internal_column_name($name)
	{
 		$name = trim($name);
 		$name = str_replace('/', '', $name);
 		$name = str_replace('\/', '', $name);
		foreach($this->columns_names as $i=>$names)
		{
			foreach($names as $n)
				if(!empty($name) && preg_match("/^".preg_quote($name)."$/ui", $n))
					return $i;
		}
		return false;				
	}
}

$import_subscribers_ajax = new ImportSubscribersAjax();
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		
		
$json = json_encode($import_subscribers_ajax->import());
print $json;