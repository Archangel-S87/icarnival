<?PHP
require_once('api/Fivecms.php');

class PaymentMethodAdmin extends Fivecms
{	

	private $allowed_image_extentions = array('png');

	public function fetch()
	{	
		$payment_method = new stdClass;
		if($this->request->method('post'))
		{
			$payment_method->id 			= $this->request->post('id', 'intgeger');
			$payment_method->enabled 		= $this->request->post('enabled', 'boolean');
			$payment_method->name 			= $this->request->post('name');
			$payment_method->currency_id	= $this->request->post('currency_id');
			$payment_method->description	= $this->request->post('description');
			$payment_method->module			= $this->request->post('module', 'string');
			
			$payment_settings = $this->request->post('payment_settings');

	 		if(!$payment_deliveries = $this->request->post('payment_deliveries'))
	 			$payment_deliveries = array();

			if(empty($payment_method->id))
			{
  				$payment_method->id = $this->payment->add_payment_method($payment_method);
  				$this->design->assign('message_success', 'Добавлено');
	    	}
	    	else
	    	{
	    		$this->payment->update_payment_method($payment_method->id, $payment_method);
  				$this->design->assign('message_success', 'Обновлено');
	    	}
	    	if($payment_method->id)
	    	{
	    		$this->payment->update_payment_settings($payment_method->id, $payment_settings);	    	
	    		$this->payment->update_payment_deliveries($payment_method->id, $payment_deliveries);
	    	}
		}
		else
		{
			$payment_method->id = $this->request->get('id', 'integer');
			if(!empty($payment_method->id))
			{
				$payment_method = $this->payment->get_payment_method($payment_method->id);
				$payment_settings =  $this->payment->get_payment_settings($payment_method->id);
			}
			else
			{
				$payment_settings = array();
			}
			$payment_deliveries = $this->payment->get_payment_deliveries($payment_method->id);
		}
		
		if(!empty($printimg = $this->request->files('printimg_file', 'tmp_name'))){
			if(!empty($printimg) && in_array(pathinfo($this->request->files('printimg_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions))
			{
				if(!@move_uploaded_file($printimg, $this->config->root_dir.'payment/ReceiptUr/print.png'))
					$this->design->assign('message_error', 'image_is_not_writable');
			}
		}
		if(!empty($signimg = $this->request->files('signimg_file', 'tmp_name'))){
			if(!empty($signimg) && in_array(pathinfo($this->request->files('signimg_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions))
			{
				if(!@move_uploaded_file($signimg, $this->config->root_dir.'payment/ReceiptUr/sign.png'))
					$this->design->assign('message_error', 'image_is_not_writable');
			}
		}
		if(!empty($buhimg = $this->request->files('buhimg_file', 'tmp_name'))){
			if(!empty($buhimg) && in_array(pathinfo($this->request->files('buhimg_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions))
			{
				if(!@move_uploaded_file($buhimg, $this->config->root_dir.'payment/ReceiptUr/buh.png'))
					$this->design->assign('message_error', 'image_is_not_writable');
			}
		}
			
		$this->design->assign('payment_deliveries', $payment_deliveries);	
		// Связанные способы доставки
		$deliveries = $this->delivery->get_deliveries();
		$this->design->assign('deliveries', $deliveries);

		$this->design->assign('payment_method', $payment_method);
		$this->design->assign('payment_settings', $payment_settings);
		$payment_modules = $this->payment->get_payment_modules();
		$this->design->assign('payment_modules', $payment_modules);
		
		$currencies = $this->money->get_currencies();
		$this->design->assign('currencies', $currencies);
		
		
  	  	return $this->design->fetch('payment_method.tpl');
	}
	
}

