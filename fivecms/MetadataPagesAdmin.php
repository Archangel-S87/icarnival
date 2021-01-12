<?PHP

require_once('api/Fivecms.php');

class MetadataPagesAdmin extends Fivecms
{
	function fetch()
	{

		// Обработка действий 	
		if($this->request->method('post'))
		{

			$this->settings->redirect = $this->request->post('redirect');

			// Действия с выбранными
			$ids = $this->request->post('check');

			if(is_array($ids))
			switch($this->request->post('action'))
			{
				case 'delete':
				{
					foreach($ids as $id)
						$this->metadatapages->delete_metadata_page($id);    
                                        break;
				}
			}
		}	
		$filter = array();
		
		
		// Все линии
		$metadata_pages = $this->metadatapages->get_metadata_pages($filter);
		$this->design->assign('metadata_pages', $metadata_pages);

		return $this->body = $this->design->fetch('metadata_pages.tpl');
	}
}

