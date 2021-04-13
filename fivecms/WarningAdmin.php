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
 	  	return $this->design->fetch('warning.tpl');
	}
}

