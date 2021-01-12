<?PHP

require_once('View.php');

class CompareView extends View
{

  public function __construct()
  {
		parent::__construct();

		// Если передан remove, удаляем его
		if($remove_id = intval($this->request->get('remove_id')))
		{
			$this->compare->delete_item($remove_id);
			header('location: '.$this->config->root_url.'/compare/');
		}

		// Если передан product_id
		if($product_id = $this->request->get('product_id'))
		{
			$product_ids = explode('-',$product_id);
			foreach($product_ids as $id){
				if(empty($_SESSION['compare_cart'][$id])){
					$this->compare->add_item((int)$id);
				}
			}
		}else{
			if(!empty($_SESSION['compare_cart'])){
				$url = implode('-',$_SESSION['compare_cart']);
				if($url)header('location: '.$this->config->root_url.'/compare/products/'.$url);
			}
		}

   }

	//////////////////////////////////////////
	// Основная функция
	//////////////////////////////////////////
	function fetch()
	{
        // Содержимое сравнения товаров
    	$this->design->assign('compare', $this->compare->get_compare());

		// Выводим шаблона
        return $this->design->fetch('compare.tpl');
	}
}
