<?php

require_once('Fivecms.php');

class Pages extends Fivecms
{

	private $menus = array();
	private $menu;

	/*
	*
	* Функция возвращает страницу по ее id или url (в зависимости от типа)
	* @param $id id или url страницы
	*
	*/
	public function get_page($id)
	{
		if(gettype($id) == 'string')
			$where = $this->db->placehold(' WHERE url=? ', $id);
		else
			$where = $this->db->placehold(' WHERE id=? ', intval($id));
		
		$query = "SELECT * FROM __pages $where LIMIT 1";

		$this->db->query($query);
		return $this->db->result();
	}
	
	/*
	*
	* Функция возвращает массив страниц, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function get_pages($filter = array())
	{	
		$menu_filter = '';
		$visible_filter = '';
		$pages = array();

		if(isset($filter['menu_id']))
			$menu_filter = $this->db->placehold('AND menu_id in (?@)', (array)$filter['menu_id']);

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND visible = ?', intval($filter['visible']));
		
		$query = "SELECT * FROM __pages WHERE 1 $menu_filter $visible_filter ORDER BY position";
	
		$this->db->query($query);
		
		foreach($this->db->results() as $page)
			$pages[$page->id] = $page;
			
		return $pages;
	}

	/*
	*
	* Создание страницы
	*
	*/	
	public function add_page($page)
	{	
		$query = $this->db->placehold('INSERT INTO __pages SET ?%', $page);
		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
		$this->db->query("UPDATE __pages SET position=id WHERE id=?", $id);	
		return $id;
	}
	
	/*
	*
	* Обновить страницу
	*
	*/
	public function update_page($id, $page)
	{	
		$query = $this->db->placehold('UPDATE __pages SET ?% , last_modify=NOW() WHERE id in (?@)', $page, (array)$id);
		if(!$this->db->query($query))
			return false;
		return $id;
	}
	
	/*
	*
	* Удалить страницу
	*
	*/	
	public function delete_page($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __pages WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
				return true;
		}
		return false;
	}	
	
	/*
	*
	* Функция возвращает массив меню
	*
	*/
	public function get_menus()
	{
		$menus = array();
		$query = "SELECT * FROM __menu ORDER BY position";
		$this->db->query($query);
		foreach($this->db->results() as $menu)
			$menus[$menu->id] = $menu;
		return $menus;
	}
	
	/*
	*
	* Функция возвращает меню по id
	* @param $id
	*
	*/
	public function get_menu($menu_id)
	{	
		$query = $this->db->placehold("SELECT * FROM __menu WHERE id=? LIMIT 1", intval($menu_id));
		$this->db->query($query);
		return $this->db->result();
	}

	private function init_menu()
	{
		$this->menus = array();
		$query = "SELECT id, name, position FROM __menu ORDER BY position";
		$this->db->query($query);
		$results = $this->db->results();
		foreach($results as $c)
		{
			$this->menus[$c->id] = $c;
		}
		$this->menu = reset($this->menus);
	}

	public function add_menu($menu)
	{	
		$query = $this->db->placehold('INSERT INTO __menu SET ?%', $menu);
		if(!$this->db->query($query))
			return false;
		$id = $this->db->insert_id();
		$this->db->query("UPDATE __menu SET position=id WHERE id=?", $id);	
		$this->init_menu();
		return $id;
	}
	
	public function update_menu($id, $menu)
	{	
		$query = $this->db->placehold('UPDATE __menu SET ?% WHERE id in (?@)', $menu, (array)$id);
		if(!$this->db->query($query))
			return false;
		$this->init_menu();
		return $id;
	}
	
	public function delete_menu($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __menu WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
				return true;
			$this->init_menu();
		}
		return false;
	}
	
}

