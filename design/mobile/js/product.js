// Slider
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
// Color-Size change
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
	swipeh.onswiperight = function() {Swipeslider.Prev();return!1};
	swipeh.onswipeleft = function() {Swipeslider.Next();return!1};
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
		$(activeTab).show();
		$('body').animate( { scrollTop: $('ul.tabs').offset().top }, 0 );
		return false;
	});
});
// Stars rating
$.fn.rater=function(options){var opts=$.extend({},$.fn.rater.defaults,options);return this.each(function(){var $this=$(this);var $on=$this.find('.rater-starsOn');var $off=$this.find('.rater-starsOff');opts.size=$on.height();if(opts.rating==undefined)opts.rating=$on.width()/opts.size;if(opts.id==undefined)opts.id=$this.attr('id');$off.mousemove(function(e){var left=e.clientX-$off.offset().left;var width=$off.width()-($off.width()-left);width=Math.ceil(width/(opts.size/opts.step))*opts.size/opts.step;$on.width(width);}).hover(function(e){$on.addClass('rater-starsHover');},function(e){$on.removeClass('rater-starsHover');$on.width(opts.rating*opts.size);}).click(function(e){var r=Math.round($on.width()/$off.width()*(opts.units*opts.step))/opts.step;$off.unbind('click').unbind('mousemove').unbind('mouseenter').unbind('mouseleave');$off.css('cursor','default');$on.css('cursor','default');$.fn.rater.rate($this,opts,r);}).css('cursor','pointer');$on.css('cursor','pointer');});};$.fn.rater.defaults={postHref:location.href,units:5,step:1};$.fn.rater.rate=function($this,opts,rating){var $on=$this.find('.rater-starsOn');var $off=$this.find('.rater-starsOff');$off.fadeTo(600,0.4,function(){$.ajax({url:opts.postHref,type:"POST",data:'id='+opts.id+'&rating='+rating,complete:function(req){if(req.status==200){opts.rating=parseFloat(req.responseText);if(opts.rating>0){opts.rating=parseFloat(req.responseText);$off.fadeTo(200,0.1,function(){$on.removeClass('rater-starsHover').width(opts.rating*opts.size);var $count=$this.find('.rater-rateCount');$count.text(parseInt($count.text())+1);$this.find('.rater-rating').text(opts.rating.toFixed(1));$off.fadeTo(200,1);});}else
if(opts.rating==-1){$off.fadeTo(200,0.6,function(){$this.find('.test-text').text('Вы уже голосовали!');});}else{$off.fadeTo(200,0.6,function(){$this.find('.test-text').text('Вы уже голосовали!');});}}else{alert(req.responseText);$on.removeClass('rater-starsHover').width(opts.rating*opts.size);$this.rater(opts);$off.fadeTo(2200,1);}}});});};$(function(){$('.testRater').rater({postHref:'/ajax/rating.php'});});