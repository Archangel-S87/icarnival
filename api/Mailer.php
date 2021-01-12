<?php

require_once('Fivecms.php');

class Mailer extends Fivecms
{

	public function get_mail($id)
	{
		$query = $this->db->placehold("SELECT id, name, email, active FROM __maillist WHERE id=? LIMIT 1", $id);
		if($this->db->query($query))
			return $this->db->result();
		else
			return false; 
	}
	
	/*
	*
	* Функция возвращает массив, удовлетворяющий фильтру
	* @param $filter
	*
	*/
	public function get_maillist($filter = array())
	{	
		// По умолчанию
		$limit = 1000000;
		$page = 1;
        $active = "";
        
        if(isset($filter['active']))
			$active = "WHERE active=1";

		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

		$query = $this->db->placehold("SELECT * FROM __maillist $active ORDER BY name DESC, id DESC $sql_limit");
		
		$this->db->query($query);
		return $this->db->results();
	}
	
	/*
	*
	* Функция вычисляет количество постов, удовлетворяющих фильтру
	*
	*/
	public function count_mails()
	{	
		$query = "SELECT COUNT(distinct c.id) as count
		          FROM __maillist c WHERE 1";

		if($this->db->query($query))
			return $this->db->result('count');
		else
			return false;
	}
	
	/*
	*
	* Создание записи
	*
	*/	
	public function add_mail($name, $email)
	{	
        $query  = $this->db->placehold("SELECT id FROM __maillist WHERE email=?", $email);
        $this->db->query($query);
		if($this->db->results())
            $query = $this->db->placehold("UPDATE __maillist SET name=? WHERE email=?", $name, $email);
		else
			$query = $this->db->placehold("INSERT INTO __maillist SET name=?, email=?, active=1", $name, $email);
        if(!$this->db->query($query))
			return false;
		$id = $this->db->insert_id();

		// Уведомление, что пользователь подписан на рассылку
		//$this->notify->email_mailer_confirm($name, $email);

		return $id;
	}
	
	/*
	*
	* Обновить запись(и)
	*
	*/	
	public function update_mail($id, $mail)
	{
		$query = $this->db->placehold("UPDATE __maillist SET ?% WHERE id in(?@) LIMIT ?", $mail, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}

	/*
	*
	* Unsubscribe
	*
	*/	
	public function unsubscribe_mail($mail)
	{
		$query = $this->db->placehold("UPDATE __maillist SET active=0 WHERE email=?", $mail);
		return $this->db->query($query);
	}

	/*
	*
	* Удалить запись
	*
	*/	
	public function delete_mail($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __maillist WHERE id=? LIMIT 1", intval($id));
			return $this->db->query($query);
		}
	}
    
    /*
	*
	* Управление рассылкой писем
	*
	*/	
    public function save_spam($mail, $subject, $message){
        if (!empty($mail)){
            $to = $mail->email;
            $this->design->assign('id', $mail->id);
			$this->design->assign('mail', $mail->email);
			$this->design->assign('name', $mail->name);
            $this->design->assign('message', $message);
            $this->design->assign('subject', $subject);
            $email_template = $this->design->fetch($this->config->root_dir.'design/mail/html/email_mailer.tpl');
            $query = $this->db->placehold("INSERT INTO __mail SET email=?, title=?, body=?", $to, $subject, $email_template);
            return $this->db->query($query);
        }
        else{
            return false;
        }
    }
    
    public function get_spam($limit){
        $query  = $this->db->placehold("SELECT id, email, title, body, date FROM __mail ORDER BY id LIMIT ?", intval($limit));
        $this->db->query($query);
		return $this->db->results();
    }
    
    public function delete_spam($limit){
        if ($limit>0){
            $query = $this->db->placehold("DELETE FROM __mail ORDER BY id LIMIT ?", intval($limit));
            return $this->db->query($query);
        }
    }
    public function count_spam(){
        $query = $this->db->placehold("SELECT count(*) as rows FROM __mail");
        $this->db->query($query);
        return $this->db->result('rows');
    }	
    public function clear_spam(){
        $query = $this->db->placehold("TRUNCATE TABLE __mail");
		return $this->db->query($query);
    }	
	
}
