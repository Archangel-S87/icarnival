<?php
	require_once('../../api/Fivecms.php');
	$fivecms = new Fivecms();
	$limit = 200;
	
	$keyword = $fivecms->request->get('query', 'string');
	
	$fivecms->db->query('SELECT u.id, u.name, u.email FROM __users u WHERE u.name LIKE "%'.$fivecms->db->escape($keyword).'%" OR u.email LIKE "%'.$fivecms->db->escape($keyword).'%"ORDER BY u.name LIMIT ?', $limit);
	$users = $fivecms->db->results();
	
	$suggestions = array();
	foreach($users as $user)
	{
		$suggestion = new stdClass();
		$suggestion->value = $user->name." ($user->email)";			
		$suggestion->data = $user;
		$suggestions[] = $suggestion;
	}

	$res = new stdClass;
	$res->query = $keyword;
	$res->suggestions = $suggestions;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);
