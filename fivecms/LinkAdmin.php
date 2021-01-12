<?PHP
require_once('api/Fivecms.php');

class LinkAdmin extends Fivecms
{	
	public function fetch()
	{	
		$link = new stdClass;
		if($this->request->method('POST'))
		{
			$link->id = $this->request->post('id', 'integer');
			$link->name = $this->request->post('name');
			$link->h1 = $this->request->post('h1');
			$link->url = trim($this->request->post('url'));
			$link->meta_title = $this->request->post('meta_title');
			$link->meta_keywords = $this->request->post('meta_keywords');
			$link->meta_description = $this->request->post('meta_description');
			$link->src_url = $this->request->post('src_url');
			$link->description = $this->request->post('description');
			$link->seo = $this->request->post('seo');

			$link->visible = $this->request->post('visible', 'boolean');
	
			## Не допустить одинаковые URL разделов.
			if(($p = $this->links->get_link($link->url)) && $p->id!=$link->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($link->id))
				{
	  				$link->id = $this->links->add_link($link);
	  				$link = $this->links->get_link($link->id);
	  				$this->design->assign('message_success', 'added');
  	    		}
  	    		else
  	    		{
  	    			$this->links->update_link($link->id, $link);
	  				$link = $this->links->get_link($link->id);
	  				$this->design->assign('message_success', 'updated');
   	    		}
			}
		}
		else
		{
			$id = $this->request->get('id', 'integer');
			if(!empty($id))
				$link = $this->links->get_link(intval($id));			
			else
			{

				$link->visible = 1;
			}
		}	

		$this->design->assign('link', $link);
		
 	  	$menus = $this->pages->get_menus();
		$this->design->assign('menus', $menus);
		
 	  	return $this->design->fetch('link.tpl');
	}
	
}

