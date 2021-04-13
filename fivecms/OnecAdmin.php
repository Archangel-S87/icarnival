<?PHP
require_once('api/Fivecms.php');

class OnecAdmin extends Fivecms
{	
	public function fetch()
	{
		if($this->request->method('post') && ($this->request->post("settings"))) {
			$this->settings->onebrand = $this->request->post('onebrand');
			$this->settings->onegetbrand = $this->request->post('onegetbrand');
			$this->settings->onemetatitle = $this->request->post('onemetatitle');
			$this->settings->oneprodname = $this->request->post('oneprodname');
			$this->settings->oneprodannot = $this->request->post('oneprodannot');
			$this->settings->oneprodbody = $this->request->post('oneprodbody');
			$this->settings->onephone = $this->request->post('onephone');
			$this->settings->oneemail = $this->request->post('oneemail');
			$this->settings->oneprodupdate = $this->request->post('oneprodupdate');
			$this->settings->oneunlink = $this->request->post('oneunlink');
			$this->settings->oneunits = $this->request->post('oneunits');
			$this->settings->oneid = $this->request->post('oneid');
			$this->settings->onecurrency = $this->request->post('onecurrency');	
			$this->settings->oneimages = $this->request->post('oneimages');
			$this->settings->onevariants = $this->request->post('onevariants');
			$this->settings->onesizecol = $this->request->post('onesizecol');
			$this->settings->last_1c_orders_export_date = $this->request->post('last_1c_orders_export_date');
			
			$this->settings->one_status0 = $this->request->post('one_status0');
			$this->settings->one_status1 = $this->request->post('one_status1');
			$this->settings->one_status2 = $this->request->post('one_status2');
			$this->settings->one_status3 = $this->request->post('one_status3');
			$this->settings->one_status4 = $this->request->post('one_status4');
							
			$this->design->assign('message_success',  'Настройки сохранены');
		}

		return $this->design->fetch('onec.tpl');
	}
	
}

