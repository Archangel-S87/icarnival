this.imagePreview = function(){	
	/* CONFIG */
		
//		xOffset = 270;
//		yOffset = 200;
		xOffset = 150;
		yOffset = 10;

		
		// these 2 variable determine popup's distance from the cursor
		// you might want to adjust to get the right result
		
	/* END CONFIG */
	$("a.preview").hover(function(e){
		this.t = this.title;
		this.title = "";	
		var c = (this.t != "") ? "<br/>" + this.t : "";
		//$("body").append("<p id='preview'><img src='"+ $(this).attr("rel") +"' alt='' />"+ c +"</p>");								 
		$("body").append("<p id='preview'><img class='previewimg' src='"+ $(this).attr("rel") +"' /></p>");	
		$("#preview")
			.css("top",(e.pageY - xOffset) + "px")
			.css("left",(e.pageX + yOffset) + "px")
			.fadeIn("fast");						
    },
	function(){
		this.title = this.t;	
		$("#preview").remove();
    });	
	$("a.preview").mousemove(function(e){
		$("#preview")
			.css("top",(e.pageY - xOffset) + "px")
			.css("left",(e.pageX + yOffset) + "px");
	});			
};


// starting the script on page load
$(document).ready(function(){
	imagePreview();
});