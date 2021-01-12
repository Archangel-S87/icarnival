<?
session_start();
chdir('..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

$to = trim($fivecms->settings->order_email);
$from = trim($fivecms->settings->order_email);

$message='';
// переберём массив $_POST
foreach ($_POST as $key => $value) {
	$value = htmlspecialchars(trim($value));
	$key = htmlspecialchars(trim($key));
	
	if($key == 'f-name')
		$form_name = $value;
	elseif ($key == 'f-email')
		$form_email = $value;
	elseif ($key == 'f-subject')
		$subject = $value;

	if($key != 'f-subject')
		$message .= nl2br($value) . "<br /><br />";
}

$store_url = $fivecms->config->root_url;

if(empty($subject))
	$subject = "Запрос c ".$store_url;

if(!empty($form_email))
	$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email, $form_email);
else 
	$fivecms->notify->email($to, $subject, $message, $fivecms->settings->notify_from_email);
		
echo "form_success";

if($fivecms->settings->auto_subscribe == 1 && !empty($form_name) && !empty($form_email))	
	$fivecms->mailer->add_mail($form_name, $form_email);

// Отправляем в Обратная связь
$form = new stdClass;
$form->name = $subject;
if(!empty($form_email))
	$form->email = $form_email;
$form->message = $message;		
$form->ip = $fivecms->design->get_user_ip();
$form_id = $fivecms->feedbacks->add_feedback($form);	
// Отправляем в Обратная связь end

?>