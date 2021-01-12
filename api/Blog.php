<?php

require_once('Fivecms.php');

class Blog extends Fivecms
{

	/*
	*
	* Функция возвращает пост по его id или url
	* (в зависимости от типа аргумента, int - id, string - url)
	* @param $id id или url поста
	*
	*/
	public function get_post($id)
	{
		if(is_int($id))
			$where = $this->db->placehold(' WHERE b.id=? ', intval($id));
		else
			$where = $this->db->placehold(' WHERE b.url=? ', $id);
		
		$query = $this->db->placehold("SELECT * FROM __blog b $where LIMIT 1");
		if($this->db->query($query))
			return $this->db->result();
		else
			return false; 
	}
	
	/*
	*
	* Функция возвращает массив постов, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function get_posts($filter = array())
	{	
		// По умолчанию
		$limit = 1000;
		$page = 1;
		$post_id_filter = '';
		$visible_filter = '';
		$keyword_filter = '';
		$category_id_filter = '';
		$order = 'date DESC';
		
		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		if(!empty($filter['id']))
			$post_id_filter = $this->db->placehold('AND b.id in(?@)', (array)$filter['id']);
			
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));	
		
		if(isset($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND (b.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR b.meta_keywords LIKE "%'.$this->db->escape(trim($keyword)).'%" OR b.text LIKE "%'.$this->db->escape(trim($keyword)).'%") ');
		}
		
		if(!empty($filter['category_id']))
			$category_id_filter = $this->db->placehold('AND b.category in(?@)', (array)$filter['category_id']);
			
		if(!empty($filter['sort'])){
			switch ($filter['sort'])
			{
				case 'rand':
				$order = 'RAND()';
				break;
				case 'date':
				$order = 'date DESC';
				break;
			}
		}
			
		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

		$query = $this->db->placehold("SELECT * FROM __blog b WHERE 1 $category_id_filter $post_id_filter $visible_filter $keyword_filter ORDER BY $order, id DESC $sql_limit");
		
		if($this->settings->cached == 1 && empty($_SESSION['admin'])){
			if($result = $this->cache->get($query)) {
				return $result; // возвращаем данные из memcached
			} else {
				$this->db->query($query); // иначе тянем из БД
				$result=$this->db->results();
				$this->cache->set($query, $result); //помещаем в кеш
				return $result;
			}
		} else {
			$this->db->query($query);
			return $this->db->results();
		}   
	}
	
	/*
	*
	* Функция вычисляет количество постов, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function count_posts($filter = array())
	{	
		$post_id_filter = '';
		$visible_filter = '';
		$keyword_filter = '';
		$category_id_filter = '';
		
		if(!empty($filter['id']))
			$post_id_filter = $this->db->placehold('AND b.id in(?@)', (array)$filter['id']);
			
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));		

		if(isset($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND (b.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR b.meta_keywords LIKE "%'.$this->db->escape(trim($keyword)).'%" OR b.text LIKE "%'.$this->db->escape(trim($keyword)).'%") ');
		}
		
		if(!empty($filter['category_id']))
			$category_id_filter = $this->db->placehold('AND b.category in(?@)', (array)$filter['category_id']);
		
		$query = "SELECT COUNT(distinct b.id) as count
		          FROM __blog b WHERE 1 $category_id_filter $post_id_filter $visible_filter $keyword_filter";
			
		if($this->settings->cached == 1 && empty($_SESSION['admin'])){
			if($result = $this->cache->get($query)) {
				return $result; // возвращаем данные из memcached
			} else {
				if($this->db->query($query)){
					$result = $this->db->result('count');
					$this->cache->set($query, $result); //помещаем в кеш
					return $result;
				}	
				else
					return false;
			}	
		} else {
			if($this->db->query($query))
				return $this->db->result('count');
			else
				return false;
		}		
			
	}
	
	/*
	*
	* Создание поста
	* @param $post
	*
	*/	
	public function add_post($post)
	{	
		if(!isset($post->date))
			$date_query = ', date=NOW()';
		else
			$date_query = '';
		$query = $this->db->placehold("INSERT INTO __blog SET ?% $date_query", $post);
		
		if(!$this->db->query($query))
			return false;
		else
			return $this->db->insert_id();
	}
	
	
	/*
	*
	* Обновить пост(ы)
	* @param $post
	*
	*/	
	public function update_post($id, $post)
	{
		$query = $this->db->placehold("UPDATE __blog SET ?% , last_modify=NOW() WHERE id in(?@) LIMIT ?", $post, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Удалить пост
	* @param $id
	*
	*/	
	public function delete_post($id)
	{
		if(!empty($id))
		{

			$images = $this->get_images(array('post_id'=>$id));
			foreach($images as $i)
				$this->delete_image($i->id);

			$query = $this->db->placehold("DELETE FROM __blog WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
			{
				$query = $this->db->placehold("DELETE FROM __comments WHERE type='blog' AND object_id=?", intval($id));
				if($this->db->query($query))
					return true;
			}
							
		}
		return false;
	}	
	
	function get_images($filter = array())
	{		
		$post_id_filter = '';
		$group_by = '';

		if(!empty($filter['post_id']))
			$post_id_filter = $this->db->placehold('AND i.post_id in(?@)', (array)$filter['post_id']);

		// images
		$query = $this->db->placehold("SELECT * FROM __images_post AS i WHERE 1 $post_id_filter $group_by ORDER BY i.post_id, i.position");
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function add_image($post_id, $filename, $name = '')
	{
		$query = $this->db->placehold("SELECT id FROM __images_post WHERE post_id=? AND filename=?", $post_id, $filename);
		$this->db->query($query);
		$id = $this->db->result('id');
		if(empty($id))
		{
			$query = $this->db->placehold("INSERT INTO __images_post SET post_id=?, filename=?", $post_id, $filename);
			$this->db->query($query);
			$id = $this->db->insert_id();
			$query = $this->db->placehold("UPDATE __images_post SET position=id WHERE id=?", $id);
			$this->db->query($query);
		}
		return($id);
	}
	
	public function update_image($id, $image)
	{
	
		$query = $this->db->placehold("UPDATE __images_post SET ?% WHERE id=?", $image, $id);
		$this->db->query($query);
		
		return($id);
	}
	
	public function delete_image($id)
	{
		$query = $this->db->placehold("SELECT filename FROM __images_post WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('filename');
		$query = $this->db->placehold("DELETE FROM __images_post WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		$query = $this->db->placehold("SELECT count(*) as count FROM __images_post WHERE filename=? LIMIT 1", $filename);
		$this->db->query($query);
		$count = $this->db->result('count');
		if($count == 0)
		{			
			$file = pathinfo($filename, PATHINFO_FILENAME);
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
			
			$rezised_images = glob($this->config->root_dir.$this->config->resized_blog_images_dir.$file."*.".$ext);
			if(is_array($rezised_images))
			foreach (glob($this->config->root_dir.$this->config->resized_blog_images_dir.$file."*.".$ext) as $f)
				@unlink($f);

			@unlink($this->config->root_dir.$this->config->original_blog_images_dir.$filename);		
		}
	}

	/*
	*
	* Следующий пост
	* @param $post
	*
	*/	
	public function get_next_post($id)
	{
		$this->db->query("SELECT date FROM __blog WHERE id=? LIMIT 1", $id);
		$date = $this->db->result('date');

		$this->db->query("(SELECT id FROM __blog WHERE date=? AND id>? AND visible  ORDER BY id limit 1)
		                   UNION
		                  (SELECT id FROM __blog WHERE date>? AND visible ORDER BY date, id limit 1)",
		                  $date, $id, $date);
		$next_id = $this->db->result('id');
		if($next_id)
			return $this->get_post(intval($next_id));
		else
			return false; 
	}
	
	/*
	*
	* Предыдущий пост
	* @param $post
	*
	*/	
	public function get_prev_post($id)
	{
		$this->db->query("SELECT date FROM __blog WHERE id=? LIMIT 1", $id);
		$date = $this->db->result('date');

		$this->db->query("(SELECT id FROM __blog WHERE date=? AND id<? AND visible ORDER BY id DESC limit 1)
		                   UNION
		                  (SELECT id FROM __blog WHERE date<? AND visible ORDER BY date DESC, id DESC limit 1)",
		                  $date, $id, $date);
		                  
		// если нужна выборка в пределах категории поста
		/*$this->db->query("SELECT category FROM __blog WHERE id=? LIMIT 1", $id);
		$category = $this->db->result('category');

		$this->db->query("(SELECT id FROM __blog WHERE date=? AND id<? AND visible AND category=? ORDER BY id DESC limit 1)
		                   UNION
		                  (SELECT id FROM __blog WHERE date<? AND visible AND category=? ORDER BY date DESC, id DESC limit 1)",
		                  $date, $id, $category, $date, $category);*/               
		                  
		                  
		$prev_id = $this->db->result('id');
		if($prev_id)
			return $this->get_post(intval($prev_id));
		else
			return false; 
	}
	
	/*
    *
    * Добавляем теги
    *
    */    
    public function add_tags($type, $object_id, $values)
    {     
        $tags = explode(',', $values);
        foreach($tags as $value) 
        {
            $query = $this->db->placehold("INSERT IGNORE INTO __tags SET type=?, object_id=?, value=?", $type, intval($object_id), $value);
            $this->db->query($query);   
        }
        return count($tags);
    }
    
    /*
    *
    * Удаляем все теги
    *
    */    
    public function delete_tags($type, $object_id)
    {
        $query = $this->db->placehold("DELETE FROM __tags WHERE type=? AND object_id=?", $type, intval($object_id));
        $this->db->query($query);
    }
    
    /*
    *
    * Получаем список тегов
    *
    */        
    public function get_tags($filter = array())
    {
        $type_filter = '';
        $object_id_filter = '';
        $keyword_filter = '';
        $group = '';

        if(isset($filter['group']))
            $group = 'GROUP BY value';

        if(isset($filter['type']))
            $type_filter = $this->db->placehold('AND type=?', $filter['type']);

        if(isset($filter['object_id']))
            $object_id_filter = $this->db->placehold('AND object_id in(?@)', (array)$filter['object_id']);

        if(!empty($filter['keyword']))
        {
            $keywords = explode(',', $filter['keyword']);
            foreach($keywords as $keyword)
            {
                $kw = $this->db->escape(trim($keyword));
                $keyword_filter .= " AND value LIKE '%$kw%'";
            }
        }

        $query = $this->db->placehold("SELECT type, object_id, value FROM __tags WHERE 1 $object_id_filter $type_filter $keyword_filter $group ORDER BY value");

        $this->db->query($query);
        $res = $this->db->results();
        return $res;
        
        if($this->settings->cached == 1 && empty($_SESSION['admin'])){
			if($res = $this->cache->get($query)) {
				return $res; // возвращаем данные из memcached
			} else {
				$this->db->query($query); // иначе тянем из БД
				$res = $this->db->results();
				$this->cache->set($query, $res); //помещаем в кеш
				return $res;
			}
		} else {
			$this->db->query($query);
			$res = $this->db->results();
        	return $res;
		}   
    }
    
    /*
    * Вносит +1 к просмотру поста
    * @param $id
	* @retval object
	*/
	public function update_views($id)
	{
		if(!isset($_SESSION['blog_ids'])) 
		 	$_SESSION['blog_ids'] = array();
        
        if(!in_array($id, $_SESSION['blog_ids'])){
			$this->db->query("UPDATE __blog SET views=views+1 WHERE id=?", $id);
			$_SESSION['blog_ids'][] = $id;
		}
		return true;
	}
 
}
