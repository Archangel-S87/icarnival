<?php

require_once('Fivecms.php');

class ServicesCategories extends Fivecms
{
	// Список указателей на категории в дереве категорий (ключ = id категории)
	private $all_services_categories;
	// Дерево категорий
	private $services_categories_tree;

	// Функция возвращает массив категорий
	public function get_services_categories($filter = array())
	{
		if(!isset($this->services_categories_tree))
			$this->init_services_categories();
 
		
		return $this->all_services_categories;
	}	

	// Функция возвращает дерево категорий
	public function get_services_categories_tree()
	{
		if(!isset($this->services_categories_tree))
			$this->init_services_categories();
			
		return $this->services_categories_tree;
	}

	// Функция возвращает заданную категорию
	public function get_services_category($id)
	{
		if(!isset($this->all_services_categories))
			$this->init_services_categories();
		if(is_int($id) && array_key_exists(intval($id), $this->all_services_categories))
			return $category = $this->all_services_categories[intval($id)];
		elseif(is_string($id))
			foreach ($this->all_services_categories as $category)
				if ($category->url == $id)
					return $this->get_services_category((int)$category->id);	
		
		return false;
	}
	
	// Добавление категории
	public function add_services_category($category)
	{
		$category = (array)$category;
		if(empty($category['url']))
		{
			$category['url'] = preg_replace("/[\s]+/ui", '_', $category['name']);
			$category['url'] = strtolower(preg_replace("/[^0-9a-zа-я_]+/ui", '', $category['url']));
		}	

		// Если есть категория с таким URL, добавляем к нему число
		while($this->get_services_category((string)$category['url']))
		{
			if(preg_match('/(.+)_([0-9]+)$/', $category['url'], $parts))
				$category['url'] = $parts[1].'_'.($parts[2]+1);
			else
				$category['url'] = $category['url'].'_2';
		}

		$this->db->query("INSERT INTO __services_categories SET ?%", $category);
		$id = $this->db->insert_id();
		$this->db->query("UPDATE __services_categories SET position=id WHERE id=?", $id);		
		$this->init_services_categories();		
		return $id;
	}
	
	// Изменение категории
	public function update_services_category($id, $category)
	{
		$query = $this->db->placehold("UPDATE __services_categories SET ?% , last_modify=NOW() WHERE id=? LIMIT 1", $category, intval($id));
		$this->db->query($query);
		$this->init_services_categories();
		return $id;
	}
	
	// Удаление категории
	public function delete_services_category($id)
	{
		if(!$category = $this->get_services_category(intval($id)))
			return false;
		foreach($category->children as $id)
		{
			if(!empty($id))
			{
				$this->delete_image($id);
				$images = $this->get_images(array('post_id'=>$id));
				foreach($images as $i)
					$this->delete_images($i->id);
				$query = $this->db->placehold("DELETE FROM __services_categories WHERE id=? LIMIT 1", $id);
				$this->db->query($query);
				$query = $this->db->placehold("DELETE FROM __products_services_categories WHERE category_id=?", $id);
				$this->db->query($query);
				$this->init_services_categories();			
			}
		}
		return true;
	}

