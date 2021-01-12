<?php
	require_once('../../api/Fivecms.php');
	$fivecms = new Fivecms();
	$limit = 200;
	$keyword = $fivecms->request->get('query', 'string');
	$feature_id = $fivecms->request->get('feature_id', 'string');
	
	$query = $fivecms->db->placehold('SELECT DISTINCT po.value FROM __options po
										WHERE value LIKE "'.$fivecms->db->escape($keyword).'%" AND feature_id=? ORDER BY po.value LIMIT ?', $feature_id, $limit);

	$fivecms->db->query($query);
		
	$options = $fivecms->db->results('value');
	
	$res = new stdClass;
	$res->query = $keyword;
	$res->suggestions = $options;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);
