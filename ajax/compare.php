<?php

	session_start();
	chdir('..');
	require_once('api/Fivecms.php');
	$fivecms = new Fivecms();
	$fivecms->compare->add_item($fivecms->request->get('compare', 'integer'));
	$compare = $fivecms->compare->get_compare_informer();
	$fivecms->design->assign('compare', $compare);

	$result = $fivecms->design->fetch('compare_informer.tpl');
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");
    print json_encode($result);
