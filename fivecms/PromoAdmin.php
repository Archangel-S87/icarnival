<?PHP
require_once('api/Fivecms.php');

class PromoAdmin extends Fivecms
{		
	public function fetch()
	{		
		if($this->request->method('POST'))
		{
			$this->settings->counters = $this->request->post('counters');
			$this->settings->analytics = $this->request->post('analytics');
			$this->settings->script_header = $this->request->post('script_header');
			$this->settings->script_footer = $this->request->post('script_footer');
			
			$this->settings->filtercan = $this->request->post('filtercan');
			$this->settings->seo_description = $this->request->post('seo_description');
			
			$this->design->assign('message_success', 'saved');
		}

		$this->design->assign('promo',	$this->promo);
 	  	return $this->design->fetch('promo.tpl');
	}
	
}