	// Удалить изображение категории
	public function delete_image($category_id)
	{
		$query = $this->db->placehold("SELECT image FROM __services_categories WHERE id=?", $category_id);
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __services_categories SET image=NULL WHERE id=?", $category_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __services_categories WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
			{			
				@unlink($this->config->root_dir.$this->config->services_categories_images_dir.$filename);		
			}
			$this->init_services_categories();
		}
	}

	// изображения
	function get_images($filter = array())
	{		
		$post_id_filter = '';
		$group_by = '';

		if(!empty($filter['post_id']))
			$post_id_filter = $this->db->placehold('AND i.post_id in(?@)', (array)$filter['post_id']);

		// images
		$query = $this->db->placehold("SELECT * FROM __images_service AS i WHERE 1 $post_id_filter $group_by ORDER BY i.post_id, i.position");
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function add_image($post_id, $filename, $name = '')
	{
		$query = $this->db->placehold("SELECT id FROM __images_service WHERE post_id=? AND filename=?", $post_id, $filename);
		$this->db->query($query);
		$id = $this->db->result('id');
		if(empty($id))
		{
			$query = $this->db->placehold("INSERT INTO __images_service SET post_id=?, filename=?", $post_id, $filename);
			$this->db->query($query);
			$id = $this->db->insert_id();
			$query = $this->db->placehold("UPDATE __images_service SET position=id WHERE id=?", $id);
			$this->db->query($query);
		}
		return($id);
	}
	
	public function update_image($id, $image)
	{
		$query = $this->db->placehold("UPDATE __images_service SET ?% WHERE id=?", $image, $id);
		$this->db->query($query);
		return($id);
	}
	
	public function delete_images($id)
	{
		$query = $this->db->placehold("SELECT filename FROM __images_service WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('filename');
		$query = $this->db->placehold("DELETE FROM __images_service WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		$query = $this->db->placehold("SELECT count(*) as count FROM __images_service WHERE filename=? LIMIT 1", $filename);
		$this->db->query($query);
		$count = $this->db->result('count');
		if($count == 0)
		{			
			$file = pathinfo($filename, PATHINFO_FILENAME);
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
			$rezised_images = glob($this->config->root_dir.$this->config->resized_services_images_dir.$file."*.".$ext);
			if(is_array($rezised_images))
			foreach (glob($this->config->root_dir.$this->config->resized_services_images_dir.$file."*.".$ext) as $f)
				@unlink($f);

			@unlink($this->config->root_dir.$this->config->original_services_images_dir.$filename);		
		}
	}
	// изображения end

	// Инициализация категорий, после которой категории будем выбирать из локальной переменной
	private function init_services_categories()
	{
		// Дерево категорий
		$tree = new stdClass();
		$tree->subcategories = array();
		
		// Указатели на узлы дерева
		$pointers = array();
		$pointers[0] = &$tree;
		$pointers[0]->path = array();
		
		// Выбираем все категории
		$query = $this->db->placehold("SELECT * FROM __services_categories c ORDER BY c.parent_id, c.position");
													
		$this->db->query($query);
		$services_categories = $this->db->results();
				
		$finish = false;
		// Не кончаем, пока не кончатся категории, или пока ниодну из оставшихся некуда приткнуть
		while(!empty($services_categories)  && !$finish)
		{
			$flag = false;
			// Проходим все выбранные категории
			foreach($services_categories as $k=>$category)
			{
				if(isset($pointers[$category->parent_id]))
				{
					// В дерево категорий (через указатель) добавляем текущую категорию
					$pointers[$category->id] = $pointers[$category->parent_id]->subcategories[] = $category;
					
					// Путь к текущей категории
					$curr = $pointers[$category->id];
					$pointers[$category->id]->path = array_merge((array)$pointers[$category->parent_id]->path, array($curr));
					
					// Убираем использованную категорию из массива категорий
					unset($services_categories[$k]);
					$flag = true;
				}
			}
			if(!$flag) $finish = true;
		}
		
		// Для каждой категории id всех ее деток узнаем
		$ids = array_reverse(array_keys($pointers));
		foreach($ids as $id)
		{
			if($id>0)
			{
				$pointers[$id]->children[] = $id;

				if(isset($pointers[$pointers[$id]->parent_id]->children))
					$pointers[$pointers[$id]->parent_id]->children = array_merge($pointers[$id]->children, $pointers[$pointers[$id]->parent_id]->children);
				else
					$pointers[$pointers[$id]->parent_id]->children = $pointers[$id]->children;
			}
		}
		unset($pointers[0]);
		unset($ids);

		$this->services_categories_tree = $tree->subcategories;
		$this->all_services_categories = $pointers;	
	}
	
	public function get_services($filter = array())
	{	
		// По умолчанию
		$keyword_filter = '';
		$visible_filter = '';
			
		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND c.visible = ?', intval($filter['visible']));
			
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				if($kw!=='')
					$keyword_filter .= $this->db->placehold("AND (c.name LIKE '%$kw%' OR c.meta_keywords LIKE '%$kw%' OR c.menu LIKE '%$kw%' OR c.description LIKE '%$kw%')");
			}
		}

		$query = $this->db->placehold("SELECT c.menu, c.url, c.image, c.visible
										FROM __services_categories c WHERE 1 $visible_filter $keyword_filter");
													
		$this->db->query($query);
		return $this->db->results();
	}
	
}
