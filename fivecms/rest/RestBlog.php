<?php

/**
 * 5CMS
 *
 * @link		http://5cms.ru
 *
 */
 
require_once('Rest.php');

class RestBlog extends Rest
{	
	public function __construct()
	{		
		parent::__construct();
		if(!$this->managers->access('blog'))
		{
			header('HTTP/1.1 401 Unauthorized');
			exit();
		}
	}
	
	public function fetch()
	{
		if($this->request->method('GET'))
			$result = $this->get();
		if($this->request->method('POST'))
			$result = $this->post();
		if($this->request->method('PUT'))
			$result = $this->put();
		if($this->request->method('DELETE'))
			$result = $this->delete();
			
		return $this->indent(json_encode($result));
	}

	public function get()
	{
		$fields = explode(',', $this->request->get('fields'));
		
		$ids = array();
		foreach(explode(',', $this->request->get('id')) as $id)
			if(($id = intval($id))>0)
				$ids[] = $id;
		
		$filter = array();
		if(!empty($ids))
			$filter['id'] = $ids;

		$filter['sort'] = $this->request->get('sort');
		$filter['category_id'] = $this->request->get('category');
		$filter['page'] = $this->request->get('page');
		$filter['limit'] = $this->request->get('limit');
		
		$posts = array();
		foreach($this->blog->get_posts($filter) as $p)
		{
			$posts[$p->id] = null;
			if($this->request->get('fields'))
			foreach($fields as $field)
			{
				if(isset($p->$field))
				$posts[$p->id]->$field = $p->$field;
			}
			else
				$posts[$p->id] = $p;
		}
		
		$posts_ids = array_keys($posts);

		if($join = $this->request->get('join'))
		{
			$join = explode(',', $join);
			if(in_array('images', $join))
			{
				foreach($this->blog->get_images(array('post_id'=>$posts_ids)) as $i)
					if(isset($posts[$i->post_id]))
					{
						$posts[$i->post_id]->images[$i->id] = $i;
					}
			}					
		}
		return $posts;
	}
	
	public function post()
	{
	
		if($this->request->method('POST'))
		{
			$post = json_decode($this->request->post());
	
			$id = $this->blog->add_post($post);
	
			if(!$id)
				return false;	
		}
		
		header("Content-type: application/json");		
		header("Location: ".$this->config->root_url."/fivecms/rest/blog/".$id, true, 201);
	}

	// Создать товар
	public function put()
	{		
 
	}

}

