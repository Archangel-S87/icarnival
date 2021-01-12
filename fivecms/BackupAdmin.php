<?PHP

define( 'PCLZIP_TEMPORARY_DIR', 'fivecms/files/backup/' );

require_once('api/Fivecms.php');
require_once('fivecms/pclzip/pclzip.lib.php');

class BackupAdmin extends Fivecms
{	
	public function fetch()
	{
		$dir = 'fivecms/files/backup/';
		// Обработка действий
		//upload file
		if($this->request->method('post') && ($this->request->files("file")))
		{
			$uploaded_file = $this->request->files("file", "tmp_name");
			$uploaded_name = $this->request->files("file", "name");

			if(!empty($uploaded_file) && in_array(pathinfo($uploaded_name, PATHINFO_EXTENSION), array('zip'))){
				if(@move_uploaded_file($uploaded_file, $this->config->root_dir.'fivecms/files/backup/'.$uploaded_name)){
					$this->design->assign('message_success', 'uploaded');
				} else {
					$this->design->assign('message_error', 'upload_error');
				}
			} else {
				$this->design->assign('message_error', 'upload_error');
			}
		}
		//upload file @	
		elseif($this->request->method('post'))
		{
			switch($this->request->post('action'))
			{
				case 'create':
				{
					$filename = $dir.'fivecms_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы	
					$this->db->dump($dir.'fivecms.sql');
					chmod($dir.'fivecms.sql', 0777);
					
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array('files', $dir.'fivecms.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');		
	
					break;
			    }
				case 'fast_create':
				{
					$filename = $dir.'db_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dump($dir.'db.sql');
					chmod($dir.'db.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'db.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'settings':
				{
					$filename = $dir.'settings_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dumpsetttings($dir.'settings.sql');
					chmod($dir.'settings.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'settings.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'texts':
				{
					$filename = $dir.'texts_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dumptexts($dir.'texts.sql');
					chmod($dir.'texts.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'texts.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'users':
				{
					$filename = $dir.'users_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dumpusers($dir.'users.sql');
					chmod($dir.'users.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'users.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'prices':
				{
					$filename = $dir.'prices_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dumpprices($dir.'prices.sql');
					chmod($dir.'prices.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'prices.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'orders':
				{
					$filename = $dir.'orders_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dumporders($dir.'orders.sql');
					chmod($dir.'orders.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'orders.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'products':
				{
					$filename = $dir.'products_sql_'.date("Y_m_d_G_i_s").'.zip';
					##Дамп базы 
					$this->db->dumpproducts($dir.'products.sql');
					chmod($dir.'products.sql', 0777);
					### Архивируем
					$zip = new PclZip($filename);
					$v_list = $zip->create(array($dir.'products.sql'), PCLZIP_OPT_REMOVE_PATH, $dir, PCLZIP_CB_PRE_ADD, "myCallBack");
					if ($v_list == 0)
					{
						trigger_error('Не могу заархивировать '.$zip->errorInfo(true));
					}
					$this->design->assign('message_success', 'created');      
					break;
				}
				case 'restore':
				{
					$name = $this->request->post('name');
					$archive = $dir.$name;
					$zip = new PclZip($archive);
					
					if (($list = $zip->listContent()) == 0) {
						trigger_error("Ошибка: ".$zip->errorInfo(true));
					}
					else {
						foreach($list as $f){
							//$extention = pathinfo($f['filename'], PATHINFO_EXTENSION);
							if(!empty($f['filename'])){					
								if(!$zip->extract(PCLZIP_OPT_PATH, $dir)){
									trigger_error('Не могу разархивировать '.$zip->errorInfo(true));
								} elseif (!is_readable($dir.$f['filename'])){
									trigger_error('Не могу прочитать файл fivecms/files/backup/'.$f['filename']);
								} else {
									$this->db->restore($dir.$f['filename']);
									unlink($dir.$f['filename']);
									$this->design->assign('message_success', 'restored'); 
								}    
								break;
							}
						}
	 				}
					break;
				}
			    case 'delete':
			    {
			    	$names = $this->request->post('check');
				    foreach($names as $name)
						unlink($dir.$name);   
			        break;
			    }
			}				
		}

		$backup_files = glob($dir."*.zip");
		$backups = array();
		if(is_array($backup_files))
		{
			foreach($backup_files as $backup_file)
			{	
				$backup = new stdClass;
				$backup->name = basename($backup_file);
				$backup->size = filesize($backup_file);
				$backups[] = $backup;
			}
		}
		$backups = array_reverse($backups);
		$this->design->assign('backup_files_dir', $dir);
		if(!is_writable($dir))
			$this->design->assign('message_error', 'no_permission');
			
		// считаем кол-во товаров
		$prod_count = $this->products->count_products();
		$this->design->assign('prod_count', $prod_count);
		// считаем кол-во товаров end	
		
		$this->design->assign('backups', $backups);
		return $this->design->fetch('backup.tpl');
	}
	
	private function clean_dir($path)
	{
	    $path= rtrim($path, '/').'/';
	    $handle = opendir($path);
	    for (;false !== ($file = readdir($handle));)
	        if($file != "." and $file != ".." )
	        {
	            $fullpath= $path.$file;
	            if( is_dir($fullpath) )
	            {
	                $this->clean_dir($fullpath);
	                rmdir($fullpath);
	            }
	            else
	              unlink($fullpath);
	        }
	    closedir($handle);
	}
}


function myPostExtractCallBack($p_event, &$p_header)
{
	// проверяем успешность распаковки
	if ($p_header['status'] == 'ok')
	{
		// Меняем права доступа
		@chmod($p_header['filename'], 0777);
	}
	return 1;
}

function myCallBack($p_event, &$p_header)
{
	$fname = $p_header['stored_filename'];
	if(preg_match('/^files\/products\/.+/i', $fname))
		return 0;
	return 1;
}
