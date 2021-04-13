<?PHP
require_once('api/Fivecms.php');

class ImportImagesAdmin extends Fivecms
{	
	public function fetch()
	{
		if($this->request->method('post'))
        {
        	$images_num = $this->request->post('images_num');
        	if(!empty($images_num))
        		$this->design->assign('images_num', $images_num);
        }
		
		return $this->design->fetch('import_images.tpl');
	}
}

