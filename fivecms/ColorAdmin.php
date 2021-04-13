<?PHP
require_once('api/Fivecms.php');

class ColorAdmin extends Fivecms
{	
	public function fetch()
	{	
		if($this->request->method('POST'))
		{
			$this->settings->colortheme = $this->request->post('colortheme');
			
			$this->design->assign('message_success', 'saved');
		}

 	  	return $this->design->fetch('color.tpl');
	}
	
}

