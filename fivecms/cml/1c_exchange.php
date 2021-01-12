<?php

// Папка для хранения временных файлов синхронизации
$dir = 'fivecms/cml/temp/';

// Обновлять все данные при каждой синхронизации
if($fivecms->settings->oneprodupdate != 1) {
	$full_update = true;
} else {
	$full_update = false;
}

// Название параметра товара, используемого как бренд
if($fivecms->settings->onebrand != 1){
	$brand_option_name = 'Производитель';
} else {
	$brand_option_name = 'Изготовитель';
}

$start_time = microtime(true);
$max_exec_time = min(30, @ini_get("max_execution_time"));
if(empty($max_exec_time))
	$max_exec_time = 30;

session_start();
chdir('../..');
include('api/Fivecms.php');
$fivecms = new Fivecms();

if($fivecms->request->get('type') == 'sale' && $fivecms->request->get('mode') == 'checkauth')
{
	print "success\n";
	print session_name()."\n";
	print session_id();
}

if($fivecms->request->get('type') == 'sale' && $fivecms->request->get('mode') == 'init')
{
	$tmp_files = glob($dir.'*.*');
	if(is_array($tmp_files))
	foreach($tmp_files as $v)
	{
    	//unlink($v);
    }
	print "zip=no\n";
	print "file_limit=1000000\n";
}

if($fivecms->request->get('type') == 'sale' && $fivecms->request->get('mode') == 'file')
{
	$filename = $fivecms->request->get('filename');
	
	$f = fopen($dir.$filename, 'ab');
	fwrite($f, file_get_contents('php://input'));
	fclose($f);

	$xml = simplexml_load_file($dir.$filename);	

	foreach($xml->Документ as $xml_order)
	{
		$order = new stdClass;

		$order->id = $xml_order->Номер;
		$existed_order = $fivecms->orders->get_order(intval($order->id));
		
		$order->date = $xml_order->Дата.' '.$xml_order->Время;
		$order->name = $xml_order->Контрагенты->Контрагент->Наименование;

		if(isset($xml_order->ЗначенияРеквизитов->ЗначениеРеквизита))
		foreach($xml_order->ЗначенияРеквизитов->ЗначениеРеквизита as $r)
		{
			switch ($r->Наименование) {
		    case 'Проведен':
		    	$proveden = ($r->Значение == 'true');
		        break;
		    case 'ПометкаУдаления':
		    	$udalen = ($r->Значение == 'true');
		        break;
			case 'Заказ оплачен':
                $order->paid = ($r->Значение == 'true');
            	break;
            }
		}
		
		if($udalen)
			$order->status = 3;
		elseif($proveden)
			$order->status = 1;
		elseif(!$proveden)
			$order->status = 0;
		
		if($existed_order)
		{
			$fivecms->orders->update_order($order->id, $order);
		}
		else
		{
			$order->id = $fivecms->orders->add_order($order);
		}
		
		$purchases_ids = array();
		// Товары
		foreach($xml_order->Товары->Товар as $xml_product)
		{
			$purchase = null;
			//  Id товара и варианта (если есть) по 1С
			$product_1c_id = $variant_1c_id = '';
			@list($product_1c_id, $variant_1c_id) = explode('#', $xml_product->Ид);
			if(empty($product_1c_id))
				$product_1c_id = '';
			if(empty($variant_1c_id))
				$variant_1c_id = '';
				
			// Ищем товар
			$fivecms->db->query('SELECT id FROM __products WHERE external_id=?', $product_1c_id);
			$product_id = $fivecms->db->result('id');
			$fivecms->db->query('SELECT id FROM __variants WHERE external_id=? AND product_id=?', $variant_1c_id, $product_id);
			$variant_id = $fivecms->db->result('id');
				
			$purchase = new stdClass;		
			$purchase->order_id = $order->id;
			$purchase->product_id = $product_id;
			$purchase->variant_id = $variant_id;
			
			$purchase->sku = $xml_product->Артикул;			
			$purchase->product_name = $xml_product->Наименование;
			$purchase->amount = $xml_product->Количество;
			$purchase->price = floatval($xml_product->ЦенаЗаЕдиницу);
			
			if(isset($xml_product->Скидки->Скидка))
			{
				$discount = $xml_product->Скидки->Скидка->Процент;
				$purchase->price = $purchase->price*(100-$discount)/100;
			}
			
			$fivecms->db->query('SELECT id FROM __purchases WHERE order_id=? AND product_id=? AND variant_id=?', $order->id, $product_id, $variant_id);
			$purchase_id = $fivecms->db->result('id');
			if(!empty($purchase_id))
				$purchase_id = $fivecms->orders->update_purchase($purchase_id, $purchase);
			else
				$purchase_id = $fivecms->orders->add_purchase($purchase);
			$purchases_ids[] = $purchase_id;
		}
		// Удалим покупки, которых нет в файле
		foreach($fivecms->orders->get_purchases(array('order_id'=>intval($order->id))) as $purchase)
		{
			if(!in_array($purchase->id, $purchases_ids))
				$fivecms->orders->delete_purchase($purchase->id);
		}
		
		$fivecms->db->query('UPDATE __orders SET discount=0, total_price=? WHERE id=? LIMIT 1', $xml_order->Сумма, $order->id);
		
	}
	
	print "success";
	$fivecms->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");

}

