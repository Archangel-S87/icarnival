<?php

require_once('api/Fivecms.php');
$fivecms = new Fivecms();

/**
 * Кастомный НДС
 * для каждого товара
 */
$query = $fivecms->db->placehold("ALTER TABLE __products ADD taxType TINYINT NULL AFTER visible;");
$fivecms->db->query($query);


?>