<?PHP
require_once('api/Fivecms.php');

class OnecAdmin extends Fivecms
{	
	public function fetch()
	{
		if($this->request->method('post') && ($this->request->post("settings"))) {
			$this->settings->onesuccess = $this->request->post('onesuccess');
			$this->settings->onebrand = $this->request->post('onebrand');
			$this->settings->onevid = $this->request->post('onevid');
			$this->settings->onedeliv = $this->request->post('onedeliv');
			$this->settings->onephone = $this->request->post('onephone');
			$this->settings->oneskid = $this->request->post('oneskid');
			$this->settings->oneprodupdate = $this->request->post('oneprodupdate');
			$this->settings->oneflushvar = $this->request->post('oneflushvar');		
			$this->settings->oneunits = $this->request->post('oneunits');
			$this->settings->onecurrency = $this->request->post('onecurrency');	
			$this->settings->oneimages = $this->request->post('oneimages');
			$this->settings->onevariants = $this->request->post('onevariants');
			$this->settings->onesizecol = $this->request->post('onesizecol');
							
			$this->design->assign('message_success',  'Настройки сохранены');
		}

		return $this->design->fetch('onec.tpl');
	}
	
}

