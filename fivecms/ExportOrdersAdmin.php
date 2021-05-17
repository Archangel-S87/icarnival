<?PHP
require_once('api/Fivecms.php');

class ExportOrdersAdmin extends Fivecms
{	
	private $export_files_dir = 'fivecms/files/export_orders/';

	public function fetch()
	{
		$this->design->assign('export_files_dir', $this->export_files_dir);
		if(!is_writable($this->export_files_dir))
			$this->design->assign('message_error', 'no_permission');
  	  	return $this->design->fetch('export_orders.tpl');
	}
	
}

