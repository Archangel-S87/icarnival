<?php
	chdir('../..');
	require_once('api/Fivecms.php');
	$fivecms = new Fivecms();
	
	$result = array();
	$utime = $fivecms->request->post('utime', 'integer');
	
	// Новых заказов с момента времени
	$fivecms->db->query("SELECT count(o.id) as count 
						FROM __orders o 
						WHERE o.date >= FROM_UNIXTIME(?) 
						AND o.status = 0", $utime);
	
	$result['count_time'] = $fivecms->db->result('count');
	
	// Всего новых заказов
	$fivecms->db->query("SELECT count(o.id) as count 
						FROM __orders o 
						WHERE o.status = 0");
	
	$result['count_new'] = $fivecms->db->result('count');

	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($result);	