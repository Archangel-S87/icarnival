<?PHP
require_once('api/Fivecms.php');

class SetCatAdmin extends Fivecms
{	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST')){
			
			if($this->request->post('clear_cache')){
				$this->cache->clearall();
				$this->design->assign('message_success', 'cache_cleared');
			} else {
				$this->settings->decimals_point = $this->request->post('decimals_point');
				$this->settings->thousands_separator = $this->request->post('thousands_separator');
				$this->settings->products_num = $this->request->post('products_num');
				$this->settings->products_num_admin = $this->request->post('products_num_admin');
				$this->settings->max_order_amount = $this->request->post('max_order_amount');	
				$this->settings->units = $this->request->post('units');
				$this->settings->units_list = $this->request->post('units_list');
				$this->settings->sort_by = $this->request->post('sort_by');	
				$this->settings->b9manage = $this->request->post('b9manage');
				$this->settings->show_brands = $this->request->post('show_brands');
				$this->settings->b10manage = $this->request->post('b10manage');
				$this->settings->sizemanage = $this->request->post('sizemanage');
				$this->settings->colormanage = $this->request->post('colormanage');
				$this->settings->showinstock = $this->request->post('showinstock');
				$this->settings->minorder = $this->request->post('minorder');
				$this->settings->prods_views = $this->request->post('prods_views');
				$this->settings->prods_rating = $this->request->post('prods_rating');
				$this->settings->prods_votes = $this->request->post('prods_votes');
				$this->settings->cutouter = $this->request->post('cutouter');
				$this->settings->cutseo = $this->request->post('cutseo');
			
				$this->settings->showsku = $this->request->post('showsku');
				$this->settings->showstock = $this->request->post('showstock');
				$this->settings->youtube_product = $this->request->post('youtube_product');
				$this->settings->youtube_key = $this->request->post('youtube_key');
			
				$this->settings->cached = $this->request->post('cached');
				$this->settings->cache_type = $this->request->post('cache_type');
				$this->settings->cache_time = $this->request->post('cache_time');
				$this->settings->ex_cached = $this->request->post('ex_cached');
			
				$this->settings->vendor_model = $this->request->post('vendor_model');
				$this->settings->export_not_in_stock = $this->request->post('export_not_in_stock');
				$this->settings->ym_delivery = $this->request->post('ym_delivery');
				$this->settings->for_retail_store = $this->request->post('for_retail_store');
				$this->settings->for_reservation = $this->request->post('for_reservation');
				$this->settings->short_description = $this->request->post('short_description');
				$this->settings->manufacturer_warranty = $this->request->post('manufacturer_warranty');
				$this->settings->seller_warranty = $this->request->post('seller_warranty');
				$this->settings->sales_notes = $this->request->post('sales_notes');
			
				$this->design->assign('message_success', 'saved');
			}
		}

 	  	return $this->design->fetch('setcat.tpl');
	}
	
}

