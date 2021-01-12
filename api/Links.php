<?php

require_once('Fivecms.php');

class Links extends Fivecms
{

	/*
	*
	* Функция возвращает страницу по ее id или url (в зависимости от типа)
	* @param $id id или url страницы
	*
	*/
	public function get_link($id)
	{
		if(gettype($id) == 'string')
			$where = $this->db->placehold(' WHERE url=? ', $id);
		else
			$where = $this->db->placehold(' WHERE id=? ', intval($id));
		
		$query = "SELECT *
		          FROM __links $where LIMIT 1";

		$this->db->query($query);
		return $this->db->result();
	}
	
	/*
	*
	* Функция возвращает массив страниц, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function get_links($filter = array())
	{	
		$limit = 100;
		$page = 1;

		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		$visible_filter = '';

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND visible = ?', intval($filter['visible']));
		
		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

		$query = $this->db->placehold("SELECT *
		          FROM __links WHERE 1 $visible_filter ORDER BY position $sql_limit");
	
		$this->db->query($query);
		
		$links = array();
		foreach($this->db->results() as $link)
			$links[$link->id] = $link;
			
		return $links;
	}

	function count_links($filter = array())
	{
		$visible_filter = '';

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND visible = ?', intval($filter['visible']));
		
		$query = $this->db->placehold("SELECT count(*) as count FROM __links
										WHERE 1 $visible_filter");
		$this->db->query($query);
		return $this->db->result('count');
	}
		
	public function add_link($link)
	{	
		$query = $this->db->placehold('INSERT INTO __links SET ?%', $link);
		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
		$this->db->query("UPDATE __links SET position=id WHERE id=?", $id);	
		return $id;
	}
	
	public function update_link($id, $link)
	{	
		$query = $this->db->placehold('UPDATE __links SET ?% WHERE id in (?@)', $link, (array)$id);
		if(!$this->db->query($query))
			return false;
		return $id;
	}
	
	public function delete_link($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __links WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
				return true;
		}
		return false;
	}	
	
}
