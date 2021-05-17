<?php

require_once('../../api/Fivecms.php');

class ExportOrdersAjax extends Fivecms
{	
	private $columns_names = array(
			'id'=>             	 'id',
			'delivery_price'=>   'Стоимость доставки',
			'paid'=>             'Оплачен',
			'date'=>             'Дата заказа',
			'name'=>       		 'Имя',
			'address'=>       	 'Адрес',
			'phone'=>       	 'Телефон',
			'email'=>            'Email',
			'url'=>         	 'Ссылка',
			'discount'=>         'Скидка',
			'coupon_discount'=>  'Скидка по купону',
			'total_price'=>      'Сумма заказа',
			'status'=>           'Статус заказа',
			'user_id'=>          'ID-пользователя',
			'referer'=>          'Реферер',
			'yclid'=>            'yclid',
			'note'=>       		 'Примечание админа',
			'comment'=>          'Комментарий покупателя'
			);
			
	private $column_delimiter = ';';
	private $orders_count = 10;
	private $export_files_dir = '../files/export_orders/';
	private $filename = 'orders.csv';

	public function fetch()
	{
		if(!$this->managers->access('orders'))
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
				
		// Если начали сначала - добавим в первую строку названия колонок
		if($page == 1)
		{
			fputcsv($f, $this->columns_names, $this->column_delimiter);
		}
		
		$filter = array();
		$filter['page'] = $page;
		$filter['limit'] = $this->orders_count;
		
		$status = $this->request->get('status');
		if($status != "all")
			$filter['status'] = intval($status);
			
		if(!empty($this->request->get('date_from'))){
			$date_from = $this->request->get('date_from');
			$filter['date_from'] = date("Y-m-d 00:00:01",strtotime($date_from));
		}	
		if(!empty($this->request->get('date_to'))){
			$date_to = $this->request->get('date_to');
			$filter['date_to'] = date("Y-m-d 23:59:00",strtotime($date_to));
		}		
			
		// Выбираем заказы
		$orders = array();
 		foreach($this->orders->get_orders($filter) as $u)
 		{
 			$str = array();
 			foreach($this->columns_names as $n=>$c){
 				$str[] = $u->$n;
 			}
 				
 			fputcsv($f, $str, $this->column_delimiter);
 		}
 		
		$total_orders = $this->orders->count_orders($filter);
		
		fclose($f);
		
		if($this->orders_count*$page < $total_orders)
			return array('end'=>false, 'page'=>$page, 'totalpages'=>$total_orders/$this->orders_count);
		else
			return array('end'=>true, 'page'=>$page, 'totalpages'=>$total_orders/$this->orders_count);		

		//fclose($f);

	}
	
}

$export_ajax = new ExportOrdersAjax();
$json = json_encode($export_ajax->fetch());
header("Content-type: application/json; charset=utf-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		
print $json;