<?php

require_once('../../api/Fivecms.php');

class ExportAjax extends Fivecms
{	
	private $columns_names = array(
			'name'=>             'name',
			'email'=>            'email'
			);
			
	private $column_delimiter = ';';
	private $users_count = 10;
	private $export_files_dir = '../files/export_users/';
	private $filename = 'subscribers.csv';

	public function fetch()
	{
		if(!$this->managers->access('mailuser'))
			return false;
	
		// Эксель кушает только 1251
		//setlocale(LC_ALL, 'ru_RU.1251');
		//$this->db->query('SET NAMES cp1251');
	
		// Страница, которую экспортируем
		$page = $this->request->get('page');
		if(empty($page) || $page==1)
		{
			$page = 1;
			// Если начали сначала - удалим старый файл экспорта
			if(is_writable($this->export_files_dir.$this->filename))
				unlink($this->export_files_dir.$this->filename);
		}
		
		// Открываем файл экспорта на добавление
		$f = fopen($this->export_files_dir.$this->filename, 'ab');
				
		// Если начали сначала - добавим в первую строку названия колонок
		if($page == 1)
		{
			fputcsv($f, $this->columns_names, $this->column_delimiter);
		}
		
		$filter = array();
		$filter['page'] = $page;
		$filter['limit'] = $this->users_count;
		
		// Выбираем пользователей
		$users = array();
 		foreach($this->mailer->get_maillist($filter) as $u)
 		{
 			$str = array();
 			foreach($this->columns_names as $n=>$c)
 				$str[] = $u->$n;
 				
 			fputcsv($f, $str, $this->column_delimiter);
 		}
 		
		$total_users = $this->users->count_users();
		
		if($this->users_count*$page < $total_users)
			return array('end'=>false, 'page'=>$page, 'totalpages'=>$total_users/$this->users_count);
		else
			return array('end'=>true, 'page'=>$page, 'totalpages'=>$total_users/$this->users_count);		

		fclose($f);

	}
	
}

$export_ajax = new ExportAjax();
$json = json_encode($export_ajax->fetch());
header("Content-type: application/json; charset=utf-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");		
print $json;