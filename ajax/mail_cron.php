<?php
    session_start();
	chdir('..');
    require_once('api/Fivecms.php');
    $fivecms = new Fivecms();

	if ($fivecms->settings->mails_round) {
		$limit = intval($fivecms->settings->mails_round);
		if ($limit > 10) $limit = 10;
	} else {
    	$limit = 10;
	}
    $mails = $fivecms->mailer->get_spam($limit);
    foreach ($mails as $mail){
        if (!empty($mail->email))
        {
            if ($fivecms->settings->mails_from) {
				$from = $fivecms->settings->mails_from;
			} else {
				$from = $fivecms->settings->notify_from_email;
			}
            $to = $mail->email;
            $subject = $mail->title;
            $body = $mail->body;

			$fivecms->notify->email($to, $subject, $body, $fivecms->settings->notify_from_email, $from);

			if ($fivecms->settings->mails_pause) {
				$pause = intval($fivecms->settings->pause)*1000000;
				if ($pause < 6000000) $pause = 6000000;
			} else {
		    	$pause = 6000000;
			}
			usleep(rand(5000000,$pause));
        }
    }
    $mails = $fivecms->mailer->delete_spam($limit);
    echo "sent";
	