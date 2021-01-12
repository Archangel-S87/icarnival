<?PHP
require_once('api/Fivecms.php');

class LicenseAdmin extends Fivecms
{	

	public function fetch()
	{

		if($this->request->method('POST'))
		{
			$license = $this->request->post('license');
			$this->config->license = trim($license);
		}

		$key = $this->config->license;
		
		$kdata = $key;
		$skey = 12;
		$res = '';
		$sBase64 = strtr($kdata, '-_', '+/');
		$kdata = base64_decode($sBase64.'==');
			
		for($i=0;$i<strlen($kdata);$i++){
				$char    = substr($kdata, $i, 1);
				$kchar = substr($skey, ($i % strlen($skey)) - 1, 1);
				$char    = chr(ord($char) - ord($kchar));
				$res .= $char;
		}
		$r = $res;

		@list($l->domain, $l->expiration) = explode('#', $r, 2);
		
		$h = getenv("HTTP_HOST");
		if(substr($h, 0, 4) == 'www.') 
			$h = substr($h, 4);
			
		$l->valid = true;
		if(empty($r) || $h != $l->domain)
			$l->valid = false;
		if($l->expiration<time() && $l->expiration!='*')
			$l->valid = false;
		
		$this->design->assign('license', $l);
		
 	  	return $this->design->fetch('license.tpl');
	}
	
}
