<?PHP

require_once('View.php');

class WishlistView extends View
{
    var $limit = 150;

    public function __construct()
    {
        parent::__construct();
    }

    //////////////////////////////////////////
    // Основная функция
    //////////////////////////////////////////
    function fetch()
    {
        $limit = 150;
        
        $id = $this->request->get('id', 'integer');
        
        if(!empty($_COOKIE['wished_products'])) {
            $products_ids = explode(',', $_COOKIE['wished_products']);
            $products_ids = array_reverse($products_ids);
        }
        else
            $products_ids = array();
            
        if($this->request->get('action', 'string') == 'delete') {
            $key = array_search($id, $products_ids);
            unset($products_ids[$key]);    
			header('Location: /wishlist');
        }   
        elseif($id > 0) {
            array_push($products_ids, $id);
            $products_ids = array_unique($products_ids);        
        }

        $products_ids = array_slice($products_ids, 0, $limit);
        $products_ids = array_reverse($products_ids);
        
        if(!count($products_ids)) {
            unset($_COOKIE['wished_products']);
            setcookie('wished_products', '', time()-365*24*3600, '/');
        }
        else
            setcookie('wished_products', implode(',', $products_ids), time()+365*24*3600, '/');       
        
        $products = array();
        
        if(count($products_ids)) {
            
            foreach($this->products->get_products(array('id'=>$products_ids)) as $p)
                $products[$p->id] = $p;
            
            foreach($this->products->get_images(array('product_id'=>$products_ids)) as $image)
            if(isset($products[$image->product_id]))
                $products[$image->product_id]->images[] = $image;
          
            foreach($products_ids as $id)
            {  
                if(isset($products[$id]))
                {
                    if(isset($products[$id]->images[0]))
                        $products[$id]->image = $products[$id]->images[0];

                }
            }
            
        }

        // Содержимое сравнения товаров
        $this->design->assign('wished_products', $products);

        // Выводим шаблона
        return $this->design->fetch('wishlist.tpl');
    }

}