if($fivecms->request->get('type') == 'sale' && $fivecms->request->get('mode') == 'query')
{
		$no_spaces = '<?xml version="1.0" encoding="utf-8"?>
							<КоммерческаяИнформация ВерсияСхемы="2.04" ДатаФормирования="' . date ( 'Y-m-d' )  . '"></КоммерческаяИнформация>';
		$xml = new SimpleXMLElement ( $no_spaces );

		//$orders = $fivecms->orders->get_orders(array('modified_since'=>$fivecms->settings->last_1c_orders_export_date,'limit'=>10000));
		$filter = array('modified_since'=>$fivecms->settings->last_1c_orders_export_date);
		$filter['limit'] = $fivecms->orders->count_orders($filter);
		$orders = $fivecms->orders->get_orders($filter);
		
		$currency = $fivecms->money->get_currency();
		foreach($orders as $order)
		{
			$date = new DateTime($order->date);
			
			$doc = $xml->addChild ("Документ");
			$doc->addChild ( "Ид", $order->id);
			$doc->addChild ( "Номер", $order->id);
			$doc->addChild ( "Дата", $date->format('Y-m-d'));
			$doc->addChild ( "ХозОперация", "Заказ товара" );
			$doc->addChild ( "Роль", "Продавец" );
			$doc->addChild ( "Валюта", $currency->code);
			$doc->addChild ( "Курс", "1" );
			$doc->addChild ( "Сумма", $order->total_price);
			$doc->addChild ( "Время",  $date->format('H:i:s'));
			$doc->addChild ( "Комментарий", htmlspecialchars($order->comment));
			

			// Контрагенты
			$k1 = $doc->addChild ( 'Контрагенты' );
			$k1_1 = $k1->addChild ( 'Контрагент' );
			$k1_2 = $k1_1->addChild ( "Ид", htmlspecialchars($order->name) );
			$k1_2 = $k1_1->addChild ( "Наименование", htmlspecialchars($order->name) );
			$k1_2 = $k1_1->addChild ( "Роль", "Покупатель" );
			$k1_2 = $k1_1->addChild ( "ПолноеНаименование", htmlspecialchars($order->name) );
			
			
			// Доп параметры
			
			$adres = $k1_1->addChild ('Адрес');
			$adres->addChild ( 'Представление', htmlspecialchars($order->address) );
			
			$addr = $k1_1->addChild ('АдресРегистрации');
			$addr->addChild ( 'Представление', htmlspecialchars($order->address) );
			$addrField = $addr->addChild ( 'АдресноеПоле' );
			$addrField->addChild ( 'Тип', 'Страна' );
			$addrField->addChild ( 'Значение', 'RU' );
			$addrField = $addr->addChild ( 'АдресноеПоле' );
			$addrField->addChild ( 'Тип', 'Регион' );
			$addrField->addChild ( 'Значение', htmlspecialchars($order->address) );

			$contacts = $k1_1->addChild ( 'Контакты' );
			if($order->phone){
				$cont = $contacts->addChild ( 'Контакт' );
				if($fivecms->settings->onephone == 1) {
					$cont->addChild ( 'Тип', 'Телефон' );
				} else {
					$cont->addChild ( 'Тип', 'ТелефонРабочий' );
				}
				//$cont->addChild ( 'Значение', preg_replace('/[^0-9]/', '', $order->phone) );
				$cont->addChild ( 'Значение', htmlspecialchars($order->phone) );
			}
			if($order->email){
				$cont = $contacts->addChild ( 'Контакт' );
				$cont->addChild ( 'Тип', 'Почта' );
				$cont->addChild ( 'Значение', $order->email );
			}

			$purchases = $fivecms->orders->get_purchases(array('order_id'=>intval($order->id)));

			$t1 = $doc->addChild ( 'Товары' );
			foreach($purchases as $purchase)
			{
				if(!empty($purchase->product_id) && !empty($purchase->variant_id))
				{
					$fivecms->db->query('SELECT external_id FROM __products WHERE id=?', $purchase->product_id);
					$id_p = $fivecms->db->result('external_id');
					$fivecms->db->query('SELECT external_id FROM __variants WHERE id=?', $purchase->variant_id);
					$id_v = $fivecms->db->result('external_id');
					
					// Если нет внешнего ключа товара - указываем наш id
					if(!empty($id_p))
					{
						$id = $id_p;
					}
					else
					{
						$fivecms->db->query('UPDATE __products SET external_id=id WHERE id=?', $purchase->product_id);
						$id = $purchase->product_id;
					}
					
					// Если нет внешнего ключа варианта - указываем наш id
					if(!empty($id_v))
					{
						$id = $id.'#'.$id_v;
					}
					else
					{
						$fivecms->db->query('UPDATE __variants SET external_id=id WHERE id=?', $purchase->variant_id);
						$id = $id.'#'.$purchase->variant_id;
					}
						
					$t1_1 = $t1->addChild ( 'Товар' );
					
					if($id)
						$t1_2 = $t1_1->addChild ( "Ид", $id);
					
					$t1_2 = $t1_1->addChild ( "Артикул", $purchase->sku);
					
					$name = $purchase->product_name;
					if($purchase->variant_name)
						$name .= " $purchase->variant_name $id";
					$t1_2 = $t1_1->addChild ( "Наименование", htmlspecialchars($name));
					$t1_2 = $t1_1->addChild ( "ЦенаЗаЕдиницу", $purchase->price*(100-$order->discount)/100);
					$t1_2 = $t1_1->addChild ( "Количество", $purchase->amount );
					$t1_2 = $t1_1->addChild ( "Сумма", $purchase->amount*$purchase->price*(100-$order->discount)/100);
					
					if($fivecms->settings->oneskid == 1) {
					$t1_2 = $t1_1->addChild ( "Скидки" );
					$t1_3 = $t1_2->addChild ( "Скидка" );
					$t1_4 = $t1_3->addChild ( "Сумма", $purchase->amount*$purchase->price*(100-$order->discount)/100);
					$t1_4 = $t1_3->addChild ( "УчтеноВСумме", "true" );
					}
					
					if($fivecms->settings->onevid != 1) {
					$t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ВидНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Товар" );
					}
	
					$t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ТипНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Товар" );
				}
			}
			
			// Доставка
			if($order->delivery_price>0 && !$order->separate_delivery) {
				if($fivecms->settings->onedeliv != 1) {
					$t1 = $t1->addChild ( 'Товар' );
					$t1->addChild ( "Ид", 'ORDER_DELIVERY');
					$t1->addChild ( "Наименование", 'Доставка');
					$t1->addChild ( "ЦенаЗаЕдиницу", $order->delivery_price);
					$t1->addChild ( "Количество", 1 );
					$t1->addChild ( "Сумма", $order->delivery_price);
					$t1_2 = $t1->addChild ( "ЗначенияРеквизитов" );
					if($fivecms->settings->onevid != 1) {
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ВидНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Услуга" );
					}
					//$t1_2 = $t1->addChild ( "ЗначенияРеквизитов" );
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ТипНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Услуга" );
				} elseif($fivecms->settings->onedeliv == 1) {
					$t1_1 = $t1->addChild ( 'Товар' );
					$t1_2 = $t1_1->addChild ( "Ид", 'ORDER_DELIVERY');
					$t1_2 = $t1_1->addChild ( "Наименование", 'Доставка');
					$t1_2 = $t1_1->addChild ( "ЦенаЗаЕдиницу", $order->delivery_price);
					$t1_2 = $t1_1->addChild ( "Количество", 1 );
					$t1_2 = $t1_1->addChild ( "Сумма", $order->delivery_price);
				
					$t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
					if($fivecms->settings->onevid != 1) {
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ВидНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Услуга" );
					}
					//$t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ТипНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Услуга" );
				} else {
					$t1_1 = $t1->addChild ( 'Товар' );
					$t1_2 = $t1_1->addChild ( "Ид", 'ORDER_DELIVERY');
					$t1_2 = $t1_1->addChild ( "Артикул", 'delivery');
					$t1_2 = $t1_1->addChild ( "Наименование", 'Доставка');
					$t1_2 = $t1_1->addChild ( "ЦенаЗаЕдиницу", $order->delivery_price);
					$t1_2 = $t1_1->addChild ( "Количество", 1 );
					$t1_2 = $t1_1->addChild ( "Сумма", $order->delivery_price);
					$t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
					if($fivecms->settings->onevid != 1) {
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ВидНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Товар" );
					}
					//$t1_2 = $t1->addChild ( "ЗначенияРеквизитов" );
					$t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
					$t1_4 = $t1_3->addChild ( "Наименование", "ТипНоменклатуры" );
					$t1_4 = $t1_3->addChild ( "Значение", "Товар" );
				}
			}
			

			// Способ оплаты и доставки
			$s1_2 = $doc->addChild ( "ЗначенияРеквизитов");

			$payment_method = $fivecms->payment->get_payment_method($order->payment_method_id);
			$delivery = $fivecms->delivery->get_delivery($order->delivery_id);
			
			if($payment_method)
			{
				$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита");
				$s1_3->addChild ( "Наименование", "Метод оплаты" );
				$s1_3->addChild ( "Значение", htmlspecialchars($payment_method->name) );
			}
			if($delivery)
			{
				$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита");
				$s1_3->addChild ( "Наименование", "Способ доставки" );
				$s1_3->addChild ( "Значение", htmlspecialchars($delivery->name) );
			}
			$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита");
			$s1_3->addChild ( "Наименование", "Заказ оплачен" );
			$s1_3->addChild ( "Значение", $order->paid?'true':'false' );


			// Статус			
			if($order->status == 0)
			{
				$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
				$s1_3->addChild ( "Наименование", "Статус заказа" );
				$s1_3->addChild ( "Значение", "Новый" );
			}
			if($order->status == 1)
			{

				$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
				$s1_3->addChild ( "Наименование", "Статус заказа" );
				$s1_3->addChild ( "Значение", "[N] Принят" );
			}
			if($order->status == 2)
			{

				$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
				$s1_3->addChild ( "Наименование", "Статус заказа" );
				$s1_3->addChild ( "Значение", "[F] Доставлен" );
			}
			if($order->status == 3)
			{

				$s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
				$s1_3->addChild ( "Наименование", "Отменен" );
				$s1_3->addChild ( "Значение", "true" );

			}

		}

		header ( "Content-type: text/xml; charset=utf-8" );
		print "\xEF\xBB\xBF";

		print $xml->asXML ();

		$fivecms->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");


}

