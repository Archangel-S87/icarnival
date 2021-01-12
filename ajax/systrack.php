<?
session_start();
chdir('..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

$to = trim($_GET['tf_mail']);
$from = trim($_GET['tf_mail_from']);
$tf_theme = nl2br(trim($_GET['tf_theme']));
$tf_sub = htmlspecialchars(trim($_GET['tf_sub']));
$tf_track = htmlspecialchars(trim($_GET['tf_track']));
$tf_delivery = htmlspecialchars(trim($_GET['tf_delivery']));

if(!empty($to)) {
	$subject = "".$tf_sub."";
	//$subject = "=?utf-8?B?".base64_encode($subject)."?=";
	$message .= "Добрый день! <br/><br/>\r\n";
	$message .= "".$tf_track." <br/><br/>\r\n";
	if (!empty($tf_delivery)) $message .= "".$tf_delivery." \r\n";
	if (!empty($tf_theme)) $message .= "<br/><br/>".$tf_theme." \r\n";
	$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email, $fivecms->settings->order_email);
	echo "tf_success";
} else {
	echo "tf_error";
}
?>