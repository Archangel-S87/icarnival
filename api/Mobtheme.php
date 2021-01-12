<?php

require_once('Fivecms.php');

class Mobtheme extends Fivecms
{
	private $vars = array();
	
	function __construct()
	{
		parent::__construct();
		
		// Выбираем из базы настройки
		$this->db->query('SELECT name, value FROM __mobtheme');

		// и записываем их в переменную		
		foreach($this->db->results() as $result)
			if(!($this->vars[$result->name] = @unserialize($result->value)))
			$this->vars[$result->name] = $result->value;
	}
	
	public function __get($name)
	{
		if($res = parent::__get($name))
			return $res;
		
		if(isset($this->vars[$name]))
			return $this->vars[$name];
		else
			return null;
	}
	
	public function __set($name, $value)
	{
		$this->vars[$name] = $value;
		if(is_array($value))
			$value = serialize($value);

else
$value = (string) $value;


		$this->db->query('SELECT count(*) as count FROM __mobtheme WHERE name=?', $name);
		if($this->db->result('count')>0)
			$this->db->query('UPDATE __mobtheme SET value=? WHERE name=?', $value, $name);
		else
			$this->db->query('INSERT INTO __mobtheme SET value=?, name=?', $value, $name);
		
	}
}