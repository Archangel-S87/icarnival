<?PHP
require_once('api/Fivecms.php');

class DeliveryAdmin extends Fivecms
{	
	public function fetch()
	{	
		$delivery = new stdClass;
		if($this->request->method('post'))
		{
			$delivery->id               = $this->request->post('id', 'integer');
			$delivery->enabled          = $this->request->post('enabled', 'boolean');
			$delivery->name             = $this->request->post('name');
	 		$delivery->description      = $this->request->post('description');
	 		$delivery->price            = $this->request->post('price');
	 		$delivery->price2           = $this->request->post('price2');
	 		$delivery->additional_cost  = $this->request->post('additional_cost');
	 		$delivery->free_from        = $this->request->post('free_from');
	 		$delivery->separate_payment	= $this->request->post('separate_payment');
	 		
	 		$delivery->option1 = $this->request->post('option1');
	 		$delivery->option2 = $this->request->post('option2');
			$delivery->option3 = $this->request->post('option3');
			$delivery->option4 = $this->request->post('option4');
			$delivery->option5 = $this->request->post('option5');
	 		
	 		$delivery->widget = $this->request->post('widget');
	 		$delivery->code = $this->request->post('code');
	 		
	 		if(!$delivery_payments = $this->request->post('delivery_payments'))
	 			$delivery_payments = array();
			
			if(empty($delivery->id))
			{
  				$delivery->id = $this->delivery->add_delivery($delivery);
  				$this->design->assign('message_success', 'added');
	    	}
	    	else
	    	{
	    		$this->delivery->update_delivery($delivery->id, $delivery);
  				$this->design->assign('message_success', 'updated');
	    	}
	    	$this->delivery->update_delivery_payments($delivery->id, $delivery_payments);
		}
		else
		{
			$delivery->id = $this->request->get('id', 'integer');
			if(!empty($delivery->id))
			{
				$delivery = $this->delivery->get_delivery($delivery->id);
			}
			$delivery_payments = $this->delivery->get_delivery_payments($delivery->id);
		}	
		$this->design->assign('delivery_payments', $delivery_payments);

		// Связанные способы оплаты
		$payment_methods = $this->payment->get_payment_methods();
		$this->design->assign('payment_methods', $payment_methods);

		$this->design->assign('delivery', $delivery);

  	  	return $this->design->fetch('delivery.tpl');
	}
}

