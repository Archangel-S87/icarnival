<?PHP
require_once('api/Fivecms.php');

/*
* Снятие прoверки на наличие лицeнзии является нарушением автopских прав 
* и преследуется по зaконaм РФ
* по всем вопросам обращайтесь к правoоблaдателю 5СMS
*/

class WarningAdmin extends Fivecms
{	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

 	  	return $this->design->fetch('warning.tpl');
	}
}