if($fivecms->request->get('type') == 'sale' && $fivecms->request->get('mode') == 'success')
{
		$fivecms->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");
		if($fivecms->settings->onesuccess == 1) {
			print "success\n";
		}
}


if($fivecms->request->get('type') == 'catalog' && $fivecms->request->get('mode') == 'checkauth')
{
	print "success\n";
	print session_name()."\n";
	print session_id();
}

if($fivecms->request->get('type') == 'catalog' && $fivecms->request->get('mode') == 'init')
{	
	$tmp_files = glob($dir.'*.*');
	if(is_array($tmp_files))
	foreach($tmp_files as $v)
	{
    	unlink($v);
    }
    unset($_SESSION['last_1c_imported_variant_num']);
    unset($_SESSION['last_1c_imported_product_num']);
    unset($_SESSION['features_mapping']);
    unset($_SESSION['categories_mapping']);
    unset($_SESSION['brand_id_option']);    
    if ($fivecms->settings->oneflushvar == 1) {
        flush_database();
    }
   	print "zip=no\n";
	print "file_limit=1000000\n";
}

if($fivecms->request->get('type') == 'catalog' && $fivecms->request->get('mode') == 'file')
{
	$filename = basename($fivecms->request->get('filename'));
	$f = fopen($dir.$filename, 'ab');
	fwrite($f, file_get_contents('php://input'));
	fclose($f);
	print "success\n";
} 
 
