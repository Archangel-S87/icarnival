<?php

require_once('Fivecms.php');

class BlogCategories extends Fivecms
{

	public function get_category($id)
	{
		if(is_int($id)){
			$where = $this->db->placehold(' WHERE c.id=? ', intval($id));
		}
		else{
			$where = $this->db->placehold(' WHERE c.url=? ', (string)$id);
		}
		
		$query = $this->db->placehold("SELECT * FROM __blog_categories c $where LIMIT 1");
		if($this->db->query($query))
			return $this->db->result();
		else
			return false; 
	}

	public function get_categories($filter = array())
	{	
		// По умолчанию
		$categorys = array();
		$visible_filter = '';
		
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND c.visible = ?', intval($filter['visible']));	

		$query = $this->db->placehold("SELECT * FROM __blog_categories c WHERE 1 $visible_filter ORDER BY position");
		
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function add_category($category)
	{	
		$query = $this->db->placehold("INSERT INTO __blog_categories SET ?%", $category);
		
		if(!$this->db->query($query))
			return false;
		else {
			$id = $this->db->insert_id();
			$this->db->query("UPDATE __blog_categories SET position=id WHERE id=?", $id);			
			return $id;
		}
	}
	
	/*
	*
	* Обновить категорию
	* @param $category
	*
	*/	
	public function update_category($id, $category)
	{
		$query = $this->db->placehold("UPDATE __blog_categories SET ?% , last_modify=NOW() WHERE id=? LIMIT 1", $category, intval($id));
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Удалить категорию
	* @param $id
	*
	*/	
	public function delete_category($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __blog_categories WHERE id=? LIMIT 1", intval($id));		
			if($this->db->query($query))
				return true;					
		}
		return false;
	}
	
	/*
	*
	* Удалить изображение категории
	* @param $id
	*
	*/	
	public function delete_image($category_id)
	{
		$query = $this->db->placehold("SELECT image FROM __blog_categories WHERE id=?", $category_id);
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __blog_categories SET image=NULL WHERE id=?", $category_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __blog_categories WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
			{			
				@unlink($this->config->root_dir.$this->config->blog_categories_images_dir.$filename);		
			}
		}
	}
	
}
