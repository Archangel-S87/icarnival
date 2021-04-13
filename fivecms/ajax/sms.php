<?
chdir('../..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

$phone = trim($_GET['phone']);
$message = htmlspecialchars(trim($_GET['message']));

if(!empty($phone) && !empty($message)){
	$fivecms->notify->sms($phone, $message);
	echo "sms_success";
} else {
	echo "sms_error";
}
?>