<?PHP
require_once('api/Fivecms.php');

class StadAdmin extends Fivecms
{	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST'))
		{
			$this->settings->stad = $this->request->post('stad');
			$this->settings->stad_round = $this->request->post('stad_round');
			$this->settings->b11manage = $this->request->post('b11manage');
			$this->settings->b12manage = $this->request->post('b12manage');
			$this->settings->b13manage = $this->request->post('b13manage');
			$this->settings->b14manage = $this->request->post('b14manage');

			$this->settings->stadfrom = $this->request->post('stadfrom');
			$this->settings->stadto = $this->request->post('stadto');

			if ($this->request->post('stadtime')>15) {
				$this->settings->stadtime = $this->request->post('stadtime');
			} else {
				$this->settings->stadtime = 15;
			}

			if ($this->request->post('hexstadcolor')) {
				list($r, $g, $b) = sscanf($this->request->post('hexstadcolor'), "%2x%2x%2x");
				$this->settings->stadcolor = 'rgba('.$r.', '.$g.', '.$b.', 0.8)';
			}

			$this->design->assign('message_success', 'saved');
		}

 	  	return $this->design->fetch('stad.tpl');
	}
	
}

