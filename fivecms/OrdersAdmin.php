<?PHP

use YooKassa\Client;
use YooKassa\Model\PaymentStatus;
use YooMoneyModule\YooMoneyLogger;

require_once('api/Fivecms.php');

class OrdersAdmin extends Fivecms
{
	public function fetch()
	{
	 	$filter = array();
	  	$filter['page'] = max(1, $this->request->get('page', 'integer'));
	  	// Заказов на странице	
	  	$filter['limit'] = 20;
	  	
	    // Поиск
	  	$keyword = $this->request->get('keyword');
	  	if(!empty($keyword))
	  	{
		  	$filter['keyword'] = $keyword;
	 		$this->design->assign('keyword', $keyword);
		}

		// Фильтр по дате заказа
		$get_filter = $this->request->get('filter');

		if(!empty($get_filter['date_from'])){
			$date_from = $get_filter['date_from'];
			$filter['date_from'] = date("Y-m-d 00:00:01",strtotime($get_filter['date_from']));
			$this->design->assign('date_from', $date_from);
		}	
		if(!empty($get_filter['date_to'])){
			$date_to = $get_filter['date_to'];
			$filter['date_to'] = date("Y-m-d 23:59:00",strtotime($get_filter['date_to']));
			$this->design->assign('date_to', $date_to);	
		}	
		
		// Фильтр по дате доставки
		$get_filter_two = $this->request->get('filter_two');
		if(!empty($get_filter_two['date_from'])){
			$date_from_two = $get_filter_two['date_from'];
			$filter['date_from_ship'] = date("Y-m-d 00:00:01",strtotime($get_filter_two['date_from']));
			$this->design->assign('date_from_two', $date_from_two);
		}	
		if(!empty($get_filter_two['date_to'])){
			$date_from_two = $get_filter_two['date_to'];
			$filter['date_to_ship'] = date("Y-m-d 23:59:00",strtotime($get_filter_two['date_to']));
			$this->design->assign('date_to_two', $date_to_two);	
		}
		// Фильтр по метке
		if(!empty($label_id = $this->request->get('label_id'))){
        	$filter['label'] = $label_id;
        	$this->design->assign('label_id', $label_id);
        }

		// Обработка действий
		if($this->request->method('post'))
		{

			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
                case 'journal':
                {
                    $this->create_journal($ids);
                    break;
                }
                case 'delete':
				{
					foreach($ids as $id)
					{
						$o = $this->orders->get_order(intval($id));
						if($o->status<3)
						{
							$this->orders->update_order($id, array('status'=>3));
							$this->orders->open($id);							
						}
						elseif($o->status>3)
						{
							$this->orders->update_order($id, array('status'=>3));
							$this->orders->open($id);							
						}
						else
							$this->orders->delete_order($id);
					}
					break;
				}

				case 'set_status_0':
				{
					foreach($ids as $id)
					{
						if($this->orders->open(intval($id)))
							$this->orders->update_order($id, array('status'=>0));	
					}
					break;
				}
				case 'set_status_4':
				{
					foreach($ids as $id)
					{
						if($this->orders->open(intval($id)))
							$this->orders->update_order($id, array('status'=>4));	
					}
					break;
				}
				case 'set_status_1':
				{
					foreach($ids as $id)
					{
						if(!$this->orders->close(intval($id)))
							$this->design->assign('message_error', 'error_closing');
						else
							$this->orders->update_order($id, array('status'=>1));	
					}
					break;
				}
				case 'set_status_2':
				{
					foreach($ids as $id)
					{
						if(!$this->orders->close(intval($id)))
							$this->design->assign('message_error', 'error_closing');
						else
							$this->orders->update_order($id, array('status'=>2));	
					}
					break;
				}

				case(preg_match('/^set_label_([0-9]+)/', $this->request->post('action'), $a) ? true : false):
				{
					$l_id = intval($a[1]);
					if($l_id>0)
					foreach($ids as $id)
					{
						$this->orders->add_order_labels($id, $l_id);
					}
					break;
				}
				case(preg_match('/^unset_label_([0-9]+)/', $this->request->post('action'), $a) ? true : false):
				{
					$l_id = intval($a[1]);
					if($l_id>0)
					foreach($ids as $id)
					{
						$this->orders->delete_order_labels($id, $l_id);
					}
					break;
				}

				case 'merge':
				{
					sort($ids); //сортируем массив отчекбошеных заказов по возрастанию, что бы первым был "первый" (более ранний) заказ
					$count_ids=0; //счетчик на нуль, начинаем отчет
					foreach($ids as $id) //перебираем сортированный массив заказов
					{
						if ($count_ids==0) //тут у нас должен быть первый заказ, который станет основным...
						{
							$main_id = $id; // ... берем его айди, этот заказ будет главным!
						}
						else
						{    //далее идут следующие заказы, получаем товары присоединяемого заказа
							$purchases = $this->orders->get_purchases(array('order_id'=>$id));
							foreach($purchases as $purchase) // разбираем их
							{    // ищем такой же товар в главном (основном) заказе, куда объединяются другие
								$query = $this->db->placehold("SELECT * FROM __purchases WHERE order_id=$main_id and product_id=".$purchase->product_id." and variant_id=".$purchase->variant_id." LIMIT 1");
								$this->db->query($query);
								$main_purchases = $this->db->result();    
								if(!empty($main_purchases))
								{    // если в главном заказе товар найден, то апдейтим у него кол-во на ту величину, что у присоединяемого заказа
									$update_purchase = $this->db->placehold("UPDATE __purchases SET amount=amount+".$purchase->amount." WHERE order_id=$main_id and product_id=".$purchase->product_id." and variant_id=".$purchase->variant_id."");
									$this->db->query($update_purchase);        
									// после удаляем этот товар из присоединяемого заказа
									$delete_purchase = $this->db->placehold("DELETE FROM __purchases WHERE order_id=$id and product_id=".$purchase->product_id." and variant_id=".$purchase->variant_id." LIMIT 1");
									$this->db->query($delete_purchase);                                    
								}
								else
								{    // если в главном заказе не было товара из присоединяемого заказа, то мы товар переносим, сменив ему ID-заказа
									$move_purchase = $this->db->placehold("UPDATE __purchases SET order_id=$main_id WHERE order_id=$id and product_id=".$purchase->product_id." and variant_id=".$purchase->variant_id."");
									$this->db->query($move_purchase);
								}
							}
							$this->orders->delete_order($id); //после чего, удаляем присоединяемый заказ
						}

						$count_ids++; //увеличиваем счетчик
					}
					//после всех переносов товаров в основной заказ, нужно проапдейтить итоговую стоимость заказа
					$upd_order_price = $this->db->placehold("UPDATE __orders o SET o.total_price=IFNULL((SELECT SUM(p.price*p.amount)*(100-o.discount)/100 FROM __purchases p WHERE p.order_id=o.id), 0)+o.delivery_price*(1-o.separate_delivery)-o.coupon_discount, modified=NOW() WHERE o.id=$main_id LIMIT 1");
					$this->db->query($upd_order_price);                    
					break;
				}

			}
		}		

