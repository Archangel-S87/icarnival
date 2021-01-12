<?PHP
require_once('api/Fivecms.php');

class UserAdmin extends Fivecms
{	
	public function fetch()
	{
		$user = new stdClass;
		if(!empty($_POST['user_info']))
		{
			$user->id = $this->request->post('id', 'integer');
			$user->enabled = $this->request->post('enabled', 'boolean');
			$user->name = $this->request->post('name');
			$user->email = $this->request->post('email');
			if($this->request->post('balance')) 
				$user->balance = $this->request->post('balance', 'float');
			if($this->request->post('change_balance'))
				$change_balance = $this->request->post('change_balance', 'float');
			$user->group_id = $this->request->post('group_id');
			$user->phone = $this->request->post('phone');
			$user->comment = $this->request->post('comment');
	
			## Не допустить одинаковые email пользователей.
			if(empty($user->name))
			{			
				$this->design->assign('message_error', 'empty_name');
			}
			elseif(empty($user->email))
			{			
				$this->design->assign('message_error', 'empty_email');
			}
			elseif(($u = $this->users->get_user($user->email)) && $u->id!=$user->id)
			{			
				$this->design->assign('message_error', 'login_existed');
			}
			else
			{
				$user->id = $this->users->update_user($user->id, $user);
  				
   	    		$user = $this->users->get_user(intval($user->id));
   	    		if($change_balance > 0 && $user->balance > 0) {
   	    			if($change_balance > $user->balance) {
   	    				$this->design->assign('message_error', 'wrong_change_balance');
   	    			} else {
						$new_balance = max(0,floatval($user->balance - $change_balance));
						$currency = $this->money->get_currency();
						$withdrawal = $user->withdrawal.'<li><span>'.$change_balance.' '.$currency->sign.'</span><span>'.date("d.m.y").' '.date("H:i:s").'</span></li>';
						$this->users->update_user($user->id, array('balance' => $new_balance, 'withdrawal' => $withdrawal));
						$user = $this->users->get_user(intval($user->id));
					}
				} elseif($change_balance < 0) {
					$this->design->assign('message_error', 'wrong_change_balance');
				}
				$this->design->assign('message_success', 'updated');
			}
		}
		elseif($this->request->post('check'))
		{ 
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
				case 'delete':
				{
					foreach($ids as $id)
					{
						$o = $this->orders->get_order(intval($id));
						if($o->status<3)
						{
							$this->orders->update_order($id, array('status'=>3, 'user_id'=>null));
							$this->orders->open($id);							
						}
						else
							$this->orders->delete_order($id);
					}
					break;
				}
			}
 		}

		$id = $this->request->get('id', 'integer');
		if(!empty($id))
			$user = $this->users->get_user(intval($id));			

		if(!empty($user))
		{
			$this->design->assign('user', $user);
			
			$orders = $this->orders->get_orders(array('user_id'=>$user->id));
			$this->design->assign('orders', $orders);

			$filter = array();
			$filter['user_id'] = $user->id;
			$category_id = $this->request->get('category_id', 'integer');
			if(!empty($category_id)) {
				$category = $this->surveys_categories->get_surveys_category($category_id);
				if(!empty($category)) {
					$filter['category_id'] = $category->children;
				}
			}

			$surveys = array();

			foreach($this->surveys->get_surveys($filter) as $s) {
				$surveys[$s->id] = $s;
			}
			
			if(!empty($surveys)) {

				$this->db->query('SELECT sr.*, sf.name
				                 FROM __surveys_results sr 
				                 LEFT JOIN __surveys_fields sf ON sf.id = sr.field_id
				                 WHERE sr.user_id=? 
				                 AND sr.survey_id IN (?@)', $user->id, (array) array_keys($surveys));
				foreach ($this->db->results() as $vote_info) {
					$surveys[$vote_info->survey_id]->vote_info[] = $vote_info;
				}
			}
			
			$this->design->assign('surveys', $surveys);
			
		}
		
 	  	$groups = $this->users->get_groups();
		$this->design->assign('groups', $groups);
		
		$referrals = $this->users->get_users(array('partner_id'=>$user->id));
		$this->design->assign('referrals', $referrals);

		$surveys_categories = $this->surveys_categories->get_surveys_categories_tree();

		$this->design->assign('surveys_categories', $surveys_categories);
		
 	  	return $this->design->fetch('user.tpl');
	}
	
}