if($fivecms->request->get('type') == 'catalog' && $fivecms->request->get('mode') == 'import')
{
	$filename = basename($fivecms->request->get('filename'));

	if(stristr($filename, 'import') !== false)
	{
		// Категории и свойства (только в первом запросе пакетной передачи)
		if(!isset($_SESSION['last_1c_imported_product_num']))
		{
			$z = new XMLReader;
			$z->open($dir.$filename);		
			while ($z->read() && $z->name !== 'Классификатор');
			$xml = new SimpleXMLElement($z->readOuterXML());
			$z->close();
			import_categories($xml);
			import_features($xml);
		}
		
		// Товары 			
		$z = new XMLReader;
		$z->open($dir.$filename);
		
		while ($z->read() && $z->name !== 'Товар');
		
		// Последний товар, на котором остановились
		$last_product_num = 0;
		if(isset($_SESSION['last_1c_imported_product_num']))
			$last_product_num = $_SESSION['last_1c_imported_product_num'];
		
		// Номер текущего товара
		$current_product_num = 0;

		while($z->name === 'Товар')
		{
			if($current_product_num >= $last_product_num)
			{
				$xml = new SimpleXMLElement($z->readOuterXML());

				// Товары
				import_product($xml);
				
				$exec_time = microtime(true) - $start_time;
				if($exec_time+1>=$max_exec_time)
				{
					header ( "Content-type: text/xml; charset=utf-8" );
					print "\xEF\xBB\xBF";
					print "progress\r\n";
					print "Выгружено товаров: $current_product_num\r\n";
					$_SESSION['last_1c_imported_product_num'] = $current_product_num;
					exit();
				}
			}
			$z->next('Товар');
			$current_product_num ++;
		}
		$z->close();
		print "success";
		//unlink($dir.$filename);
		unset($_SESSION['last_1c_imported_product_num']);				
	}
	elseif(stristr($filename, 'offers') !== false)
	{
		// Варианты			
		$z = new XMLReader;
		$z->open($dir.$filename);
		
		while ($z->read() && $z->name !== 'Предложение');
		
		// Последний вариант, на котором остановились
		$last_variant_num = 0;
		if(isset($_SESSION['last_1c_imported_variant_num']))
			$last_variant_num = $_SESSION['last_1c_imported_variant_num'];
		
		// Номер текущего товара
		$current_variant_num = 0;

		while($z->name === 'Предложение')
		{
			if($current_variant_num >= $last_variant_num)
			{
				$xml = new SimpleXMLElement($z->readOuterXML());
				// Варианты
				import_variant($xml);
				
				$exec_time = microtime(true) - $start_time;
				if($exec_time+1>=$max_exec_time)
				{
					header ( "Content-type: text/xml; charset=utf-8" );
					print "\xEF\xBB\xBF";
					print "progress\r\n";
					print "Выгружено ценовых предложений: $current_variant_num\r\n";
					$_SESSION['last_1c_imported_variant_num'] = $current_variant_num;
					exit();
				}
			}
			$z->next('Предложение');
			$current_variant_num ++;
		}
		$z->close();
		print "success";
		//unlink($dir.$filename);
		unset($_SESSION['last_1c_imported_variant_num']);				

	}
}


