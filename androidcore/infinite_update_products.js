if($.browser.msie || $.browser.mozilla) $('.showselect').css('display','inline-block');
$(document).ready(function(){
	function trysplit() {
		try {
			$(".p0").each(function(n, elem){
				chpr(elem, 0)
			});
		} catch(e) {window.location.replace(window.location);}
	}
	trysplit ();
	$(document).on('change','.p0', function(){
		chpr(this, 0)
	});
	$(document).on('change','.p1', function(){
		chpr(this, 1)
	});
})
