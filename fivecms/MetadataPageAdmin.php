<?php

require_once('api/Fivecms.php');


############################################
# Class Category - Edit the good gategory
############################################
class MetadataPageAdmin extends Fivecms
{
  private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');

  function fetch()
  {
		if($this->request->method('post'))
		{
			$MetadataPage->id = $this->request->post('id', 'integer');
			//$MetadataPage->name = $this->request->post('name');
			$MetadataPage->description = $this->request->post('description');

			$MetadataPage->url = $this->request->post('url');
			if ($this->request->post('redirect')) $MetadataPage->redirect = $this->request->post('redirect');
			$MetadataPage->meta_title = $this->request->post('meta_title');
			$MetadataPage->meta_keywords = $this->request->post('meta_keywords');
			$MetadataPage->meta_description = $this->request->post('meta_description');
            $MetadataPage->h1_title = $this->request->post('h1_title');

			// Не допустить одинаковые URL разделов.
			if(($c = $this->metadatapages->get_metadata_page($MetadataPage->url)) && $c->id!=$MetadataPage->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($MetadataPage->id))
				{
	  				$MetadataPage->id = $this->metadatapages->add_metadata_page($MetadataPage);
					$this->design->assign('message_success', 'added');
	  			}
                                else
                                {
                                        $this->metadatapages->update_metadata_page($MetadataPage->id, $MetadataPage);
                                                $this->design->assign('message_success', 'updated');
                                }	
  	    		
	  			$MetadataPage = $this->metadatapages->get_metadata_page($MetadataPage->id);
			}
		}
		else
		{
			$MetadataPage->id = $this->request->get('id', 'integer');
			$MetadataPage = $this->metadatapages->get_metadata_page($MetadataPage->id);
		}

		
 		$this->design->assign('metadata_page', $MetadataPage);
		return  $this->design->fetch('metadata_page.tpl');
	}
}