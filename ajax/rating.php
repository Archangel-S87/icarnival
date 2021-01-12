<?php
	session_start();
	chdir('..');
	require_once('api/Fivecms.php');
	
	$fivecms = new Fivecms();
	if(isset($_POST['id']) && is_numeric($_POST['rating'])) 
	{
        $product_id = intval(str_replace('product_', '', $_POST['id']));
        $rating = floatval($_POST['rating']);
		
        if(!isset($_SESSION['rating_ids'])) $_SESSION['rating_ids'] = array();
        
        if(!in_array($product_id, $_SESSION['rating_ids']))
		{ 		
			$query = $fivecms->db->placehold('SELECT rating, votes FROM __products WHERE id = ? LIMIT 1',  $product_id);
			$fivecms->db->query($query);
			$product = $fivecms->db->result();
			
            if(!empty($product))
			{
                $rate = ($product->rating * $product->votes + $rating) / ($product->votes + 1);
                $query = $fivecms->db->placehold("UPDATE __products SET rating = ?, votes = votes + 1 WHERE id = ?", $rate, $product_id);
                $fivecms->db->query($query);
					$_SESSION['rating_ids'][] = $product_id; // вносим в список который уже проголосовали
                echo $rate;             
            }
            else echo -1; //товар не найден
		}
		else echo 0; //уже голосовали
	}
	else echo -1; //неверные параметры