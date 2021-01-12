<?php

require_once('Fivecms.php');

class Brands extends Fivecms
{
	/*
	*
	* Функция возвращает массив брендов, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function get_brands($filter = array())
	{
		$brands = array();
        $visible_filter = '';
        $active_filter = '';
        $in_stock_filter = '';
        $category_id_filter = '';
        $group_by = '';
        $order = 'b.name';

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));
			
		if(isset($filter['active']))
			$active_filter = $this->db->placehold('AND b.visible=?', intval($filter['active']));	
			
		if(isset($filter['in_stock'])) {
            $in_stock_filter = $this->db->placehold('AND (SELECT COUNT(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));
        }
			
		if (!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold("LEFT JOIN __products p ON p.brand_id=b.id 
                                                        LEFT JOIN __products_categories pc ON p.id = pc.product_id 
                                                        WHERE 1
                                                        AND pc.category_id IN( ?@ ) 
                                                        $visible_filter 
                                                        $active_filter 
                                                        $in_stock_filter", (array)$filter['category_id']);
            $group_by = 'GROUP BY b.id';
        } elseif(isset($filter['visible']) || isset($filter['in_stock']) || isset($filter['active'])) {
            $category_id_filter = $this->db->placehold("LEFT JOIN __products p ON p.brand_id=b.id  
                                    WHERE 1
                                    $visible_filter 
                                    $active_filter 
                                    $in_stock_filter");
            $group_by = 'GROUP BY b.id';
        }

		// Выбираем все бренды
		$query = $this->db->placehold("SELECT DISTINCT b.id, b.name, b.url, b.visible, b.meta_title, b.meta_keywords, b.meta_description, b.description, b.description_seo, b.image, b.last_modify
								 		FROM __brands b $category_id_filter $group_by ORDER BY $order");
		
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
	* Функция возвращает бренд по его id или url
	* (в зависимости от типа аргумента, int - id, string - url)
	* @param $id id или url поста
	*
	*/
	public function get_brand($id)
	{
		if(is_int($id))			
			$filter = $this->db->placehold('id = ?', $id);
		else
			$filter = $this->db->placehold('url = ?', $id);
		$query = "SELECT * FROM __brands WHERE $filter ORDER BY name LIMIT 1";
		$this->db->query($query);
		return $this->db->result();
	}

	/*
	*
	* Добавление бренда
	* @param $brand
	*
	*/
	public function add_brand($brand)
	{
		$brand = (array)$brand;
		
		if(empty($brand['url']))
			$brand['url'] = $this->translit($brand['name']);
		
		// Если есть бренд с таким URL, добавляем к нему число
		while($this->get_brand((string)$brand['url']))
		{
			if(preg_match('/(.+)_([0-9]+)$/', $brand['url'], $parts))
				$brand['url'] = $parts[1].'-'.($parts[2]+1);
			else
				$brand['url'] = $brand['url'].'-2';
		}
	
		$this->db->query("INSERT INTO __brands SET ?%", $brand);
		return $this->db->insert_id();
	}

	/*
	*
	* Обновление бренда(ов)
	* @param $brand
	*
	*/		
	public function update_brand($id, $brand)
	{
		$query = $this->db->placehold("UPDATE __brands SET ?% , last_modify=NOW() WHERE id=? LIMIT 1", $brand, intval($id));
		$this->db->query($query);
		return $id;
	}
	
	/*
	*
	* Удаление бренда
	* @param $id
	*
	*/	
	public function delete_brand($id)
	{
		if(!empty($id))
		{
			$this->delete_image($id);	
			$query = $this->db->placehold("DELETE FROM __brands WHERE id=? LIMIT 1", $id);
			$this->db->query($query);		
			$query = $this->db->placehold("UPDATE __products SET brand_id=NULL WHERE brand_id=?", $id);
			$this->db->query($query);	
		}
	}
	
	/*
	*
	* Удаление изображения бренда
	* @param $id
	*
	*/
	public function delete_image($brand_id)
	{
		$query = $this->db->placehold("SELECT image FROM __brands WHERE id=?", intval($brand_id));
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __brands SET image=NULL WHERE id=?", $brand_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __brands WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
			{			
				@unlink($this->config->root_dir.$this->config->brands_images_dir.$filename);		
			}
		}
	}
	
	private function translit($text)
	{
		$ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я"); 
		$en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");

	 	$res = str_replace($ru, $en, $text);
		$res = preg_replace("/[\s]+/ui", '-', $res);
		$res = preg_replace('/[^\p{L}\p{Nd}\d-]/ui', '', $res);
	 	$res = strtolower($res);
	    return $res;  
	}

}