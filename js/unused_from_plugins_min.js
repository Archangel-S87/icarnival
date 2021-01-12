// Scroll top
/*var scrolltotop={setting:{startline:500,scrollto:0,scrollduration:1000,fadeduration:[500,100]},controlHTML:'',controlattrs:{offsetx:6,offsety:6},anchorkeyword:'javascript:scroll(0,0)',state:{isvisible:false,shouldvisible:false},scrollup:function(){if(!this.cssfixedsupport)this.$control.css({opacity:0})
var dest=isNaN(this.setting.scrollto)?this.setting.scrollto:parseInt(this.setting.scrollto)
if(typeof dest=="string"&&jQuery('#'+dest).length==1)dest=jQuery('#'+dest).offset().top
else
dest=0
this.$body.animate({scrollTop:dest},this.setting.scrollduration);},keepfixed:function(){var $window=jQuery(window)
var controlx=$window.scrollLeft()+$window.width()-this.$control.width()-this.controlattrs.offsetx
var controly=$window.scrollTop()+$window.height()-this.$control.height()-this.controlattrs.offsety
this.$control.css({left:controlx+'px',top:controly+'px'})},togglecontrol:function(){var scrolltop=jQuery(window).scrollTop()
if(!this.cssfixedsupport)this.keepfixed()
this.state.shouldvisible=(scrolltop>=this.setting.startline)?true:false
if(this.state.shouldvisible&&!this.state.isvisible){this.$control.stop().animate({opacity:1},this.setting.fadeduration[0])
this.state.isvisible=true}else if(this.state.shouldvisible==false&&this.state.isvisible){this.$control.stop().animate({opacity:0},this.setting.fadeduration[1])
this.state.isvisible=false}},init:function(){jQuery(document).ready(function($){var mainobj=scrolltotop
var iebrws=document.all
mainobj.cssfixedsupport=!iebrws||iebrws&&document.compatMode=="CSS1Compat"&&window.XMLHttpRequest
mainobj.$body=(window.opera)?(document.compatMode=="CSS1Compat"?$('html'):$('body')):$('html,body')
mainobj.$control=$('<div id="topcontrol">'+mainobj.controlHTML+'</div>').css({position:mainobj.cssfixedsupport?'fixed':'absolute',bottom:mainobj.controlattrs.offsety,right:mainobj.controlattrs.offsetx,opacity:0,cursor:'pointer'}).attr({title:'Вверх'}).click(function(){mainobj.scrollup();return false}).appendTo('body')
if(document.all&&!window.XMLHttpRequest&&mainobj.$control.text()!='')mainobj.$control.css({width:mainobj.$control.width()})
mainobj.togglecontrol()
$('a[href="'+mainobj.anchorkeyword+'"]').click(function(){mainobj.scrollup()
return false})
$(window).bind('scroll resize',function(e){mainobj.togglecontrol()})})}}
scrolltotop.init()*/
// Cart ajax
/*$(document).on('click','#purchases1 .remove a',function(e){e.preventDefault();var ajax_variant_id=$(this).parents().closest('tr').attr('data-purchase-id');$.ajax({type:"GET",url:"ajax/cart_update.php",data:{variant:ajax_variant_id,mode:"remove"},dataType:'json',cache:false,success:function(data){cart_updating(data);}});return false;});$(document).on('change','#purchases1 .amount input',function(e){e.preventDefault();var ajax_variant_id=$(this).parents().closest('tr').attr('data-purchase-id');var ajax_amount=$(this).val();$.ajax({type:"GET",url:"ajax/cart_update.php",data:{variant:ajax_variant_id,amount:ajax_amount,mode:"update"},dataType:'json',cache:false,success:function(data){cart_updating(data);}});return false;});
function cart_updating(data){total_products=$(data.cart).filter('input[name="ajax_total"]').val();if(total_products==0){location.reload();}min_order=$(data.cart).filter('input[name="ajax_min_order"]').val();if(min_order==1){$('.del_pay_info').hide();$('.minorder').show();}else{$('.del_pay_info').show();$('.minorder').hide();}purchases=$(data.cart).find('.ajax_purchases').html();deliveries=$(data.cart).find('.ajax_deliveries').html();discount=$(data.cart).find('.ajax_discount').html();header=$(data.cart).filter('h1').html();$('.ajax_purchases').html(purchases);$('.ajax_deliveries').html(deliveries);$('.ajax_discount').html(discount);$('.content_wrapper h1').html(header);$('#cart_informer').html(data.informer);}*/

// Prevent double form submit
/*$(document).on('submit','form',function(){
	$('input[type=submit]').prop('disabled', true);
});*/
// .image_half_width open in modal
/*$(window).load(function(){
	$('img.image-half-width, .image-half-width img').click(function(){ 
		var modal_url = $(this).attr('src');
		$.fancybox({ 'href': modal_url, 'hideOnContentClick' : true });
	});
});*/