function import_categories($xml, $parent_id = 0)
{
	global $fivecms;
	global $dir;
	if(isset($xml->Группы->Группа))
	foreach ($xml->Группы->Группа as $xml_group)
	{
		$fivecms->db->query('SELECT id FROM __categories WHERE external_id=?', $xml_group->Ид);
		$category_id = $fivecms->db->result('id');
		if(empty($category_id))
			$category_id = $fivecms->categories->add_category(array('parent_id'=>$parent_id, 'external_id'=>$xml_group->Ид, 'name'=>$xml_group->Наименование, 'meta_title'=>$xml_group->Наименование, 'meta_keywords'=>$xml_group->Наименование, 'meta_description'=>$xml_group->Наименование ));
		$_SESSION['categories_mapping'][strval($xml_group->Ид)] = $category_id;
		import_categories($xml_group, $category_id);
	}
}

function import_features($xml)
{
	global $fivecms;
	global $dir;
	global $brand_option_name;
	
	$property = array();
	if(isset($xml->Свойства->СвойствоНоменклатуры))
		$property = $xml->Свойства->СвойствоНоменклатуры;
		
	if(isset($xml->Свойства->Свойство))
		$property = $xml->Свойства->Свойство;
		
	foreach ($property as $xml_feature)
	{
		// Если свойство содержит производителя товаров
		if($xml_feature->Наименование == $brand_option_name)
		{
			// Запомним в сессии Ид свойства с производителем
			$_SESSION['brand_option_id'] = strval($xml_feature->Ид);		
		}
		// Иначе обрабатываем как обычной свойство товара
		else
		{
			$fivecms->db->query('SELECT id FROM __features WHERE name=?', strval($xml_feature->Наименование));
			$feature_id = $fivecms->db->result('id');
			if(empty($feature_id))
				$feature_id = $fivecms->features->add_feature(array('name'=>strval($xml_feature->Наименование)));
			$_SESSION['features_mapping'][strval($xml_feature->Ид)] = $feature_id;
			if($xml_feature->ТипЗначений == 'Справочник')
			{
				foreach($xml_feature->ВариантыЗначений->Справочник as $val)
				{
					$_SESSION['features_values'][strval($val->ИдЗначения)] = strval($val->Значение);
				}
			}
		}
	}
}

