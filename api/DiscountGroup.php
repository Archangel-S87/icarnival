<?php

/**
 * 
 *
 * 
 * 
 * 
 *
 */
 
require_once('Fivecms.php');


class DiscountGroup extends Fivecms
{
	private $discountgroups = array();
	private $discountgroup;

	public function __construct()
	{
		parent::__construct();
		


		$this->init_discountgroups();
	}
	
	private function init_discountgroups()
	{
		$this->discountgroups = array();
		// Выбираем из базы валюты
		$query = "SELECT id, name, discount, count_from, count_to, enabled
					FROM __discountgroup ORDER BY id";
		$this->db->query($query);
		
		$results = $this->db->results();
		
		foreach($results as $c)
		{
			$this->discountgroups[$c->id] = $c;
		}
		
		$this->discountgroup = reset($this->discountgroups);

	}

	
	public function get_discountgroups($filter = array())
	{
		$discountgroups = array();
		foreach($this->discountgroups as $id=>$discountgroup)
			if((isset($filter['enabled']) && $filter['enabled'] == 1 && $discountgroup->enabled) || empty($filter['enabled']))
				$discountgroups[$id] = $discountgroup;
			
		return $discountgroups;
	}
	
	public function get_discountgroup($id = null)
	{
		if(!empty($id) && is_integer($id) && isset($this->discountgroups[$id]))
			return $this->discountgroups[$id];
			
		if(!empty($id) && is_string($id))
		{
			foreach($this->discountgroups as $discountgroup)
			{
				if($discountgroup->code == $id)
					return $discountgroup;
			}
		}

		return $this->discountgroup;
	}
	
	
	public function add_discountgroup($discountgroup)
	{	
		$query = $this->db->placehold('INSERT INTO __discountgroup
		SET ?%',
		$discountgroup);

		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
		//$this->db->query("UPDATE __discountgroup SET discount=id WHERE id=?", $id);
		$this->init_discountgroups();
			
		return $id;
	}
	
	public function update_discountgroup($id, $discountgroup)
	{	
		$query = $this->db->placehold('UPDATE __discountgroup
						SET ?%
						WHERE id in (?@)',
					$discountgroup, (array)$id);
		if(!$this->db->query($query))
			return false;		
		$this->init_discountgroups();
		return $id;
	}
	
	public function delete_discountgroup($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __discountgroup WHERE id=? LIMIT 1", intval($id));
			$this->db->query($query);
		}
		$this->init_discountgroups();		
	}
        public function update_config($str_name, $b_true){
            //str_name - название параметра для вкл и откл групповы скидок
            $get_config = $this->get_discount_config($str_name);
            if ($get_config){
              $query = 'UPDATE __settings	SET value= '.$b_true.' WHERE name = \''.$str_name.'\'';
              if(!$this->db->query($query))
			return false;
              return true;
            }else{
               if (!$this->add_config_discount($str_name, $b_true))
                   return false;
               
               return true;
            }
            
        }
        public function get_discount_config($str_name){
            $query = "SELECT value FROM __settings WHERE name = '".$str_name."'";
		
             $this->db->query($query);
             $val = $this->db->result('value');
			
            return (bool)$val;		
        }
        public function get_config_discount($str_name){
            $query = "SELECT value FROM __settings WHERE name = '".$str_name."'";
		if(!$this->db->query($query))
                    return false;
		
		return (int)$this->db->result('value');
        }
        public function add_config_discount($str_name, $b_true){
             $query = 'INSERT INTO __settings SET value = \''.$b_true.'\', name = \''.$str_name.'\'';
             if(!$this->db->query($query))
                    return false;
             
             return true;
        }
        
        public function get_value_discount($price){
            $query = "SELECT discount FROM __discountgroup WHERE count_to >='".$price."' And count_from <='".$price."' ORDER BY id";
		if(!$this->db->query($query))
                    return false;
		
		return $this->db->result('discount');
        }
        public function get_max_discount($price){
            $query = "SELECT `discount` FROM `__discountgroup` where count_to=(Select Max(`count_to`) from `__discountgroup`) And  (Select Max(`count_to`) from `__discountgroup`) <= ".$price." group by `discount` LIMIT 0, 30";
		if(!$this->db->query($query))
                    return false;
		
		return $this->db->result('discount');
        }
	
}
