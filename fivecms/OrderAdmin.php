<?PHP

require_once('api/Fivecms.php');

class OrderAdmin extends Fivecms
{
	public function fetch()
	{
		$order = new stdClass;
		if($this->request->method('post'))
		{
			$order->id = $this->request->post('id', 'integer');
			$order->name = $this->request->post('name');
			$order->email = $this->request->post('email');
			$order->phone = $this->request->post('phone');
            $order->phone_delivery = $this->request->post('phone_delivery');
			$order->address = $this->request->post('address');
			if(!empty($this->request->post('shipping_date'))) 
				$order->shipping_date = date('Y-m-d H:i', strtotime($this->request->post('shipping_date')));
            if(!empty($this->request->post('delivery_date')))
                $order->delivery_date = date('Y-m-d H:i', strtotime($this->request->post('delivery_date')));
			if($this->request->post('calc')) $order->calc = $this->request->post('calc');
			$order->comment = $this->request->post('comment');
			$order->note = $this->request->post('note');
			$order->track = $this->request->post('track');
			$order->discount2 = $this->request->post('discount2', 'float');
			$order->discount_group = $this->request->post('discount_group', 'float');
			$order->discount = $this->request->post('discount', 'float');
			$order->bonus_discount = $this->request->post('bonus_discount', 'float');
			$order->coupon_discount = $this->request->post('coupon_discount', 'float');
			$order->delivery_id = $this->request->post('delivery_id', 'integer');
			$order->delivery_price = $this->request->post('delivery_price', 'float');
			$order->payment_method_id = $this->request->post('payment_method_id', 'integer');
			$order->paid = $this->request->post('paid', 'integer');
			$order->user_id = $this->request->post('user_id', 'integer');
			$order->separate_delivery = $this->request->post('separate_delivery', 'integer');
			$order->source = $this->request->post('source', 'integer');
				 
	 		if(!$order_labels = $this->request->post('order_labels'))
	 			$order_labels = array();			

			if(empty($order->id))
			{
  				$order->id = $this->orders->add_order($order);
				$this->design->assign('message_success', 'added');
  			}
    		else
    		{
    			if($order->paid == 1) {
					$this->orders->set_pay($order->id);
				} elseif($order->paid == 0){
					$this->orders->unset_pay($order->id);
				}
    			$this->orders->update_order($order->id, $order);
				$this->design->assign('message_success', 'updated');
    		}	

	    	$this->orders->update_order_labels($order->id, $order_labels);
			
			if($order->id)
			{
				// Покупки
				$purchases = array();
				if($this->request->post('purchases'))
				{
					foreach($this->request->post('purchases') as $n=>$va) foreach($va as $i=>$v)
						{
						if(empty($purchases[$i]))
							$purchases[$i] = new stdClass;
						$purchases[$i]->$n = $v;
						}
				}		
				$posted_purchases_ids = array();
				foreach($purchases as $purchase)
				{
					$variant = $this->variants->get_variant($purchase->variant_id);

					if(!empty($purchase->id))
						if(!empty($variant))
							$this->orders->update_purchase($purchase->id, array('variant_id'=>$purchase->variant_id, 'variant_name'=>$variant->name, 'sku'=>$variant->sku, 'price'=>$purchase->price, 'amount'=>$purchase->amount));
						else
							$this->orders->update_purchase($purchase->id, array('price'=>$purchase->price, 'amount'=>$purchase->amount));
					else
						$purchase->id = $this->orders->add_purchase(array('order_id'=>$order->id, 'variant_id'=>$purchase->variant_id, 'variant_name'=>$variant->name, 'price'=>$purchase->price, 'amount'=>$purchase->amount));
						
					$posted_purchases_ids[] = $purchase->id;			
				}
				
				// Удалить непереданные товары
				foreach($this->orders->get_purchases(array('order_id'=>$order->id)) as $p)
					if(!in_array($p->id, $posted_purchases_ids))
						$this->orders->delete_purchase($p->id);
					
				// Принять
				if($this->request->post('status_new'))
					$new_status = 0;
				elseif($this->request->post('status_new_two'))
					$new_status = 4;
				elseif($this->request->post('status_accept'))
					$new_status = 1;
				elseif($this->request->post('status_done'))
					$new_status = 2;
				elseif($this->request->post('status_deleted'))
					$new_status = 3;
				else
					$new_status = $this->request->post('status', 'string');

				if($this->request->post('return_bonus')) {
					if($order->user_id) {
						$user = $this->users->get_user(intval($order->user_id));
						if(!empty($user)) {
							$this->users->update_user($user->id, array('balance' => ($user->balance + $order->bonus_discount)));
							$this->orders->update_order($order->id, array('bonus_discount'=>0));
						}
					}  
				}
	
				if($new_status == 0)					
				{
					if(!$this->orders->open(intval($order->id)))
						$this->design->assign('message_error', 'error_open');
					else
						$this->orders->update_order($order->id, array('status'=>0));
				}
				elseif($new_status == 4)					
				{
					if(!$this->orders->open(intval($order->id)))
						$this->design->assign('message_error', 'error_open');
					else
						$this->orders->update_order($order->id, array('status'=>4));
				}
				elseif($new_status == 1)					
				{
					if(!$this->orders->close(intval($order->id)))
						$this->design->assign('message_error', 'error_closing');
					else
						$this->orders->update_order($order->id, array('status'=>1));
				}
                elseif($new_status == 5)
                {
                    if(!$this->orders->close(intval($order->id)))
                        $this->design->assign('message_error', 'error_closing');
                    else
                        $this->orders->update_order($order->id, array('status'=>5));
                }
				elseif($new_status == 2)					
				{
					if(!$this->orders->close(intval($order->id)))
						$this->design->assign('message_error', 'error_closing');
					else
						$this->orders->update_order($order->id, array('status'=>2));
				}
				elseif($new_status == 3)					
				{
					if(!$this->orders->open(intval($order->id)))
						$this->design->assign('message_error', 'error_open');
					else
						$this->orders->update_order($order->id, array('status'=>3));
					//header('Location: '.$this->request->get('return'));
				}
				$order = $this->orders->get_order($order->id);
				
				// функционал загрузки файлов
					$files 		= array();
					$files 		= (array)$this->request->post('files');

					// Удаление файлов
					$current_files = $this->files->get_files(array('object_id'=>$order->id,'type'=>'order'));
					foreach($current_files as $file)
						if(!in_array($file->id, $files['id']))
								$this->files->delete_file($file->id);

					// Порядок файлов
					if($files = $this->request->post('files')){
						$i=0;
						foreach($files['id'] as $k=>$id)
						{
							$this->files->update_file($id, array('name'=>$files['name'][$k],'position'=>$i));
							$i++;
						}
					}

					// Загрузка файлов
					$upload_max_filesize = $this->settings->maxattachment * 1024 * 1024;
					if($files = $this->request->files('files')){
						for($i=0; $i<count($files['name']); $i++)
						{
							if($files['name']['size'] < $upload_max_filesize) {
								if ($file_name = $this->files->upload_file($files['tmp_name'][$i], $files['name'][$i])){
									$this->files->add_file($order->id, 'order', $file_name);
								}
								else {
									$this->design->assign('error', 'error uploading file');
								}
							}
						}
					}
				// функционал загрузки файлов end
				
				// Отправляем письмо пользователю
				if($this->request->post('notify_user'))
					$this->notify->email_order_user($order->id);
			}

		}
		else
		{
			$order->id = $this->request->get('id', 'integer');
			$order = $this->orders->get_order(intval($order->id));
			// Метки заказа
			$order_labels = array();
			if(isset($order->id))
			foreach($this->orders->get_order_labels($order->id) as $ol)
				$order_labels[] = $ol->id;			
		}

		$subtotal = 0;
		$purchases_count = 0;
		if($order && $purchases = $this->orders->get_purchases(array('order_id'=>$order->id)))
		{
			// Покупки
			$products_ids = array();
			$variants_ids = array();
			foreach($purchases as $purchase)
			{
				$products_ids[] = $purchase->product_id;
				$variants_ids[] = $purchase->variant_id;
			}
			
			$products = array();
			//foreach($this->products->get_products(array('id'=>$products_ids)) as $p)
			foreach($this->products->get_products(array('id'=>$products_ids, 'limit'=>count($products_ids))) as $p)
				$products[$p->id] = $p;
	
			$images = $this->products->get_images(array('product_id'=>$products_ids));		
			foreach($images as $image)
				$products[$image->product_id]->images[] = $image;
			
			$variants = array();
			foreach($this->variants->get_variants(array('product_id'=>$products_ids)) as $v)
				$variants[$v->id] = $v;
			
			foreach($variants as $variant)
				if(!empty($products[$variant->product_id]))
					$products[$variant->product_id]->variants[] = $variant;
				
			foreach($purchases as &$purchase)
			{
				if(!empty($products[$purchase->product_id]))
					$purchase->product = $products[$purchase->product_id];
				if(!empty($variants[$purchase->variant_id]))
					$purchase->variant = $variants[$purchase->variant_id];
				$subtotal += $purchase->price*$purchase->amount;
				$total_weight += $purchase->amount*$this->features->get_product_option_weight($purchase->product_id);
				$total_volume += $purchase->amount*$this->features->get_product_option_volume($purchase->product_id);
				$purchases_count += $purchase->amount;				
			}			

			if($this->request->get('view') == 'print'){
				function cmp($a1, $b1) 
				{
					$a=$a1->product_name;
					$b=$b1->product_name;
				    if ($a == $b) {
				        return 0;
				    }
				    return ($a < $b) ? -1 : 1;
				}
				usort($purchases, "cmp");
			}
			
		}
		else
		{
			$purchases = array();
		}

		// Если новый заказ и передали get параметры
		if(empty($order->id))
		{
			$order = new stdClass;
			if(empty($order->phone))
				$order->phone = $this->request->get('phone', 'string');
			if(empty($order->name))
				$order->name = $this->request->get('name', 'string');
			if(empty($order->address))
				$order->address = $this->request->get('address', 'string');
			if(empty($order->email))
				$order->email = $this->request->get('email', 'string');
		}

		$this->design->assign('purchases', $purchases);
		$this->design->assign('purchases_count', $purchases_count);
		$this->design->assign('total_weight', $total_weight);
		$this->design->assign('total_volume', $total_volume);
		$this->design->assign('subtotal', $subtotal);
		$this->design->assign('order', $order);

		if(!empty($order->id))
		{
			// Способ доставки
			$delivery = $this->delivery->get_delivery($order->delivery_id);
			$this->design->assign('delivery', $delivery);
	
			// Способ оплаты
			$payment_method = $this->payment->get_payment_method($order->payment_method_id);
			
			if(!empty($payment_method))
			{
				$this->design->assign('payment_method', $payment_method);
		
				// Валюта оплаты
				$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
				$this->design->assign('payment_currency', $payment_currency);
			}
			// Пользователь
			if($order->user_id)
				$this->design->assign('user', $this->users->get_user(intval($order->user_id)));
	
			// Соседние заказы
			$this->design->assign('next_order', $this->orders->get_next_order($order->id, $this->request->get('status', 'string')));
			$this->design->assign('prev_order', $this->orders->get_prev_order($order->id, $this->request->get('status', 'string')));
			
			// функционал загрузки файлов
			$files = $this->files->get_files(array('object_id'=>$order->id,'type'=>'order')); 	
			$this->design->assign('cms_files', $files);
			// функционал загрузки файлов end
			
		}

		// Все способы доставки
		$deliveries = $this->delivery->get_deliveries();
		$this->design->assign('deliveries', $deliveries);

		// Все способы оплаты
		$payment_methods = $this->payment->get_payment_methods();
		$this->design->assign('payment_methods', $payment_methods);

		// Метки заказов
	  	$labels = $this->orders->get_labels();
	 	$this->design->assign('labels', $labels);
	  	
	 	$this->design->assign('order_labels', $order_labels);	  	

		$this->design->assign('tabs_count', $this->orders->all_count_orders());		
		
		if($this->request->get('view') == 'print')
		{
 		  	return $this->design->fetch('order_print.tpl');
		}
		elseif($this->request->get('view') == 'excel') {
			/** Include PHPExcel */
			require_once 'classes/PHPExcel.php';
			$objReader = PHPExcel_IOFactory::createReader('Excel5');
			$objPHPExcel = $objReader->load("fivecms/design/xls/blank3.xls");
			
			// Получаем дату из текстового значения
			//$order_date = strtotime($order->date); 
			$order_date = strtotime(date('d.m.Y')); 
			// Получаем полную дату для вставки в Ecxel 
			$excel_full_date = PHPExcel_Shared_Date::PHPToExcel( gmmktime(0,0,0,date('m',$order_date),date('d',$order_date),date('Y',$order_date)) );
			$total_price = ($order->separate_delivery ? $order->total_price+$order->delivery_price : $order->total_price);
			//$total_price = $this->money->convert($total_price, $payment_currency->id, false);
			
			/* ЛИСТ 1 - товарник */
			$objPHPExcel->setActiveSheetIndex(0);
			$objPHPExcel->getActiveSheet()->setCellValue('D7', $order->name)
										  ->setCellValue('L7', $order->phone)	
										  ->setCellValue('E8', str_replace("\r\n", '', $order->address))
										  ->setCellValue('D9', $order->comment)
										  ->setCellValue('G12', $order->id)
										  ->setCellValue('A2', $this->settings->company_name)
										  ->setCellValue('A4', $this->settings->rekvizites)
										  ->setCellValue('J12', $excel_full_date);
			$objPHPExcel->getActiveSheet()->getStyle('J12')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_DATE_FULLTEXT);
			$baseRow = 16; $all_count=0;
			// Покупки
			foreach ($purchases as $r => $p){
				$row = $baseRow + $r;
				
				if ($p->unit) {
					$exunits = $p->unit;
				} else {
					$exunits = $this->settings->units;
				}
				 
				$tovar = $p->product_name.' '.$p->variant_name.' '.($p->sku ? 'артикул '.$p->sku : '');
				$row_height = ceil(mb_strlen($tovar,'utf8')/55)*12.75;
				$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1); 
				$objPHPExcel->getActiveSheet()->mergeCells('A'.$row.':B'.$row)
											  ->mergeCells('C'.$row.':G'.$row)
											  ->mergeCells('H'.$row.':I'.$row)
											  ->mergeCells('K'.$row.':N'.$row)
											  ->mergeCells('O'.$row.':T'.$row);
			//$objPHPExcel->getActiveSheet()->getStyle('C'.$row.':G'.$row)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER_CONTINUOUS);
				$objPHPExcel->getActiveSheet()->setCellValue('A'.$row, $r+1)
											  ->setCellValue('C'.$row, $tovar)
											  //->setCellValue('H'.$row, $this->settings->units)
											  ->setCellValue('H'.$row, $exunits)
											  ->setCellValue('J'.$row, $p->amount)
											  /*->setCellValue('K'.$row, $p->price)*/
											  ->setCellValue('K'.$row, $this->money->convert($p->price, $payment_currency->id, false))
											  ->setCellValue('O'.$row, '=J'.$row.'*K'.$row);
				$objPHPExcel->getActiveSheet()->getRowDimension($row)->setRowHeight($row_height);
				$all_count++;
			}
			$row++;
				// Рисуем строку с доставкой 
				$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1); 
				$objPHPExcel->getActiveSheet()->mergeCells('A'.$row.':B'.$row)
											  ->mergeCells('C'.$row.':G'.$row)
											  ->mergeCells('H'.$row.':I'.$row)
											  ->mergeCells('K'.$row.':N'.$row)
											  ->mergeCells('O'.$row.':T'.$row);
				$objPHPExcel->getActiveSheet()->setCellValue('A'.$row, $r+2)
											  ->setCellValue('C'.$row, $delivery->name)
											  ->setCellValue('J'.$row, 1)
											  ->setCellValue('K'.$row, $order->delivery_price)
											  ->setCellValue('O'.$row, '=J'.$row.'*K'.$row);
				$objPHPExcel->getActiveSheet()->getRowDimension($row)->setRowHeight(12.75);
				
			$objPHPExcel->getActiveSheet()->removeRow($baseRow-1,1);
				
			$order_sale = $subtotal - $total_price + $order->delivery_price;
			$order_sale = $this->money->convert($order_sale, $payment_currency->id, false);

			if ($subtotal > $total_price) {
				$objPHPExcel->getActiveSheet()->setCellValue('O'.$row, $order_sale);
			} elseif ($subtotal < $total_price) {
				$objPHPExcel->getActiveSheet()->setCellValue('K'.$row, 'Комиссия:')
											  ->setCellValue('O'.$row, ($order_sale*(-1)));			
			} else {
				$objPHPExcel->getActiveSheet()->removeRow($row,1);
				$row--;
			}
			$objPHPExcel->getActiveSheet()->setCellValue('O'.($row+1), $total_price)
										  ->setCellValue('A'.($row+4), $this->orders->num2str($total_price))
										  ->setCellValue('B'.($row+3), 'Всего наименований '.($all_count+1).' на сумму:');											  

			/* ЛИСТ 2 - приходник */
			$objPHPExcel->setActiveSheetIndex(1);
			//list($rub,$kop) = explode('.',sprintf("%015.2f", floatval($order->total_price))); // Получаем копейки и рубли отдельно
			list($rub,$kop) = explode('.',sprintf("%015.2f", floatval($total_price))); 
			$objPHPExcel->getActiveSheet()->setCellValue('F14', $order->id)
										  ->setCellValue('G14', date('d.m.Y'))
										  ->setCellValue('G19', $total_price)
										  ->setCellValue('C24', $this->orders->num2str($total_price,true))
										  ->setCellValue('H26', ' '.$kop)
										  ->setCellValue('B8', $this->settings->company_name)
										  ->setCellValue('C21', $order->name);
										  
			// Вернемся на первый лист!
			$objPHPExcel->setActiveSheetIndex(0);
			
			// Redirect output to a client’s web browser (Excel5)
			header('Content-Type: application/vnd.ms-excel');
			header('Content-Disposition: attachment;filename="Order_N'.$order->id.'.xls"');
			header('Cache-Control: max-age=0');
			// If you're serving to IE 9, then the following may be needed
			header('Cache-Control: max-age=1');

			// If you're serving to IE over SSL, then the following may be needed
			header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
			header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
			header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
			header ('Pragma: public'); // HTTP/1.0

			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
			$objWriter->save('php://output');	
			
		} 
        /* ---- ДОКУМЕНТ ТОРГ-12 ---- */
		elseif ($this->request->get('view') == 'torg12') {
			//ini_set('display_errors', 'On');
			//error_reporting(E_ALL | E_STRICT);
			/** Include PHPExcel */
			require_once 'classes/PHPExcel.php';
			$objReader = PHPExcel_IOFactory::createReader('Excel5');
			$objPHPExcel = $objReader->load("fivecms/design/xls/torg12.xls");
			$objPHPExcel->setActiveSheetIndex(0);

			$thin_border = array(
				'borders' => array(
					'allborders' => array(
						'style' => PHPExcel_Style_Border::BORDER_THIN
					)
				)
			);

			$medium_border = array(
				'borders' => array(
					'outline' => array(
						'style' => PHPExcel_Style_Border::BORDER_MEDIUM
					)
				)
			);			
			
			$none_border = array(
				'borders' => array(
					'allborders' => array(
						'style' => PHPExcel_Style_Border::BORDER_NONE
					)
				)
			);

			$align_center = array(
				'alignment' => array(
					'horizontal' => array(
						'style' => PHPExcel_Style_Border::BORDER_NONE
					)
				)
			);			
						
			$baseRow = 35; $count = 1; $fcount = 1;
			$list = array();
            $user = $this->users->get_user(intval($order->user_id));
			
			// ШАПКА
			// Получаем дату из текстового значения
			$order_date = strtotime($order->date); 
			// Получаем полную дату для вставки в Ecxel 
			$excel_full_date = PHPExcel_Shared_Date::PHPToExcel( gmmktime(0,0,0,date('m',$order_date),date('d',$order_date),date('Y',$order_date)) );
			$objPHPExcel->getActiveSheet()->setCellValue('I12', (isset($user->consignee) && !empty($user->consignee) ? $user->consignee : $order->name))
										  ->setCellValue('I18', (isset($user->payer) && !empty($user->payer) ? $user->payer : $order->name))
										  ->setCellValue('AG28', $order->id)
										  ->setCellValue('AL28', $excel_full_date)
										  ->setCellValue('AY22', $excel_full_date)
										  ->setCellValue('I8', $this->settings->consignor)
										  ->setCellValue('I15', $this->settings->supplier)
										  ->setCellValue('I21', 'Заказ')
										  ->setCellValue('AY21', $order->id);		
			
			// Если у нас доставка больше 0 и мы включили отображение ее в ТОРГ-12, то добавляем к покупкам доставку
			if ($order->delivery_price > 0 && $this->settings->torg12_delivery) {
				$dostavka = new stdClass;
				$dostavka->variant_id = '';
				$dostavka->product_name = $delivery->name;
				$dostavka->variant_name = '';
				$dostavka->price = $order->delivery_price;
				$dostavka->amount = 1;
				$dostavka->sku = '';
				$purchases[] = $dostavka;
			}
			
			// echo "<pre>"; print_r($purchases); echo "</pre>"; exit;
			
			// Покупки
			foreach ($purchases as $r => $p) 
			{
				$row = $baseRow + $r;		
				
				$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1);
				//$objPHPExcel->getActiveSheet()->duplicateStyle($objPHPExcel->getActiveSheet()->getStyle('B'.($row-1).':BF'.($row-1)),'B'.$row.':BF'.$row);				
				$objPHPExcel->getActiveSheet()->mergeCells('B'.$row.':D'.$row)
											  ->mergeCells('E'.$row.':R'.$row)
											  ->mergeCells('S'.$row.':U'.$row)
											  ->mergeCells('V'.$row.':X'.$row)
											  ->mergeCells('Y'.$row.':AA'.$row)
											  ->mergeCells('AB'.$row.':AD'.$row)
											  ->mergeCells('AE'.$row.':AG'.$row)
											  ->mergeCells('AH'.$row.':AI'.$row)
											  ->mergeCells('AJ'.$row.':AL'.$row)
											  ->mergeCells('AM'.$row.':AO'.$row)
											  ->mergeCells('AP'.$row.':AR'.$row)
											  ->mergeCells('AS'.$row.':AU'.$row)
											  ->mergeCells('AV'.$row.':AX'.$row)
											  ->mergeCells('AY'.$row.':BB'.$row)
											  ->mergeCells('BC'.$row.':BF'.$row); 
				if ($p->variant_id)							  
					$product_name = "Карнавальный костюм " . trim(preg_replace('/(костюм|Костюм)/i', '', $p->product_name));
				else
					$product_name = $p->product_name;
				$objPHPExcel->getActiveSheet()->setCellValue('B'.$row, $r+1)
											  ->setCellValue('E'.$row, $product_name.' '.$p->variant_name.' '.($p->sku ? 'артикул '.$p->sku : ''))
											  ->setCellValue('S'.$row, $p->variant_id)
											  ->setCellValue('V'.$row, $this->settings->units)
											  ->setCellValue('Y'.$row, 796)
											  ->setCellValue('AM'.$row, $p->amount)
											  ->setCellValue('AP'.$row, round($p->price*(100-$order->discount)/100, 2))
											  ->setCellValue('AS'.$row, '=AM'.$row.'*AP'.$row)
											  ->setCellValue('AV'.$row, 'Без НДС')
											  ->setCellValue('AY'.$row, '-')
											  ->setCellValue('BC'.$row, '=AS'.$row); 	
				//$objPHPExcel->getActiveSheet()->getStyle('S'.$row.':BF'.$row)->applyFromArray($thin_border);
				
				$size_order = sizeof($purchases); // Размер массива товаров в заказе
				// Рвем первую страницу, как дойдем до 12 строки
				if ($fcount == 12 ) {
					// Если у нас 12 строк, то последнюю строку переносим на сл.страницу
					if ($r+1 == $size_order) 
						$list[] = $row-1;
					// ...иначе, просто разрыв
					else
						$list[] = $row;
					$count = 0; // обнуляем счетчик строк в странице 
					$pp = 1;	// указываем кол-во шапочных строк old=5
				}
				// Рвем страницу, как дойдем до 25 строки
				if ($count == 25) {
					// Если эта строка является последней, то делаем разрыв выше на одну строку
					if ($r+1 == $size_order) 
						$list[] = $row+$pp-1;
					// ...иначе, просто разрыв
					else
						$list[] = $row+$pp;
					$count = 0; // обнуляем счетчик строк на странице
					$pp = $pp + 1; // увеличиваем кол-во шапочных строк old=5
				}
				
				$count++; // Считаем счетчик строк на страницу
				$fcount++;
			}
			// После вывода всех строк, нам необходимо найти место для разрыва, если это необходимо?
			// Если строк у нас больше чем 1 и меньше чем 13
			if ($fcount > 2 && $fcount < 13) {
				$list[] = $row-1;
			}
			if ($count > 15) {
				$list[] = $row+$pp-1;
			}
			
			$objPHPExcel->getActiveSheet()->removeRow(34,1);
			
			$last_row = $row;
			$start_row = 34;
			//var_dump ($list); echo sizeof($purchases); exit; 
			foreach ($list as $row)
			{		
				//$row = $baseRow + 11;
				// Добавляем подитог
				$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1); 
				$objPHPExcel->getActiveSheet()->getRowDimension($row)->setRowHeight(17.25);
				$objPHPExcel->getActiveSheet()->mergeCells('AH'.$row.':AI'.$row)
											  ->mergeCells('AJ'.$row.':AL'.$row)
											  ->mergeCells('AM'.$row.':AO'.$row)
											  ->mergeCells('AP'.$row.':AR'.$row)
											  ->mergeCells('AS'.$row.':AU'.$row)
											  ->mergeCells('AV'.$row.':AX'.$row)
											  ->mergeCells('AY'.$row.':BB'.$row)
											  ->mergeCells('BC'.$row.':BF'.$row); 
				// Жирненькая рамка столбцов страницы
				$objPHPExcel->getActiveSheet()->getStyle('S'.$start_row.':U'.($row-1))->applyFromArray($medium_border);							  
				$objPHPExcel->getActiveSheet()->getStyle('Y'.$start_row.':AU'.($row-1))->applyFromArray($medium_border);							  
				$objPHPExcel->getActiveSheet()->getStyle('AY'.$start_row.':BF'.($row-1))->applyFromArray($medium_border);							  
				// Заполняем подитог
				$objPHPExcel->getActiveSheet()->setCellValue('AG'.$row, 'Итого:')
											  ->setCellValue('AM'.$row, '=SUM(AM'.$start_row.':AO'.($row-1).')')
											  ->setCellValue('AP'.$row, 'х')
											  ->setCellValue('AS'.$row, '=SUM(AS'.$start_row.':AU'.($row-1).')')
											  ->setCellValue('AV'.$row, 'х')
											  ->setCellValue('BC'.$row, '=SUM(BC'.$start_row.':BF'.($row-1).')'); 
				$objPHPExcel->getActiveSheet()->getStyle('AP'.$row)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$objPHPExcel->getActiveSheet()->getStyle('AG'.$row)->getAlignment()->setWrapText(false);
				$objPHPExcel->getActiveSheet()->getStyle('AG'.$row)->getFont()->setSize(9); 
				$objPHPExcel->getActiveSheet()->getStyle('B'.$row.':AG'.$row)->applyFromArray($none_border);
				$objPHPExcel->getActiveSheet()->setBreak('A'.$row, PHPExcel_Worksheet::BREAK_ROW );
				$row++;
				$last_row = $last_row + 1;
				$start_row = $row;
			}		
			// Жирненькая рамка последней страницы
			$objPHPExcel->getActiveSheet()->getStyle('S'.$start_row.':U'.($last_row-1))->applyFromArray($medium_border);							  
			$objPHPExcel->getActiveSheet()->getStyle('Y'.$start_row.':AU'.($last_row-1))->applyFromArray($medium_border);							  
			$objPHPExcel->getActiveSheet()->getStyle('AY'.$start_row.':BF'.($last_row-1))->applyFromArray($medium_border);							  
			
			// Итог последней страницы
			$objPHPExcel->getActiveSheet()->setCellValue('AM'.$last_row, '=SUM(AM'.$start_row.':AO'.($last_row-1).')')
										  ->setCellValue('AS'.$last_row, '=SUM(AS'.$start_row.':AU'.($last_row-1).')')
										  ->setCellValue('BC'.$last_row, '=SUM(BC'.$start_row.':BF'.($last_row-1).')'); 
			
			// Общий итог накладной
			$kolvo = ''; $sum1 = ''; $sum2 = '';
			foreach ($list as $v) {
				$kolvo .= 'AM'.$v.'+';
				$sum1  .= 'AS'.$v.'+';
				$sum2  .= 'BC'.$v.'+';
			}
			$objPHPExcel->getActiveSheet()->setCellValue('AM'.($last_row+1), '='.$kolvo.'AM'.$last_row)
										  ->setCellValue('AS'.($last_row+1), '='.$sum1.'AS'.$last_row)
										  ->setCellValue('BC'.($last_row+1), '='.$sum2.'BC'.$last_row);

			// Число позиций прописью 
			$objPHPExcel->getActiveSheet()->setCellValue('G'.($last_row+4), $this->orders->num2str($r+1,true));										  
			// Сумма прописью 
			$objPHPExcel->getActiveSheet()->setCellValue('K'.($last_row+13), $this->orders->num2str($objPHPExcel->getActiveSheet()->getCell('BC'.($last_row+1))->getCalculatedValue()));
			// Дата внизу
			$objPHPExcel->getActiveSheet()->setCellValue('I'.($last_row+23), $excel_full_date);
			
			// Echo memory usage
			/*
			$objPHPExcel->getActiveSheet()->setCellValue('I8',  ' Текущее использование памяти сервера: ' . (memory_get_usage(true) / 1024 / 1024) . ' MB ')
										  // Echo memory peak usage
										  ->setCellValue('I15',  ' Пиковое использование памяти сервера: ' . (memory_get_peak_usage(true) / 1024 / 1024) . ' MB ');		
			*/
			
			// Redirect output to a client’s web browser (Excel5)
			header('Content-Type: application/vnd.ms-excel');
			header('Content-Disposition: attachment;filename="TORG12_N'.$order->id.'.xls"');
			header('Cache-Control: max-age=0');
			// If you're serving to IE 9, then the following may be needed
			header('Cache-Control: max-age=1');

			// If you're serving to IE over SSL, then the following may be needed
			header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
			header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
			header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
			header ('Pragma: public'); // HTTP/1.0

			
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
			$objWriter->save('php://output');	
				
		}
        /* ---- СЧЕТ НА ОПЛАТУ ---- */
		elseif($this->request->get('view') == 'invoice') {
			require_once 'fivecms/classes/PHPExcel.php';
			$objReader = PHPExcel_IOFactory::createReader('Excel5');
			$objPHPExcel = $objReader->load("fivecms/design/xls/invoice.xls");
			
			$this->db->query($this->db->placehold("SELECT id FROM __payment_methods WHERE module='ReceiptUr' LIMIT 1"));
			$payment_method = $this->db->result();			
			$payment_settings = $this->payment->get_payment_settings($payment_method->id);			

			// Получаем дату из текстового значения
			$order_date = strtotime($order->date); 
			// Получаем полную дату для вставки в Ecxel 
			$excel_full_date = PHPExcel_Shared_Date::PHPToExcel( gmmktime(0,0,0,date('m',$order_date),date('d',$order_date),date('Y',$order_date)) );
			$total_price = ($order->separate_delivery ? $order->total_price+$order->delivery_price : $order->total_price);

            $user = $this->users->get_user(intval($order->user_id));
			
			$objPHPExcel->setActiveSheetIndex(0);
			$objPHPExcel->getActiveSheet()->setCellValue('B6', 'ИНН '.$payment_settings['inn'])
										  ->setCellValue('E6', 'КПП '.$payment_settings['kpp'])
										  ->setCellValue('B8', $payment_settings['recipient'])
										  ->setCellValue('B10', $payment_settings['bank'])
										  ->setCellValueExplicit('H9', $payment_settings['bik'], PHPExcel_Cell_DataType::TYPE_STRING)
										  ->setCellValueExplicit('H8', $payment_settings['account'], PHPExcel_Cell_DataType::TYPE_STRING)
										  ->setCellValueExplicit('H10', $payment_settings['correspondent_account'], PHPExcel_Cell_DataType::TYPE_STRING)										  
										  ->setCellValue('B12', 'Счет на оплату № '.$order->id.' от '.date('d.m.Y',$order_date).' г.')
										  ->setCellValue('D13', (isset($user->payer) && !empty($user->payer) ? $user->payer : $order->name))
										  ->setCellValue('D14', (isset($user->consignee) && !empty($user->consignee) ? $user->consignee : $order->name));
			//$objPHPExcel->getActiveSheet()->getStyle('J4')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_DATE_FULLTEXT);
			$row_height = ceil(mb_strlen($plat,'utf8')/80)*14.25;
			$objPHPExcel->getActiveSheet()->getRowDimension(13)->setRowHeight($row_height);
			$row_height = ceil(mb_strlen($gruz,'utf8')/80)*14.25;
			$objPHPExcel->getActiveSheet()->getRowDimension(14)->setRowHeight($row_height);

			$skidka = 1-$order->discount/100;
			
			//$purchases = $simpla->orders->get_purchases(array('order_id'=>$order->id));	
			$baseRow = 18; $subtotal = 0; $subtotal_pdv = 0;
			
			foreach ($purchases as $r => $p){
				$row = $baseRow + $r;
				$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1); 
				$product_name = "Карнавальный костюм " . trim(preg_replace('/(костюм|Костюм)/i', '', $p->product_name));
				$tovar = $product_name.' '.$p->variant_name.' '.($p->sku ? 'артикул '.$p->sku : '');
				
				$row_height = ceil(mb_strlen($tovar,'utf8')/50)*12;
				$objPHPExcel->getActiveSheet()->mergeCells('C'.$row.':E'.$row);		
				$objPHPExcel->getActiveSheet()->setCellValue('B'.$row, $r+1)
											  ->setCellValue('C'.$row, $tovar)
											  ->setCellValue('F'.$row, $this->settings->units)
											  ->setCellValue('G'.$row, $p->amount)
											  ->setCellValue('H'.$row, round($p->price*(100-$order->discount)/100, 2)) 
											  ->setCellValue('I'.$row, '=G'.$row.'*H'.$row);

				$objPHPExcel->getActiveSheet()->getRowDimension($row)->setRowHeight($row_height);
			}
			// Если есть доставка и она не пустая, то рисуем строку
			if ($delivery && $order->delivery_price > 0){
				$row++; $r++;
				$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1); 
				$objPHPExcel->getActiveSheet()->mergeCells('C'.$row.':E'.$row);
				$objPHPExcel->getActiveSheet()->setCellValue('B'.$row, $r+1)
											  ->setCellValue('C'.$row, $delivery->name)
											  ->setCellValue('G'.$row, 1)
											  ->setCellValue('H'.$row, $order->delivery_price)
											  ->setCellValue('I'.$row, '=G'.$row.'*H'.$row);
			}	
			
			$objPHPExcel->getActiveSheet()->removeRow($baseRow-1,1);
				
			$objPHPExcel->getActiveSheet()->setCellValue('I'.($row+0), '=SUM(I'.($baseRow-1).':I'.($row-1).')')
										  ->setCellValue('I'.($row+2), '=I'.($row+0))
										  ->setCellValue('B'.($row+4), 'Всего наименований '.($r+1).', на сумму')
										  ->setCellValue('F'.($row+4), '=I'.($row+2))
										  ->setCellValue('B'.($row+5), $this->orders->num2str($objPHPExcel->getActiveSheet()->getCell('I'.($row+2))->getCalculatedValue()));
			
			//if (isset($payment_settings['stamp'])) {
				// Лепим печать
				$objDrawing = new PHPExcel_Worksheet_Drawing();
				$objDrawing->setName('Stamp');
				$objDrawing->setDescription('stamp');
				$objDrawing->setPath('fivecms/design/xls/stamp.png');
				$objDrawing->setHeight(153);
				$objDrawing->setCoordinates('E'.($row+7));
				$objDrawing->setOffsetX(10);
				$objDrawing->setWorksheet($objPHPExcel->getActiveSheet());
				
				// Лепим подпись
				$objDrawing = new PHPExcel_Worksheet_Drawing();
				$objDrawing->setPath('fivecms/design/xls/podpis.png');
				$objDrawing->setHeight(68);
				$objDrawing->setCoordinates('E'.($row+6));
				$objDrawing->setOffsetX(-20);
				$objDrawing->setWorksheet($objPHPExcel->getActiveSheet());
				// ... и еще одну подпись
				$objDrawing = new PHPExcel_Worksheet_Drawing();
				$objDrawing->setPath('fivecms/design/xls/podpis.png');
				$objDrawing->setHeight(68);
				$objDrawing->setCoordinates('D'.($row+8));
				$objDrawing->setOffsetX(20);
				$objDrawing->setOffsetY(10);
				$objDrawing->setWorksheet($objPHPExcel->getActiveSheet());
			//}
			
			// Redirect output to a client’s web browser (Excel5)
			header('Content-Type: application/vnd.ms-excel');
			header('Content-Disposition: attachment;filename="Schet_N'.$order->id.'.xls"');
			header('Cache-Control: max-age=0');
			// If you're serving to IE 9, then the following may be needed
			header('Cache-Control: max-age=1');

			// If you're serving to IE over SSL, then the following may be needed
			header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
			header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
			header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
			header ('Pragma: public'); // HTTP/1.0

			
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
			$objWriter->save('php://output');
		}						
 	  	else
		{
	 	  	return $this->design->fetch('order.tpl');
		}

	}
}