function import_product($xml_product)
{
	global $fivecms;
	global $dir;
	global $brand_option_name;
	global $full_update;
	// Товары

	//  Id товара и варианта (если есть) по 1С
	@list($product_1c_id, $variant_1c_id) = explode('#', $xml_product->Ид);
	if(empty($variant_1c_id)) {
		$variant_1c_id = '';
	}
	
	// Ид категории
	if(isset($xml_product->Группы->Ид)) {
		$category_id = $_SESSION['categories_mapping'][strval($xml_product->Группы->Ид)];
	}
	
	// Подготавливаем вариант
	$variant_id = null;
	$variant = new stdClass;
	$values = array();
	if(isset($xml_product->ХарактеристикиТовара->ХарактеристикаТовара)) {
		foreach($xml_product->ХарактеристикиТовара->ХарактеристикаТовара as $xml_property) {
			$values[] = $xml_property->Значение;
		}
	}	
	if(!empty($values)) {
		$variant->name = implode(', ', $values);
	}
		
	$variant->sku = (string)$xml_product->Артикул;
	$variant->external_id = $variant_1c_id;
	
	// Ищем товар
	$fivecms->db->query('SELECT id FROM __products WHERE external_id=?', $product_1c_id);
	$product_id = $fivecms->db->result('id');
	if(empty($product_id) && !empty($variant->sku))
	{
		$fivecms->db->query('SELECT product_id, id FROM __variants WHERE sku=?', $variant->sku);
		$res = $fivecms->db->result();
		if(!empty($res))
		{
			$product_id = $res->product_id;
			$variant_id = $res->id;
		}
	}
	
	// Если такого товара не нашлось		
	if(empty($product_id))
	{
		// Добавляем товар
		$description = '';
		if(!empty($xml_product->Описание)) {
			$description = $xml_product->Описание;
		}
			
		$product_id = $fivecms->products->add_product(array('external_id'=>$product_1c_id, 'name'=>$xml_product->Наименование, 'meta_title'=>$xml_product->Наименование, 'meta_keywords'=>$xml_product->Наименование, 'meta_description'=>$description,  'annotation'=>$description, 'body'=>$description));
		
		// Добавляем товар в категории
		if(isset($category_id)) {
			$fivecms->categories->add_product_category($product_id, $category_id);
		}

		// Добавляем изображение товара
		if($fivecms->settings->oneimages != 1) {
			if(isset($xml_product->Картинка)) {
				foreach($xml_product->Картинка as $img) {
					$image = basename($img);
					if(!empty($image) && is_file($dir.$image) && is_writable($fivecms->config->original_images_dir)) {
						rename($dir.$image, $fivecms->config->original_images_dir.$image);
						$fivecms->products->add_image($product_id, $image);
					}
				}
			}
		} else {
			if(isset($xml_product->Картинка)) {
				foreach($xml_product->Картинка as $img) {
					$image = basename($img);
					if(!empty($image)) {
						$fivecms->products->add_image($product_id, $image);
					}
				}
			}
		}

		// Обновляем бренд
		if(isset($xml_product->Изготовитель))
		{
			$brand_name = strval($xml_product->Изготовитель->Наименование);
			// Найдем его по имени
			$fivecms->db->query('SELECT id FROM __brands WHERE name=?', $brand_name);
			if(!$brand_id = $fivecms->db->result('id')) {
				// Создадим, если не найден
				$brand_id = $fivecms->brands->add_brand(array('name'=>$brand_name, 'meta_title'=>$brand_name, 'meta_keywords'=>$brand_name, 'meta_description'=>$brand_name));	
			}
			if(!empty($brand_id))
				$fivecms->products->update_product($product_id, array('brand_id'=>$brand_id));
		}

	}
	//Если нашелся товар
	else
	{
		if(empty($variant_id) && !empty($variant_1c_id))
		{
			$fivecms->db->query('SELECT id FROM __variants WHERE external_id=? AND product_id=?', $variant_1c_id, $product_id);
			$variant_id = $fivecms->db->result('id');
		}
		elseif(empty($variant_id) && empty($variant_1c_id))
		{
			$fivecms->db->query('SELECT id FROM __variants WHERE product_id=?', $product_id);
			$variant_id = $fivecms->db->result('id');		
		}
		
		// Обновляем товар
		if($full_update)
		{
			$p = new stdClass();
			if(!empty($xml_product->Описание))
			{
				$description = strval($xml_product->Описание);
				$p->meta_description = strip_tags($description);
				$p->annotation = $description;
				$p->body = $description;
			}
			$p->external_id = $product_1c_id;
			//$p->url = translit($xml_product->Наименование);
			$p->name = $xml_product->Наименование;
			$p->meta_title = $xml_product->Наименование;
			$p->meta_keywords = $xml_product->Наименование;

			$product_id = $fivecms->products->update_product($product_id, $p);
			
			// Обновляем категорию товара
			if(isset($category_id) && !empty($product_id))
			{
   	    		$query = $fivecms->db->placehold('DELETE FROM __products_categories WHERE product_id=?', $product_id);
   	    		$fivecms->db->query($query);
				$fivecms->categories->add_product_category($product_id, $category_id);
			}
			
		}
		
		// Обновляем изображение товара
		if($fivecms->settings->oneimages != 1) {
			if(isset($xml_product->Картинка)) {
				$fivecms->db->query('SELECT id FROM __images WHERE product_id=? ORDER BY position', $product_id);
				$img_ids = $fivecms->db->results('id');
				foreach ($img_ids as $img_id) 
				{
					if(!empty($img_id))
						$fivecms->products->delete_image($img_id);
				}
				foreach($xml_product->Картинка as $img) {
					$image = basename($img);
					if(!empty($image) && is_file($dir.$image) && is_writable($fivecms->config->original_images_dir)) {
						rename($dir.$image, $fivecms->config->original_images_dir.$image);
						$fivecms->products->add_image($product_id, $image);
					}
				}
			}
		} else {
			if(isset($xml_product->Картинка)) {
				foreach($xml_product->Картинка as $img) {
					$image = basename($img);
					if(!empty($image)) {
						$fivecms->db->query('SELECT id FROM __images WHERE product_id=? ORDER BY position LIMIT 1', $product_id);
						$img_id = $fivecms->db->result('id');
						if(!empty($img_id)) $fivecms->products->delete_image($img_id);
						$fivecms->products->add_image($product_id, $image);
					}
				}
			}
		}
		
		// Обновляем бренд
		if(isset($xml_product->Изготовитель))
		{
			$brand_name = strval($xml_product->Изготовитель->Наименование);
			// Найдем его по имени
			$fivecms->db->query('SELECT id FROM __brands WHERE name=?', $brand_name);
			if(!$brand_id = $fivecms->db->result('id')) {
				// Создадим, если не найден
				$brand_id = $fivecms->brands->add_brand(array('name'=>$brand_name, 'meta_title'=>$brand_name, 'meta_keywords'=>$brand_name, 'meta_description'=>$brand_name));	
			}
			if(!empty($brand_id))
				$fivecms->products->update_product($product_id, array('brand_id'=>$brand_id));
		}

	}
	
	if($fivecms->settings->onevariants == 1) {
		// Если не найден вариант, добавляем вариант один к товару
		if(empty($variant_id))
		{
			$variant->product_id = $product_id;
			$variant->stock = 0;
			if( $fivecms->settings->oneunits == 1 && !empty($xml_product->БазоваяЕдиница) )
				$variant->unit = $xml_product->БазоваяЕдиница;
			$variant_id = $fivecms->variants->add_variant($variant);
			$fivecms->variants->update_variant($variant_id, array('position'=>$variant_id));
		}
		elseif(!empty($variant_id))
		{
			$fivecms->variants->update_variant($variant_id, $variant);
		}
	} else {
		if(!empty($variant_id))
		{
			$fivecms->variants->update_variant($variant_id, $variant);
		}
	}
	
	// Свойства товара
	if(isset($xml_product->ЗначенияСвойств->ЗначенияСвойства))
	{
		foreach ($xml_product->ЗначенияСвойств->ЗначенияСвойства as $xml_option)
		{
			if(isset($_SESSION['features_mapping'][strval($xml_option->Ид)]))
			{
				$feature_id = $_SESSION['features_mapping'][strval($xml_option->Ид)];
				if(isset($category_id) && !empty($feature_id))
				{
					$fivecms->features->add_feature_category($feature_id, $category_id);

					$query = $fivecms->db->placehold("DELETE FROM __options WHERE feature_id=? AND product_id=?", intval($feature_id), intval($product_id));
					$fivecms->db->query($query);

					$values = array();
					foreach($xml_option->Значение as $xml_value)
					{
						if(isset($_SESSION['features_values'][strval($xml_value)]))
							$values[] = strval($_SESSION['features_values'][strval($xml_value)]);
						else
							$values[] = strval($xml_value);
					}
					$fivecms->features->update_option($product_id, $feature_id, implode(' ,', $values));
				}
			}
			// Если свойство оказалось названием бренда
			elseif(isset($_SESSION['brand_option_id']) && !empty($xml_option->Значение))
			{
				$brand_name = strval($xml_option->Значение);
				// Добавим бренд
				// Найдем его по имени
				$fivecms->db->query('SELECT id FROM __brands WHERE name=?', $brand_name);
				if(!$brand_id = $fivecms->db->result('id')) 
					// Создадим, если не найден
					$brand_id = $fivecms->brands->add_brand(array('name'=>$brand_name, 'meta_title'=>$brand_name, 'meta_keywords'=>$brand_name, 'meta_description'=>$brand_name));	
				if(!empty($brand_id))
					$fivecms->products->update_product($product_id, array('brand_id'=>$brand_id));
			}
		}		
	}
	
	
	// Если нужно - удаляем вариант или весь товар
	if($xml_product->Статус == 'Удален')
	{
		$fivecms->variants->delete_variant($variant_id);
		$fivecms->db->query('SELECT count(id) as variants_num FROM __variants WHERE product_id=?', $product_id);
		if($fivecms->db->result('variants_num') == 0)
			$fivecms->products->delete_product($product_id);

	}
}

