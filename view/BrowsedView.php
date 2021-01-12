<?PHP

require_once('View.php');

class BrowsedView extends View
{

	function fetch()
	{
		$this->body = $this->design->fetch('browsed.tpl');
		return $this->body;
	}
	
}
