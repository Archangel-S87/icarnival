<?PHP

use YooKassa\Client;
use YooKassa\Model\PaymentInterface;
use YooKassa\Model\PaymentStatus;
use YooMoneyModule\YooMoneyLogger;

require_once('View.php');

class OrderView extends View
{
	public function __construct()
	{
		parent::__construct();
		$this->design->smarty->registerPlugin("function", "checkout_form", array($this, 'checkout_form'));
	}

	//////////////////////////////////////////
	// Основная функция
	//////////////////////////////////////////
	function fetch()
	{
		// Скачивание файла
		if($this->request->get('file'))
		{
			return $this->download();
		}
		else
		{
			return $this->fetch_order();
		}
	}
	
	function fetch_order()
	{
		if($url = $this->request->get('url', 'string'))
			$order = $this->orders->get_order((string)$url);
		elseif(!empty($_SESSION['order_id']))
			$order = $this->orders->get_order(intval($_SESSION['order_id']));
		else
			return false;
			
		if(!$order)
			return false;
						
		$purchases = $this->orders->get_purchases(array('order_id'=>intval($order->id)));
		if(!$purchases)
			return false;
			
		if($this->request->method('post'))
		{
			if($payment_method_id = $this->request->post('payment_method_id', 'integer'))
			{
				$this->orders->update_order($order->id, array('payment_method_id'=>$payment_method_id));
				$order = $this->orders->get_order((integer)$order->id);
			}
			elseif($this->request->post('reset_payment_method'))
			{
				$this->orders->update_order($order->id, array('payment_method_id'=>null));
				$order = $this->orders->get_order((integer)$order->id);
			}
		}
		
		$products_ids = array();
		$variants_ids = array();

		foreach($purchases as $purchase)
		{
			$products_ids[] = $purchase->product_id;
			$variants_ids[] = $purchase->variant_id;
		}
		$products = array();

		foreach($this->products->get_products(array('id'=>$products_ids, 'limit' => count($products_ids))) as $p)
			$products[$p->id] = $p;
		
		$images = $this->products->get_images(array('product_id'=>$products_ids));
		foreach($images as $image)
			$products[$image->product_id]->images[] = $image;
		
		$variants = array();
		foreach($this->variants->get_variants(array('id'=>$variants_ids)) as $v)
			$variants[$v->id] = $v;
			
		foreach($variants as $variant)
			$products[$variant->product_id]->variants[] = $variant;

		foreach($products as &$product)
		{
			if(isset($product->variants[0]))
				$product->variant = $product->variants[0];
			if(isset($product->images[0]))
				$product->image = $product->images[0];
			$product->features = $this->features->get_product_options(array('product_id'=>$product->id));
		}
			
		$total_weight = 0;
		$total_volume = 0;
		$subtotal = 0;
		foreach($purchases as &$purchase)
		{
			if(!empty($products[$purchase->product_id]))
				$purchase->product = $products[$purchase->product_id];
			if(!empty($variants[$purchase->variant_id]))
			{
				$purchase->variant = $variants[$purchase->variant_id];

				$purchase->features = $this->features->get_product_options(array('product_id'=>$product->id));

			}
            $total_weight += $purchase->amount*$this->features->get_product_option_weight($purchase->product_id);
			$total_volume += $purchase->amount*$this->features->get_product_option_volume($purchase->product_id);
			$subtotal += $purchase->price*$purchase->amount;
		}
		
		// Способ доставки
		$delivery = $this->delivery->get_delivery($order->delivery_id);
		$this->design->assign('delivery', $delivery);
		$this->design->assign('total_weight', $total_weight);
		$this->design->assign('total_volume', $total_volume);
		$this->design->assign('subtotal', $subtotal);		
		$this->design->assign('order', $order);
		$this->design->assign('purchases', $purchases);

		// Способ оплаты
		if($order->payment_method_id)
		{
			$payment_method = $this->payment->get_payment_method($order->payment_method_id);
			$this->design->assign('payment_method', $payment_method);

            // Проверка на резервирование средств
            if ($payment_method
                && $payment_method->module == 'YooMoneyApi'
                && $order->payment_details
                && !$order->paid) {
                require_once 'payment/YooMoneyApi/autoload.php';
                $settings = $this->payment->get_payment_settings($payment_method->id);
                $apiClient = new Client();
                $apiClient->setAuth($settings['yoomoney_shopid'], $settings['yoomoney_password']);
                $apiClient->setLogger(new YooMoneyLogger($settings['yookassa_debug']));

                /** @var PaymentInterface $payment */
                try {
                    $payment = $apiClient->getPaymentInfo($order->payment_details);
                } catch (Exception $e) {
                    $payment = null;
                    $order->invalid_request = $e->getMessage();
                }

                if ($payment && $payment->status == PaymentStatus::WAITING_FOR_CAPTURE && !$settings['yookassa_api_capture']) {
                    $order->paid = 1;
                }
                $this->design->assign('order', $order);
            }
		}
			
		// Варианты оплаты
		$payment_methods = $this->payment->get_payment_methods(array('delivery_id'=>$order->delivery_id, 'enabled'=>1));
		$this->design->assign('payment_methods', $payment_methods);

		// Все валюты
		$this->design->assign('all_currencies', $this->money->get_currencies());

		// Загруженные файлы
		$files = $this->files->get_files(array('object_id'=>$order->id,'type'=>'order'));
		$this->design->assign('cms_files', $files);  

		// Выводим заказ
		return $this->body = $this->design->fetch('order.tpl');
	}
	
	private function download()
	{
		$file = $this->request->get('file');
		
		if(!$url = $this->request->get('url', 'string'))
			return false;
			
		$order = $this->orders->get_order((string)$url);
		if(!$order)
			return false;
			
		if(!$order->paid)
			return false;
		
		// Срок жизни ссылки на скачивание 7 дней	
		//if(!$order->payment_date<=date('Y-m-d H:i:s', date('U')-7*24*60*60))
		//	return false;
						
		// Проверяем, есть ли такой файл в покупках	
		$query = $this->db->placehold("SELECT p.id FROM __purchases p, __variants v WHERE p.variant_id=v.id AND p.order_id=? AND v.attachment=?", $order->id, $file);
		$this->db->query($query);
		if($this->db->num_rows()==0)
			return false;
		
		header("Content-type: application/force-download");
		header("Content-Disposition: attachment; filename=\"$file\"");
		header("Content-Length: ".filesize($this->config->root_dir.$this->config->downloads_dir.$file));
		print file_get_contents($this->config->root_dir.$this->config->downloads_dir.$file);
		
		exit();
	}
	
	public function checkout_form($params, $smarty)
	{
		$module_name = preg_replace("/[^A-Za-z0-9]+/", "", $params['module']);

		$form = '';
		if(!empty($module_name) && is_file("payment/$module_name/$module_name.php"))
		{
			include_once("payment/$module_name/$module_name.php");
			$module = new $module_name();
			if(isset($params['button_text']))
				$form = $module->checkout_form($params['order_id'], $params['button_text']);
			else
				$form = $module->checkout_form($params['order_id'], null);
		}
		return $form;
	}

}
