<?
session_start();
chdir('..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();
$feedback = new stdClass;

$to = trim($fivecms->settings->order_email);
$from = trim($fivecms->settings->order_email);
$btf_name = htmlspecialchars(trim($_GET['btf_name']));
$btf_phone = htmlspecialchars(trim($_GET['btf_phone']));
$btf_theme = nl2br(trim($_GET['btf_theme']));
$btf_email = htmlspecialchars(trim($_GET['btf_email']));

if(strlen($btf_name) > 2 && !empty($btf_phone) && strlen($btf_email) > 6) {	
	$subject = "Заказ обратного звонка";
	//$subject = "=?utf-8?B?".base64_encode($subject)."?=";
	
	$message .= "Имя: ".$btf_name." <br/><br/>\r\n";
	$message .= "Телефон: ".$btf_phone." <br/><br/>\r\n";
	$message .= "Email: ".$btf_email." <br/><br/>\r\n";
	$message .= "Тема: ".$btf_theme." \r\n";
	
	// Добавляем в "Обратная связь"
	$feedback->name = $btf_name.' ('.$subject.')';
	$feedback->email = $btf_email;
	$feedback->message = $message;	
	$fivecms->feedbacks->add_feedback($feedback);
	
	// Отправляем на почту
	$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email, $btf_email);
	
	// Добавляем в подписчики
	if($fivecms->settings->auto_subscribe == 1)
		$fivecms->mailer->add_mail($btf_name, $btf_email);
	
	echo "btf_success";

} else {
	echo "btf_error";
}

?>