<?php

require_once('api/Fivecms.php');

class FormAdmin extends Fivecms
{

  function fetch()
  {
  		$form = new \stdClass();
		if($this->request->method('post'))
		{
			$form->id = $this->request->post('id', 'integer');
			$form->name = $this->request->post('name');
			if($this->request->post('description'))
				$form->description = $this->request->post('description');
			$form->url = $this->request->post('url');
			$form->button = $this->request->post('button');

				if(empty($form->id))
				{
	  				$form->id = $this->forms->add_form($form);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->forms->update_form($form->id, $form);
					$this->design->assign('message_success', 'updated');
  	    		}	
  	    		
	  			$form = $this->forms->get_form($form->id);
			
		}
		else
		{
			$form->id = $this->request->get('id', 'integer');
			$form = $this->forms->get_form($form->id);
		}
		
 		$this->design->assign('form', $form);
		return  $this->design->fetch('form.tpl');
	}
}