		if(empty($keyword))
		{
			$status = $this->request->get('status', 'integer');
			$filter['status'] = $status;
		 	$this->design->assign('status', $status);
		}
				  	
	  	$orders_count = $this->orders->count_orders($filter);
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$filter['limit'] = $orders_count;	

		// Отображение
		$orders = array();
		$check_payment_method = null;
		foreach($this->orders->get_orders($filter) as $o) {
            $orders[$o->id] = $o;
            if (!$check_payment_method && !$o->paid && $o->payment_details) {
                $payment_method = $this->payment->get_payment_method($o->payment_method_id);
                if ($payment_method && $payment_method->module == 'YooMoneyApi') {
                    $check_payment_method = $o->payment_method_id;
                }
            }
        }

		// Запров ордеров со статусом WAITING_FOR_CAPTURE
		if ($check_payment_method) {
            require_once 'payment/YooMoneyApi/autoload.php';
            $settings = $this->payment->get_payment_settings($check_payment_method);
            $apiClient = new Client();
            $apiClient->setAuth($settings['yoomoney_shopid'], $settings['yoomoney_password']);
            $apiClient->setLogger(new YooMoneyLogger($settings['yookassa_debug']));
            try {
                $payments = $apiClient->getPayments(['status' => PaymentStatus::WAITING_FOR_CAPTURE]);
            } catch (Exception $e) {
                $payments = null;
            }
            if ($payments) {
                foreach ($payments->getItems() as $payment) {
                    $order_id = (int)$payment->getMetadata()->toArray()['order_id'] ?? 0;
                    if (isset($orders[$order_id])) {
                        $orders[$order_id]->waiting_for_capture = true;
                    }
                }
            }
        }
        
		// Метки заказов
		$orders_labels = array();
	  	foreach($this->orders->get_order_labels(array_keys($orders)) as $ol)
	  		$orders[$ol->order_id]->labels[] = $ol;
	  	
