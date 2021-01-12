<?php

require_once('Fivecms.php');

class MetadataPages extends Fivecms
{
	/*
	*
	* @param $filter
	*
	*/
	public function get_metadata_pages($filter = array())
	{
		$metadata_pages = array();
		// Выбираем все линии

		$query = $this->db->placehold("
			SELECT DISTINCT * 
			FROM 
				__metadata_pages l
                                ORDER BY l.id
		");                
                
		$this->db->query($query);
		return $this->db->results();
	}

	/*
	*
	* Функция возвращает линию по его id или url
	* (в зависимости от типа аргумента, int - id, string - url)
	* @param $id id или url поста
	*
	*/
	public function get_metadata_page($id)
	{
		if(is_int($id))			
			$filter = $this->db->placehold('l.id = ?', $id);
		else
        {
            $id = urldecode($id);
			$filter = $this->db->placehold('l.url = ?', $id);
        }
		
        $query = "SELECT * FROM __metadata_pages l WHERE $filter ORDER BY id LIMIT 1";                
                
		$this->db->query($query);
		return $this->db->result();
	}

	public function get_redirect_page($id)
	{
        $id = urldecode($id);
		$filter = $this->db->placehold('l.redirect = ?', $id);
        $query = "SELECT l.url, l.redirect FROM __metadata_pages l WHERE $filter ORDER BY id LIMIT 1";                
		$this->db->query($query);
		return $this->db->result();
	}

	public function add_metadata_page($metadata_page)
	{
		$metadata_page = (array)$metadata_page;
        $metadata_page['url'] = urldecode($metadata_page['url']);
		$this->db->query("INSERT INTO __metadata_pages SET ?%", $metadata_page);
		return $this->db->insert_id();
	}

	public function update_metadata_page($id, $metadata_page)
	{
        $metadata_page->url = urldecode($metadata_page->url);
		$query = $this->db->placehold("UPDATE __metadata_pages SET ?% WHERE id=? LIMIT 1", $metadata_page, intval($id));
		$this->db->query($query);
		return $id;
	}
	
	public function delete_metadata_page($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __metadata_pages WHERE id=? LIMIT 1", $id);
			$this->db->query($query);			
		}
	}
	
}
