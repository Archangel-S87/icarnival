<?php
session_start();
require_once('../../api/Fivecms.php');

class RoundAjax extends Fivecms
{	
	
	public function import()
	{
		if(!$this->managers->access('currency'))
			return false;
			
		$currency_id = $this->request->get('currency_id');
		$base_currency = $this->request->get('base_currency');

		if(isset($currency_id)){
			$query = $this->db2->placehold("UPDATE __variants SET price=round(price) WHERE currency_id = ?", intval($currency_id));
			$this->db->query($query);
		}
		
		if(!empty($base_currency)){
			$query = $this->db2->placehold("UPDATE __variants SET price=round(price) WHERE currency_id = 0");
			$this->db->query($query);
		}
		return 'ok';
	}
	
}

$round_ajax = new RoundAjax();
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		
		
$json = json_encode($round_ajax->import());
print $json;
