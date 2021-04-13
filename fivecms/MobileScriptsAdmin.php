<?PHP
require_once('api/Fivecms.php');

class MobileScriptsAdmin extends Fivecms
{	
	public function fetch()
	{
		$scripts_dir = 'design/mobile/js/';
		$scripts = array();
		
		// Порядок файлов в меню
		$sort = array('core.js');
		
		// Читаем все js-файлы
		if($handle = opendir($scripts_dir)) {
			$i = count($sort);
			while(false !== ($file = readdir($handle)))
			{
				if(is_file($scripts_dir.$file) && $file[0] != '.'  && pathinfo($file, PATHINFO_EXTENSION) == 'js')
				{
					if(($key = array_search($file, $sort)) !== false)
						$scripts[$key] = $file; 
					else
						$scripts[$i++] = $file; 
        		} 
		    }
			closedir($handle); 
		}
		ksort($scripts);
		
		// Текущий скрипт
		$script_file = $this->request->get('file');
		
		if(!empty($script_file) && pathinfo($script_file, PATHINFO_EXTENSION) != 'js')
			exit();
		
		// Если не указан - вспоминаем его из сессии
		if(empty($script_file) && !empty($_SESSION['last_edited_mobscript']))
			$script_file = $_SESSION['last_edited_mobscript'];
		// Иначе берем первый файл из списка
		elseif(empty($script_file))
			$script_file = reset($scripts);
		
		// Передаем имя скрипта в дизайн
		$this->design->assign('script_file', $script_file);		
		
		// Если можем прочитать файл - передаем содержимое в дизайн
		if(is_readable($scripts_dir.$script_file))
		{
			$script_content = file_get_contents($scripts_dir.$script_file);			
			$this->design->assign('script_content', $script_content);
		}
		
		// Если нет прав на запись - передаем в дизайн предупреждение
		if(!empty($script_file) && !is_writable($scripts_dir.$script_file) && !is_file($scripts_dir.'../locked'))
		{
			$this->design->assign('message_error', 'permissions');
		}
		elseif(is_file($scripts_dir.'../locked'))
		{
			$this->design->assign('message_error', 'theme_locked');
		}
		else
		{
			// Запоминаем в сессии имя редактируемого скрипта
			$_SESSION['last_edited_mobscript'] = $script_file;		
		}
		
		$this->design->assign('theme', 'mobile');
		$this->design->assign('scripts', $scripts);
  	  	return $this->design->fetch('mobile_scripts.tpl');
	}
	
}

