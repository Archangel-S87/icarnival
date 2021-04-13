<?PHP
require_once('api/Fivecms.php');

class MobthemeAdmin extends Fivecms
{	
	public function fetch()
	{		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST') && $this->request->post("save"))
		{
			$this->mobtheme->colorPrimary = $this->request->post('colorPrimary');
			$this->mobtheme->colorPrimaryDark = $this->request->post('colorPrimaryDark');
			$this->mobtheme->colorSecondPrimary = $this->request->post('colorSecondPrimary');
			$this->mobtheme->leftMenuItem = $this->request->post('leftMenuItem');
			$this->mobtheme->logoText = $this->request->post('logoText');
			$this->mobtheme->logoPhone = $this->request->post('logoPhone');
			$this->mobtheme->leftMenuItemActive = $this->request->post('leftMenuItemActive');
			$this->mobtheme->leftMenuIconActive = $this->request->post('leftMenuIconActive');
			$this->mobtheme->backgroundAccent = $this->request->post('backgroundAccent');
			$this->mobtheme->textAccent = $this->request->post('textAccent');
			$this->mobtheme->colorMain = $this->request->post('colorMain');
			$this->mobtheme->badgeBackground = $this->request->post('badgeBackground');
			$this->mobtheme->badgeBorder = $this->request->post('badgeBorder');
			$this->mobtheme->badgeText = $this->request->post('badgeText');
			$this->mobtheme->aboutBackgroundText = $this->request->post('aboutBackgroundText');
			$this->mobtheme->aboutText3 = $this->request->post('aboutText3');
			
			$this->design->assign('message_success', 'saved');
		}
		if($this->request->method('POST') && $this->request->post("saveadditional"))
		{
			$this->mobtheme->sliderbg = $this->request->post('sliderbg');
			$this->mobtheme->slidertext = $this->request->post('slidertext');
			$this->mobtheme->buybg = $this->request->post('buybg');
			$this->mobtheme->buytext = $this->request->post('buytext');
			$this->mobtheme->buybgactive = $this->request->post('buybgactive');
			$this->mobtheme->buytextactive = $this->request->post('buytextactive');
			$this->mobtheme->wishcomp = $this->request->post('wishcomp');
			$this->mobtheme->wishcompactive = $this->request->post('wishcompactive');
			$this->mobtheme->breadbg = $this->request->post('breadbg');
			$this->mobtheme->breadtext = $this->request->post('breadtext');
			$this->mobtheme->zagolovok = $this->request->post('zagolovok');
			$this->mobtheme->zagolovokbg = $this->request->post('zagolovokbg');
			$this->mobtheme->productborder = $this->request->post('productborder');
			$this->mobtheme->ballovbg = $this->request->post('ballovbg');
			$this->mobtheme->oneclickbg = $this->request->post('oneclickbg');
			$this->mobtheme->oneclicktext = $this->request->post('oneclicktext');
			
			$this->design->assign('message_success', 'savedadd');
		}

		$this->design->assign('mobtheme',	$this->mobtheme);
 	  	return $this->design->fetch('mobtheme.tpl');
	}
	
}

