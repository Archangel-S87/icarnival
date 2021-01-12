<?php

require_once('Fivecms.php');

class Articles extends Fivecms
{

	/*
	*
	* Функция возвращает пост по его id или url
	* (в зависимости от типа аргумента, int - id, string - url)
	* @param $id id или url поста
	*
	*/
	public function get_article($id)
	{
		if(is_int($id))
			$where = $this->db->placehold(' WHERE b.id=? ', intval($id));
		else
			$where = $this->db->placehold(' WHERE b.url=? ', $id);
		
		$query = $this->db->placehold("SELECT * FROM __articles b $where LIMIT 1");
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
	public function get_articles($filter = array())
	{	
		// По умолчанию
		$limit = 1000;
		$page = 1;
		$post_id_filter = '';
		$category_id_filter = '';
		$visible_filter = '';
		$keyword_filter = '';
		$order = 'b.position DESC';
		$posts = array();
		
		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		if(!empty($filter['id']))
			$post_id_filter = $this->db->placehold('AND b.id in(?@)', (array)$filter['id']);
			
		if(!empty($filter['category_id']))
		{
			$category_id_filter = $this->db->placehold('AND b.category_id in(?@)', (array)$filter['category_id']);
		}			
			
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));
      
 		if(!empty($filter['sort']))
			switch ($filter['sort'])
			{
				case 'position':
				$order = 'b.position DESC';
				break;
				case 'name':
				$order = 'b.name';
				break;
				case 'date':
				$order = 'b.date DESC,b.id DESC';
				break;
				case 'rand':
				$order = 'RAND()';
				break;
			}       		
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				if($kw!=='')
					$keyword_filter .= $this->db->placehold("AND (b.name LIKE '%$kw%' OR b.text LIKE '%$kw%')");
			}
		}

		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

		$query = $this->db->placehold("SELECT * FROM __articles b WHERE 1 $post_id_filter $category_id_filter $visible_filter $keyword_filter ORDER BY $order $sql_limit");
		
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
	public function count_articles($filter = array())
	{	
		$post_id_filter = '';
		$category_id_filter = '';
		$visible_filter = '';
		$keyword_filter = '';
		
		if(!empty($filter['id']))
			$post_id_filter = $this->db->placehold('AND b.id in(?@)', (array)$filter['id']);
			
		if(!empty($filter['category_id']))
		{
			$category_id_filter = $this->db->placehold('AND b.category_id in(?@)', (array)$filter['category_id']);
		}			
			
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));     		

		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				if($kw!=='')
					$keyword_filter .= $this->db->placehold("AND (b.name LIKE '%$kw%' OR b.text LIKE '%$kw%')");
			}
		}
		
		$query = "SELECT COUNT(distinct b.id) as count
		          FROM __articles b WHERE 1 $post_id_filter $category_id_filter $visible_filter $keyword_filter";
			
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
	public function add_article($post)
	{	
		if(!isset($post->date))
			$date_query = ', date=NOW()';
		else
			$date_query = '';
		$this->db->query($this->db->placehold("INSERT INTO __articles SET ?% $date_query", $post));
		$id = $this->db->insert_id();
		
		// обновляем last_modify у категории 
		$this->db->query("SELECT category_id FROM __articles WHERE id=? LIMIT 1", $id);
		$category_id = $this->db->result('category_id');
		$this->db->query("UPDATE __articles_categories SET last_modify=NOW() WHERE id=? LIMIT 1", intval($category_id));
		// обновляем last_modify у категории end
		
		$this->db->query("UPDATE __articles SET position=id WHERE id=?", $id);		
		return $id;
	}
	
	/*
	*
	* Обновить пост(ы)
	* @param $post
	*
	*/	
	public function update_article($id, $post)
	{
		$query = $this->db->placehold("UPDATE __articles SET ?% , last_modify=NOW() WHERE id in(?@) LIMIT ?", $post, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Удалить пост
	* @param $id
	*
	*/	
	public function delete_article($id)
	{
		if(!empty($id))
		{
			$images = $this->get_images(array('post_id'=>$id));
			foreach($images as $i)
				$this->delete_image($i->id);

			$query = $this->db->placehold("DELETE FROM __articles WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
			{
				$query = $this->db->placehold("DELETE FROM __comments WHERE type='article' AND object_id=? LIMIT 1", intval($id));
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
		$query = $this->db->placehold("SELECT * FROM __images_article AS i WHERE 1 $post_id_filter $group_by ORDER BY i.post_id, i.position");
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function add_image($post_id, $filename, $name = '')
	{
		$query = $this->db->placehold("SELECT id FROM __images_article WHERE post_id=? AND filename=?", $post_id, $filename);
		$this->db->query($query);
		$id = $this->db->result('id');
		if(empty($id))
		{
			$query = $this->db->placehold("INSERT INTO __images_article SET post_id=?, filename=?", $post_id, $filename);
			$this->db->query($query);
			$id = $this->db->insert_id();
			$query = $this->db->placehold("UPDATE __images_article SET position=id WHERE id=?", $id);
			$this->db->query($query);
		}
		return($id);
	}
	
	public function update_image($id, $image)
	{
		$query = $this->db->placehold("UPDATE __images_article SET ?% WHERE id=?", $image, $id);
		$this->db->query($query);
		return($id);
	}
	
	public function delete_image($id)
	{
		$query = $this->db->placehold("SELECT filename FROM __images_article WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('filename');
		$query = $this->db->placehold("DELETE FROM __images_article WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		$query = $this->db->placehold("SELECT count(*) as count FROM __images_article WHERE filename=? LIMIT 1", $filename);
		$this->db->query($query);
		$count = $this->db->result('count');
		if($count == 0)
		{			
			$file = pathinfo($filename, PATHINFO_FILENAME);
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
			$rezised_images = glob($this->config->root_dir.$this->config->resized_articles_images_dir.$file."*.".$ext);
			if(is_array($rezised_images))
			foreach (glob($this->config->root_dir.$this->config->resized_articles_images_dir.$file."*.".$ext) as $f)
				@unlink($f);

			@unlink($this->config->root_dir.$this->config->original_articles_images_dir.$filename);		
		}
	}

	/*
	*
	* Следующий пост
	* @param $post
	*
	*/	
	public function get_next_article($id)
	{
		$this->db->query("SELECT date FROM __articles WHERE id=? LIMIT 1", $id);
		$date = $this->db->result('date');
		$this->db->query("SELECT category_id FROM __articles WHERE id=? LIMIT 1", $id);
		$category_id = $this->db->result('category_id');		

		$this->db->query("(SELECT id FROM __articles WHERE date=? AND id>? AND visible  ORDER BY id limit 1)
		                   UNION
		                  (SELECT id FROM __articles WHERE date>? AND category_id=? AND visible ORDER BY date, id limit 1)",
		                  $date, $id, $date, $category_id);
		$next_id = $this->db->result('id');
		if($next_id)
			return $this->get_article(intval($next_id));
		else
			return false; 
	}
	
	/*
	*
	* Предыдущий пост
	* @param $post
	*
	*/	
	public function get_prev_article($id)
	{
		$this->db->query("SELECT date FROM __articles WHERE id=? LIMIT 1", $id);
		$date = $this->db->result('date');
		$this->db->query("SELECT category_id FROM __articles WHERE id=? LIMIT 1", $id);
		$category_id = $this->db->result('category_id');		

		$this->db->query("(SELECT id FROM __articles WHERE date=? AND id<? AND visible ORDER BY id DESC limit 1)
		                   UNION
		                  (SELECT id FROM __articles WHERE date<? AND category_id=? AND visible ORDER BY date DESC, id DESC limit 1)",
		                  $date, $id, $date, $category_id);
		$prev_id = $this->db->result('id');
		if($prev_id)
			return $this->get_article(intval($prev_id));
		else
			return false; 
	}
	
	/*
    * Вносит +1 к просмотру поста
    * @param $id
	* @retval object
	*/
	public function update_views($id)
	{
		if(!isset($_SESSION['articles_ids'])) 
		 	$_SESSION['articles_ids'] = array();
        
        if(!in_array($id, $_SESSION['articles_ids'])){
			$this->db->query("UPDATE __articles SET views=views+1 WHERE id=?", $id);
			$_SESSION['articles_ids'][] = $id;
		}
		return true;
	}
}
