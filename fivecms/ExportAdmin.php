<?PHP
require_once('api/Fivecms.php');

class ExportAdmin extends Fivecms
{	
	private $export_files_dir = 'fivecms/files/export/';

	public function fetch()
	{
		$categories = $this->categories->get_categories_tree();
		$this->design->assign('categories', $categories);
		
		$brands = $this->brands->get_brands();
		$this->design->assign('brands', $brands);
		
		$this->design->assign('export_files_dir', $this->export_files_dir);
		if(!is_writable($this->export_files_dir))
			$this->design->assign('message_error', 'no_permission');
  	  	return $this->design->fetch('export.tpl');
	}
	
}