		foreach ($orders as $order)
		{
			$order->purchases = $this->orders->get_purchases(array('order_id'=>$order->id));
			$order->delivery = $this->delivery->get_delivery($order->delivery_id);
		}

		$deliveries = $this->delivery->get_deliveries();
		$this->design->assign('deliveries', $deliveries);	

	 	$this->design->assign('pages_count', ceil($orders_count/$filter['limit']));
	 	$this->design->assign('current_page', $filter['page']);
	  	
	 	$this->design->assign('orders_count', $orders_count);
	
	 	$this->design->assign('orders', $orders);
	
		// Метки заказов
	  	$labels = $this->orders->get_labels();
	 	$this->design->assign('labels', $labels);
	  	
		return $this->design->fetch('orders.tpl');
	}

    private function create_journal($ids)
    {
        /*
        $test_dates = $this->orders->count_orders_other_date($ids);
        if ($test_dates != 1) {
            $this->design->assign('action_error', 'Выбранные заказы не имеют дату доставки или она не одинаковая');
            break;
        }
        */

        /** Include PHPExcel */
        require_once 'classes/PHPExcel.php';
        $objReader = PHPExcel_IOFactory::createReader('Excel5');
        $objPHPExcel = $objReader->load("fivecms/design/xls/journal.xls");

        $style_border = array(
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ),
            'font' => array(
                'size' => 10
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_TOP,
                'wrap' => true
            )
        );
        $style_FG = array(
            'font' => array(
                'bold' => true
            ),
            'alignment' => array(
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );

        // Получаем перечень заказов
        $exl_orders = $this->orders->get_orders(array('id' => $ids, 'limit' => count($ids) + 1));

        //Номер строки в шаблоне, от которой будем плясать
        $baseRow = 5;
        $k = 0;

        $objPHPExcel->getActiveSheet()->getStyle('A' . ($baseRow - 1) . ':E' . ($baseRow + count($ids)))->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_TEXT);

        // Перебираем наши заказы
        foreach ($exl_orders as $o) {
            $row = $baseRow + $k;
            //$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1);
            $objPHPExcel->getActiveSheet()->setCellValue('A' . $row, $o->id)
                ->setCellValue('B' . $row, $o->address)
                ->setCellValue('C' . $row, $o->name . "\n" . $o->phone)
                ->setCellValue('E' . $row, $o->comment)
                ->setCellValue('F' . $row, ($o->paid ? 'Оплачено' : $o->total_price))
                ->setCellValue('G' . $row, $o->delivery_price);
            $objPHPExcel->getActiveSheet()->getRowDimension($row)->setRowHeight(-1);

            $order_sostav = $this->orders->get_purchases(array('order_id' => $o->id));
            $zakaz = array();
            foreach ($order_sostav as $sostav) {
                $zakaz[] = $sostav->product_name . ' ' . $sostav->variant_name . ($sostav->sku ? ' (' . $sostav->sku . ') ' : ' ') . $sostav->amount . ' ' . $this->settings->units;
            }
            $objPHPExcel->getActiveSheet()->setCellValue('D' . $row, implode(",\n", $zakaz));
            $k++;
        }
        $objPHPExcel->getActiveSheet()->removeRow($baseRow - 1, 1);

        $objPHPExcel->getActiveSheet()->getStyle('A' . ($baseRow - 1) . ':G' . ($row - 1))->applyFromArray($style_border);
        $objPHPExcel->getActiveSheet()->getStyle('F' . ($baseRow - 1) . ':G' . ($row - 1))->applyFromArray($style_FG);

        // Получаем дату из текстового значения
        $delivery_date = date('d-m-Y');
        // Получаем полную дату для вставки в Ecxel
        $excel_full_date = PHPExcel_Shared_Date::PHPToExcel(gmmktime(0, 0, 0, date('m'), date('d'), date('Y')));
        $objPHPExcel->getActiveSheet()->setCellValue('B1', $excel_full_date);

        $objPHPExcel->getActiveSheet()->setTitle('Журнал на ' . $delivery_date);

        // Redirect output to a client’s web browser (Excel5)
        header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="Journal_' . $delivery_date . '.xls"');
        header('Cache-Control: max-age=0');
        // If you're serving to IE 9, then the following may be needed
        header('Cache-Control: max-age=1');

        // If you're serving to IE over SSL, then the following may be needed
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
        header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT'); // always modified
        header('Cache-Control: cache, must-revalidate'); // HTTP/1.1
        header('Pragma: public'); // HTTP/1.0


        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
        $objWriter->save('php://output');
    }
}
