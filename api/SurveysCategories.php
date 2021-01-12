<?php

require_once('Fivecms.php');

class SurveysCategories extends Fivecms
{
	// Список указателей на категории в дереве категорий (ключ = id категории)
	private $all_surveys_categories;
	// Дерево категорий
	private $surveys_categories_tree;

	// Функция возвращает массив категорий
	public function get_surveys_categories($filter = array())
	{
		if(!isset($this->surveys_categories_tree))
			$this->init_surveys_categories();
		return $this->all_surveys_categories;
	}	

	// Функция возвращает дерево категорий
	public function get_surveys_categories_tree()
	{
		if(!isset($this->surveys_categories_tree))
			$this->init_surveys_categories();
		return $this->surveys_categories_tree;
	}

	// Функция возвращает заданную категорию
	public function get_surveys_category($id)
	{
		if(!isset($this->all_surveys_categories))
			$this->init_surveys_categories();
		if(is_int($id) && array_key_exists(intval($id), $this->all_surveys_categories))
			return $category = $this->all_surveys_categories[intval($id)];
		elseif(is_string($id))
			foreach ($this->all_surveys_categories as $category)
				if ($category->url == $id)
					return $this->get_surveys_category((int)$category->id);	
		return false;
	}
	
	// Добавление категории
	public function add_surveys_category($category)
	{
		$category = (array)$category;
		if(empty($category['url']))
		{
			$category['url'] = preg_replace("/[\s]+/ui", '_', $category['name']);
			$category['url'] = strtolower(preg_replace("/[^0-9a-zа-я_]+/ui", '', $category['url']));
		}	

		// Если есть категория с таким URL, добавляем к нему число
		while($this->get_surveys_category((string)$category['url']))
		{
			if(preg_match('/(.+)_([0-9]+)$/', $category['url'], $parts))
				$category['url'] = $parts[1].'_'.($parts[2]+1);
			else
				$category['url'] = $category['url'].'_2';
		}

		$this->db->query("INSERT INTO __surveys_categories SET ?%", $category);
		$id = $this->db->insert_id();
		$this->db->query("UPDATE __surveys_categories SET position=id WHERE id=?", $id);		
		$this->init_surveys_categories();		
		return $id;
	}
	
	// Изменение категории
	public function update_surveys_category($id, $category)
	{
		$query = $this->db->placehold("UPDATE __surveys_categories SET ?% , last_modify=NOW() WHERE id=? LIMIT 1", $category, intval($id));
		$this->db->query($query);
		$this->init_surveys_categories();
		return $id;
	}
	
	// Удаление категории
	public function delete_surveys_category($id)
	{
		if(!$category = $this->get_surveys_category(intval($id)))
			return false;
		foreach($category->children as $id)
		{
			if(!empty($id))
			{
				$this->delete_image($id);
				$query = $this->db->placehold("DELETE FROM __surveys_categories WHERE id=? LIMIT 1", $id);
				$this->db->query($query);
				$query = $this->db->placehold("DELETE FROM __products_surveys_categories WHERE category_id=?", $id);
				$this->db->query($query);
				$this->init_surveys_categories();			
			}
		}
		return true;
	}

	// Удалить изображение категории
	public function delete_image($category_id)
	{
		$query = $this->db->placehold("SELECT image FROM __surveys_categories WHERE id=?", $category_id);
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __surveys_categories SET image=NULL WHERE id=?", $category_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __surveys_categories WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
			{			
				@unlink($this->config->root_dir.$this->config->surveys_categories_images_dir.$filename);		
			}
			$this->init_surveys_categories();
		}
	}

	// Инициализация категорий, после которой категории будем выбирать из локальной переменной
	private function init_surveys_categories()
	{
		// Дерево категорий
		$tree = new stdClass();
		$tree->subcategories = array();
		
		// Указатели на узлы дерева
		$pointers = array();
		$pointers[0] = &$tree;
		$pointers[0]->path = array();
		
		// Выбираем все категории
		$query = $this->db->placehold("SELECT * FROM __surveys_categories c ORDER BY c.parent_id, c.position");
											
		$this->db->query($query);
		$surveys_categories = $this->db->results();
				
		$finish = false;
		// Не кончаем, пока не кончатся категории, или пока ниодну из оставшихся некуда приткнуть
		while(!empty($surveys_categories)  && !$finish)
		{
			$flag = false;
			// Проходим все выбранные категории
			foreach($surveys_categories as $k=>$category)
			{
				if(isset($pointers[$category->parent_id]))
				{
					// В дерево категорий (через указатель) добавляем текущую категорию
					$pointers[$category->id] = $pointers[$category->parent_id]->subcategories[] = $category;
					
					// Путь к текущей категории
					$curr = $pointers[$category->id];
					$pointers[$category->id]->path = array_merge((array)$pointers[$category->parent_id]->path, array($curr));
					
					// Убираем использованную категорию из массива категорий
					unset($surveys_categories[$k]);
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

		$this->surveys_categories_tree = $tree->subcategories;
		$this->all_surveys_categories = $pointers;	
	}
}
