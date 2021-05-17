<?
session_start();
chdir('..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();
$feedback = new stdClass;

$to = trim($fivecms->settings->order_email);
$from = trim($fivecms->settings->order_email);
$ip = $fivecms->design->get_user_ip();

if(!empty($_POST['btf_name']))
	$btf_name = htmlspecialchars(trim($_POST['btf_name']));
if(!empty($_POST['btf_phone']))
	$btf_phone = htmlspecialchars(trim($_POST['btf_phone']));
if(!empty($_POST['btf_theme']))	
	$btf_theme = nl2br(trim($_POST['btf_theme']));
if(!empty($_POST['btf_email']))	
	$btf_email = htmlspecialchars(trim($_POST['btf_email']));
if(!empty($_POST['btf_check']))	
	$btf_check = trim($_POST['btf_check']);

if($fivecms->settings->spam_ip == 1 && (
		(!empty($ip) && $ip == $fivecms->settings->last_ip_btf) || 
		(!empty(session_id()) && session_id() == $fivecms->settings->session_btf)
	)){
	echo "already_sent";
} elseif($fivecms->settings->spam_cyr == 1 && !empty($btf_name) && !preg_match('/^[а-яё \t]+$/iu', $btf_name)){
	echo "wrong_name";
} elseif(!empty($fivecms->settings->spam_symbols) && !empty($btf_name) && mb_strlen($btf_name,'UTF-8') > $fivecms->settings->spam_symbols) {
	echo "captcha";
} elseif(!empty($btf_email) && filter_var($btf_email, FILTER_VALIDATE_EMAIL) === false) {
	echo "wrong_email";
} elseif(!empty($btf_phone) && (!preg_match('/^[0-9 \-\+\(\)\t]+$/iu', $btf_phone) || mb_strlen($btf_phone,'UTF-8') < 7)){
	echo "wrong_phone";	
} elseif(empty($btf_check)) {
	echo "captcha";
} elseif(!empty($btf_name) && mb_strlen($btf_name,'UTF-8') > 2 && !empty($btf_phone) && !empty($btf_email) && strlen($btf_email) > 6) {	
	$subject = "Заказ обратного звонка";
	//$subject = "=?utf-8?B?".base64_encode($subject)."?=";
	$message = "";
	$message .= "Форма: ".$subject." <br/><br/>\r\n";
	$message .= "Имя: ".$btf_name." <br/><br/>\r\n";
	$message .= "Телефон: ".$btf_phone." <br/><br/>\r\n";
	$message .= "Email: ".$btf_email." <br/><br/>\r\n";
	if(!empty($btf_theme))
		$message .= "Тема: ".$btf_theme." \r\n";
	
	// Добавляем в "Обратная связь"
	$feedback->name = $btf_name;
	$feedback->email = $btf_email;
	$feedback->message = $message;	
	$fivecms->feedbacks->add_feedback($feedback);
	
	// Записываем сессию и IP для блокировки повторной регистрации
	if(!empty($ip))
		$fivecms->settings->last_ip_btf = $ip;
	if(!empty(session_id()))
		$fivecms->settings->session_btf = session_id();
	
	// Отправляем на почту
	if(!empty($btf_email))
		$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email, $btf_email);
	else 
		$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email);
	
	// Добавляем в подписчики
	if($fivecms->settings->auto_subscribe == 1 && !empty($btf_name) && !empty($btf_email))
		$fivecms->mailer->add_mail($btf_name, $btf_email);
	
	echo "btf_success";

} else {
	echo "btf_error";
}

?>