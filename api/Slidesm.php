<?php

require_once('Fivecms.php');

class slidesm extends Fivecms
{
	/*
	*
	* Функция возвращает массив слайдов
	*
	*/
	public function get_slidesm($filter = array())
	{
		$visible_filter = '';
		$slidesm = array();
			
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND visible = ?', intval($filter['visible']));
		
		// Выбираем слайды
		$query = $this->db->placehold("SELECT * FROM __slidesm WHERE 1 $visible_filter ORDER BY position");
		$this->db->query($query);

		return $this->db->results();
	}

	/*
	*
	* Функция возвращает слайд по его id или url
	*
	*/
	public function get_slidem($id)
	{
		if(is_int($id))			
			$filter = $this->db->placehold('id = ?', $id);
		else
			$filter = $this->db->placehold('url = ?', $id);
		$query = "SELECT id, name, visible, url, description, image, position
								 FROM __slidesm WHERE $filter ORDER BY position LIMIT 1";
		$this->db->query($query);
		return $this->db->result();
	}

	/*
	*
	* Добавление слайда
	*
	*/
	public function add_slidem($slidem)
	{
		$query = $this->db->placehold("INSERT INTO __slidesm SET ?%", $slidem);
		$this->db->query($query);
		$id = $this->db->insert_id();
		$query = $this->db->placehold("UPDATE __slidesm SET position=id WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Обновление слайда(ов)
	*
	*/		
	public function update_slidem($id, $slidem)
	{
		$query = $this->db->placehold("UPDATE __slidesm SET ?% WHERE id in(?@) LIMIT ?", (array)$slidem, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}
	
	/*
	*
	* Удаление слайда
	*
	*/	
	public function delete_slidem($id)
	{
		if(!empty($id))
		{
			$this->delete_image($id);	
			$query = $this->db->placehold("DELETE FROM __slidesm WHERE id=? LIMIT 1", $id);
			$this->db->query($query);		
		}
	}
	
	/*
	*
	* Удаление изображения слайда
	*
	*/
	public function delete_image($slidem_id)
	{
		$query = $this->db->placehold("SELECT image FROM __slidesm WHERE id=?", intval($slidem_id));
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __slidesm SET image=NULL WHERE id=?", $slidem_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __slidesm WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
			{			
				@unlink($this->config->root_dir.$filename);		
			}
		}
	}

}