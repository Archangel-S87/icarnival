// slider
	var Swipeslider = {
	    Container : null,
	    Items : [],
	    Index : 0,
	    Init : function(id) {
	        this.Container = document.getElementById(id);
	        for (var o = this.Container.firstChild; o; o = o.nextSibling) {
	            if (o.nodeType == 1) {
	                this.Items.push(o);
	                o.style.display = 'none';
	            };
	        };
			this.Index=0;
	        this.Show(0, true);
	        if (this.Items.length <= 1) this.Next = this.Prev = function(){};
	    },
	    Show : function(i, b) {
			if (this.Items[i].style.visibility=='hidden') {this.Show(++this.Index, true);} 
			else {
			       if (i >= 0 && i < this.Items.length) {
				this.Items[i].style.display = b ? 'table' : 'none';
				}
			}
	    },
	    Next : function() {
			this.Items[this.Index].style.display = 'none';
	        if (++this.Index >= this.Items.length) this.Index = 0;
			if (this.Items[this.Index].style.visibility=='hidden'){this.Next();} else {this.Items[this.Index].style.display = 'table';}
	    },
	    Prev : function() {
			this.Items[this.Index].style.display = 'none';
	        if (--this.Index < 0) this.Index = this.Items.length - 1;
			if (this.Items[this.Index].style.visibility=='hidden'){this.Prev();} else {this.Items[this.Index].style.display = 'table';}
	    }
	};

// color change
$(document).ready(function(){

	$(".p0").change(function(){
		chpr(this, 0);
		chprnew(this, 1);
		Swipeslider.Init('swipeimg');
	});

	$(".p1").each(function(n, elem){
		chprnew(elem, 0)
	});
	$(".p1").change(function(){
		chprnew(this, 1);
		Swipeslider.Init('swipeimg');

        //$('body').animate( { scrollTop: $('#container').offset().top }, 0 );
	});
})

function chprnew(el, num){
	if(num==0){
		chprnew(el, 1)
	} else {
		$('.blockwrapp').attr('style','visibility: hidden;')
		var color_label = "'" + $('#bigimagep1 :selected').text() + "'"	
		$('[imcolor='+color_label+']').attr('style','visibility: visible;')			
	}
}

// Swipe init
$(window).load(function() {
	Swipeslider.Init('swipeimg');
	var swipeh = new MobiSwipe("swipeimg");
	swipeh.direction = swipeh.HORIZONTAL;
	swipeh.onswiperight = function() {Swipeslider.Next();return!1};
	swipeh.onswipeleft = function() {Swipeslider.Prev();return!1};
})

// Tabs
$(document).ready(function() {
	$(".tab_content").hide();
	$("ul.tabs li:first").addClass("active").show();
	$(".tab_content:first").show();
	$("ul.tabs li").click(function() {
		$("ul.tabs li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content").hide();
		var activeTab = $(this).find("a").attr("href");
		//$(activeTab).fadeIn("fast");
		$(activeTab).show();
		$('body').animate( { scrollTop: $('ul.tabs').offset().top }, 0 );
		return false;
	});
});

