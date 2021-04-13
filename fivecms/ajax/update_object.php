<?php
session_start();
require_once('../../api/Fivecms.php');
$fivecms = new Fivecms();

// Проверка сессии для защиты от xss
if(!$fivecms->request->check_session())
{
	trigger_error('Session expired', E_USER_WARNING);
	exit();
}

$id = intval($fivecms->request->post('id'));
$object = $fivecms->request->post('object');
$values = $fivecms->request->post('values');
$name = $fivecms->request->post('name');

switch ($object)
{
    case 'product':
    	if($fivecms->managers->access('products'))
        $result = $fivecms->products->update_product($id, $values);
        break;
    case 'brand':
    	if($fivecms->managers->access('brands'))
        $result = $fivecms->brands->update_brand($id, $values);
        break;
    case 'category':
    	if($fivecms->managers->access('categories'))
        $result = $fivecms->categories->update_category($id, $values);
        break;
    case 'articles_category':
		if($fivecms->managers->access('articles_categories'))
        $result = $fivecms->articles_categories->update_articles_category($id, $values);
        break;  
    case 'blog_category':
		if($fivecms->managers->access('blog'))
        $result = $fivecms->blog_categories->update_category($id, $values);
        break;   
    case 'surveys_category':
		if($fivecms->managers->access('surveys_categories'))
        $result = $fivecms->surveys_categories->update_surveys_category($id, $values);
        break;   
    case 'services_category':
		if($fivecms->managers->access('services_categories'))
        $result = $fivecms->services_categories->update_services_category($id, $values);
        break;   
    case 'brands':
    	if($fivecms->managers->access('brands'))
        $result = $fivecms->brands->update_brand($id, $values);
        break;
    case 'feature':
    	if($fivecms->managers->access('features'))
        $result = $fivecms->features->update_feature($id, $values);
        break;
    case 'page':
    	if($fivecms->managers->access('pages'))
        $result = $fivecms->pages->update_page($id, $values);
        break;
    case 'blog':
    	if($fivecms->managers->access('blog'))
        $result = $fivecms->blog->update_post($id, $values);
        break;
	case 'articles':
		if($fivecms->managers->access('articles'))
        $result = $fivecms->articles->update_article($id, $values); 
        break;
	case 'surveys':
		if($fivecms->managers->access('surveys'))
        $result = $fivecms->surveys->update_survey($id, $values); 
        break;
    case 'delivery':
    	if($fivecms->managers->access('delivery'))
        $result = $fivecms->delivery->update_delivery($id, $values);
        break;
    case 'payment':
    	if($fivecms->managers->access('payment'))
        $result = $fivecms->payment->update_payment_method($id, $values);
        break;
    case 'currency':
    	if($fivecms->managers->access('currency'))
        $result = $fivecms->money->update_currency($id, $values);
        break;
    case 'comment':
    	if($fivecms->managers->access('comments'))
        $result = $fivecms->comments->update_comment($id, $values);
        break;
    case 'user':
    	if($fivecms->managers->access('users'))
        $result = $fivecms->users->update_user($id, $values);
        break;
 	case 'menu':
    	if($fivecms->managers->access('menus'))
        $result = $fivecms->pages->update_menu($id, $values);
        break;
    case 'label':
    	if($fivecms->managers->access('labels'))
        $result = $fivecms->orders->update_label($id, $values);
        break;
	case 'slide':
        if($fivecms->managers->access('slides'))
        $result = $fivecms->slides->update_slide($id, $values);        
		break;
	case 'slidem':
        if($fivecms->managers->access('slides'))
        $result = $fivecms->slidesm->update_slidem($id, $values);        
		break;
	case 'banner':
        if($fivecms->managers->access('slides'))
        $result = $fivecms->banners->update_banner($id, $values);        
		break;
	case 'form':
        if($fivecms->managers->access('feedbacks'))
        $result = $fivecms->forms->update_form($id, $values);        
		break;
    case 'link':
    	if($fivecms->managers->access('products'))
        $result = $fivecms->links->update_link($id, $values);
        break;
    case 'discountgroup':
    	if($fivecms->managers->access('discountgroup'))
        $result = $fivecms->discountgroup->update_discountgroup($id, $values);
        break; 
    case 'subscriber':
    	if($fivecms->managers->access('maillist'))
        $result = $fivecms->mailer->update_mail($id, $values);
        break;
    case 'settings':
    	if($fivecms->managers->access('settings'))
        $result = $fivecms->settings->__set($name, $values);
        break;     
}

header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: -1");	

$json = json_encode($result);
print $json;