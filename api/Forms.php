<?php

require_once('Fivecms.php');

class forms extends Fivecms
{
	/*
	*
	* Функция возвращает массив форм
	*
	*/
	/*public function get_forms()
	{
		$forms = array();
		
		// Выбираем все формы
		$query = $this->db->placehold("SELECT DISTINCT id, name, visible, url, description, button
								 		FROM __forms ORDER BY id");
		$this->db->query($query);

		return $this->db->results();
	}*/

	public function get_forms($filter = array())
	{
		$visible_filter = '';
		$url_filter = '';
		$forms = array();
		
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND visible = ?', intval($filter['visible']));
			
		if(isset($filter['url']))
			$url_filter = $this->db->placehold('AND (url=? OR url="")', $filter['url']);
			
		$query = "SELECT * FROM __forms WHERE 1 $visible_filter $url_filter ORDER BY id";	
					
		$this->db->query($query);

		return $this->db->results();
	}

	/*
	*
	* Функция возвращает форму по id или url
	*
	*/
	public function get_form($id)
	{
		if(is_int($id))			
			$filter = $this->db->placehold('id = ?', $id);
		else
			$filter = $this->db->placehold('url = ?', $id);
		$query = "SELECT * FROM __forms WHERE $filter ORDER BY id LIMIT 1";
		$this->db->query($query);
		return $this->db->result();
	}

	/*
	*
	* Добавление формы
	*
	*/
	public function add_form($form)
	{
		$query = $this->db->placehold("INSERT INTO __forms SET ?%", $form);
		$this->db->query($query);
		$id = $this->db->insert_id();
		$query = $this->db->placehold("UPDATE __forms WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Обновление формы(м)
	*
	*/		
	public function update_form($id, $form)
	{
		$query = $this->db->placehold("UPDATE __forms SET ?% WHERE id in(?@) LIMIT ?", (array)$form, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}
	
	/*
	*
	* Удаление формы
	*
	*/	
	public function delete_form($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __forms WHERE id=? LIMIT 1", $id);
			$this->db->query($query);		
		}
	}

}