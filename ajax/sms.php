<?
session_start();
chdir('..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

$phone = trim($_GET['phone']);
$message = htmlspecialchars(trim($_GET['message']));

if( $_GET['phone'])  {

$fivecms->notify->sms($phone, $message);

echo "sms_success";
        } else {
echo "sms_error";
}
?>