function import_variant($xml_variant)
{
	global $fivecms;
	global $dir;
	$variant = new stdClass;
	//  Id товара и варианта (если есть) по 1С
	@list($product_1c_id, $variant_1c_id) = explode('#', $xml_variant->Ид);
	if(empty($variant_1c_id))
		$variant_1c_id = '';
	if(empty($product_1c_id))
		return false;

	$fivecms->db->query('SELECT v.id FROM __variants v WHERE v.external_id=? AND product_id=(SELECT p.id FROM __products p WHERE p.external_id=? LIMIT 1)', $variant_1c_id, $product_1c_id);
	$variant_id = $fivecms->db->result('id');
	
	$fivecms->db->query('SELECT p.id FROM __products p WHERE p.external_id=?', $product_1c_id);
	$variant->external_id = $variant_1c_id;
	$variant->product_id = $fivecms->db->result('id');
	if(empty($variant->product_id))
		return false;

	if(isset($xml_variant->Цены->Цена->ЦенаЗаЕдиницу)) 
		$variant->price = $xml_variant->Цены->Цена->ЦенаЗаЕдиницу;	
	
	if(isset($xml_variant->ХарактеристикиТовара->ХарактеристикаТовара))
	foreach($xml_variant->ХарактеристикиТовара->ХарактеристикаТовара as $xml_property) {
		$values[] = $xml_property->Значение;
		if($fivecms->settings->onesizecol == 1){
			if(mb_strtolower($xml_property->Наименование) == 'размер')
				$size = $xml_property->Значение;
			if(mb_strtolower($xml_property->Наименование) == 'цвет')
				$color = $xml_property->Значение;
		}	
	}
	
	if(!empty($values))
		$variant->name = implode(', ', $values);
	if($fivecms->settings->onesizecol == 1){
		if(!empty($size))
			$variant->name1 = $size;
		if(!empty($color))
			$variant->name2 = $color;
	}
	
	$sku = (string)$xml_variant->Артикул;
	if(!empty($sku))
		$variant->sku = $sku;
	
	$variant_currency = new \stdClass;
	// Конвертируем цену из валюты 1С в базовую валюту магазина
	if(!empty($xml_variant->Цены->Цена->Валюта))
	{
		// Ищем валюту по коду
		$fivecms->db->query("SELECT id, rate_from, rate_to FROM __currencies WHERE code like ?", $xml_variant->Цены->Цена->Валюта);
		$variant_currency = $fivecms->db->result();
		// Если не нашли - ищем по обозначению
		if(empty($variant_currency))
		{
			$fivecms->db->query("SELECT id, rate_from, rate_to FROM __currencies WHERE sign like ?", $xml_variant->Цены->Цена->Валюта);
			$variant_currency = $fivecms->db->result();
		}
		// Если нашли валюту - конвертируем из нее в базовую
		if( $fivecms->settings->onecurrency == 1 ){
			if($variant_currency && $variant_currency->rate_from>0 && $variant_currency->rate_to>0)
			{
				$variant->price = floatval($variant->price)*$variant_currency->rate_to/$variant_currency->rate_from;
			}	
		}
	}
	
	if(isset($xml_variant->Количество))
		$variant->stock = (int)$xml_variant->Количество;
	else
		$variant->stock = NULL;	
	
	// Устанавливаем единицу измерения
	if( $fivecms->settings->oneunits == 1 && !empty($xml_variant->БазоваяЕдиница))
    	$variant->unit = (string)$xml_variant->Цены->Цена->Единица;
    if($fivecms->settings->oneunits == 1 && !$variant->unit = (string)$xml_variant->БазоваяЕдиница){
            $variant->unit = (string)$xml_variant->Цены->Цена->Единица;
    }	

	if(empty($variant_id)) {
		//$fivecms->variants->add_variant($variant);
		$variant_id = $fivecms->variants->add_variant($variant);
		$fivecms->variants->update_variant($variant_id, array('position'=>$variant_id));
	} else {	
		$fivecms->variants->update_variant($variant_id, $variant);
	}
}

function translit($text)
{
	$ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я"); 
	$en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");

 	$res = str_replace($ru, $en, $text);
	$res = preg_replace("/[\s]+/ui", '-', $res);
	$res = strtolower(preg_replace("/[^0-9a-zа-я\-]+/ui", '', $res));
 	
    return $res;  
}

function flush_database() {
    global $fivecms;
    // Очищаем варианты товаров
    $fivecms->db->query('TRUNCATE TABLE __variants');
}

	