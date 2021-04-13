<?
chdir('../..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

$to = trim($_GET['btf_mail']);
$from = trim($_GET['btf_mail_from']);
$btf_theme = nl2br(trim($_GET['btf_theme']));
$btf_sub = htmlspecialchars(trim($_GET['btf_sub']));

if(!empty($to)) {
	$subject = "".$btf_sub."";
	//$subject = "=?utf-8?B?".base64_encode($subject)."?=";
	$message .= "".$btf_theme." \r\n";
	$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email, $fivecms->settings->order_email);
	echo "btf_success";
} else {
	echo "btf_error";
}
?>