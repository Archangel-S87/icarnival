<?PHP
/**
 * 5CMS
 *
 */
require_once('api/Fivecms.php');
class PaymentModule extends Fivecms
{
 
	public function checkout_form()
	{
		$form = '<input type=submit value="Оплатить">';	
		return $form;
	}
	public function settings()
	{
		$form = '<input type=submit value="Оплатить">';	
		return $form;
	}
}