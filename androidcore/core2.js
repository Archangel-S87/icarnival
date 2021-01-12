// fn.browser support
(function($) {
    var userAgent = navigator.userAgent.toLowerCase();
    $.browser = { version: (userAgent.match( /.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [0,'0'])[1], safari: /webkit/.test( userAgent ), opera: /opera/.test( userAgent ), msie: /msie/.test( userAgent ) && !/opera/.test( userAgent ), mozilla: /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ) };
})(jQuery);
// Toolbar
function hideShowSearch(el){
	$(el).toggleClass('show');
	$('#searchtop').slideToggle('fast');	
	return false;
};
function hideShowMenu(el){
	$(el).toggleClass('showcat');
	$('#catalogtop').toggleClass('showpanel');
	$('#catoverlay').toggleClass('blur');
	$('body').toggleClass('dontmove');
	return false;
};
function hideShowOverlay(el){
	$('#catalog').toggleClass('showcat');
	$('#catalogtop').toggleClass('showpanel');
	$('#catoverlay').toggleClass('blur');
	$('body').toggleClass('dontmove');
	return false;
};
$(function(){
 $('.box-category a > span').each(function(){
 if (!$('+ ul', $(this).parent()).length) {
 $(this).hide();
 }
 });
 $('.box-category a > span').click(function(e){
 e.preventDefault();
 $('+ ul', $(this).parent()).slideToggle('fast');
 $(this).parent().toggleClass('active');
 $(this).html($(this).parent().hasClass('active') ? "-" : "+");
 return false;
 });
 $('.filter-active span').click();
});
// Cfeatures
function hideShow1(el){
	$(el).toggleClass('show').siblings('div.feature_values').slideToggle('fast');
	$('.feat-block').toggleClass('show');
	return false;
};
$("#features input:checked, #features select#choosenf").closest('#content .feature_column').find('.hideBtn').toggleClass('show');
$("#features input:checked, #features select#choosenf").closest('#content .feature_values').slideToggle('normal');
function clickerdiapmin(that) {
	var pick = that.options[that.selectedIndex].text;
	if(pick) {
		$(that).closest(".feature_values").find(".diapmin").val(pick).prop('disabled', false);
	} else {
		$(that).closest(".feature_values").find(".diapmin").val(pick).prop('disabled', true);
	} 
};
function clickerdiapmax(that) {
	var pick = that.options[that.selectedIndex].text;
	if(pick) {
		$(that).closest(".feature_values").find(".diapmax").val(pick).prop('disabled', false);
	} else {
		$(that).closest(".feature_values").find(".diapmax").val(pick).prop('disabled', true);
	} 
};	
// conf
$(document).ready(function() {
  $(".cart_form, .register_form, .feedback_form, .comment_form").submit(function(event){
    if(!$(".button").is(":visible")) {
      return false;
    }
  });
});
// oneclick
$(function() {
	$('.oneclickbuy').click(function() {
        if($('.variants').find('input[name=variant]:checked').length>0) variant = $('.variants input[name=variant]:checked').val();
		if($('.variants').find('select[name=variant]').length>0) variant = $('.variants').find('select').val();
        if($('.variants').find('input.1clk').length>0) variant = $('.variants input.1clk').val();
		if($('.variants').find('input[name=amount]').length>0) amount = $('.variants input[name=amount]').val();   
        if( !$('.onename').val() || !$('.onephone').val() || !$('input.onemail').val() ) { 
            $("#btf_result").html('<div class="btf_error">Заполните все поля!</div>');
			setTimeout( function(){$(".btf_error").slideUp("slow");}, 2000);
            return false;
        }
		$.ajax({
			type: "GET",
			url: "/ajax/oneclick.php",
            data: {amount: amount, variant: variant, name: $('.onename').val(), email: $('.onemail').val(), phone: $('input.onephone').val() },
            dataType: 'json', 
			success: function(result){
				if(result > 0){
					var price = parseInt( $('.description span.price').text().replace(' ', '') );
					(window["rrApiOnReady"] = window["rrApiOnReady"] || []).push(function() {
						try {
							rrApi.order({
								transaction: result,
								items: [
									{ id: variant, qnt: amount, price: price}
								]
							});
						} catch(e) {}
					})
				}
			}
		});
        $("#oneclick").html("<div class='title'>Спасибо за заказ!</div><p>В ближайшее время с вами свяжется наш менеджер!</p><button type='submit' class='buttonred' onclick='$.fancybox.close();return false;'>Закрыть!</button>");
        return false;
    });
});
// size and color
$(document).ready(function(){
	function trysplit() {
		try {
			$(".p0").each(function(n, elem){
				chpr(elem, 0)
			});
		} catch(e) {window.location.replace(window.location);}
	}
	trysplit ();
	$(document).on('click','.p0', function(){
		$(".p0").each(function(n, elem){
			chpr(elem, 0)
		});
	});
	$(document).on('change','.p0', function(){
		chpr(this, 0)
	});
	$(document).on('change','.p1', function(){
		chpr(this, 1)
	});
})
function chpr(el, num){
		elem=$(el).closest('.variants')
		if(num==0){
			a=$(elem).find('.p0').val().split(' ')	
			$(elem).find('.p1 option').prop('disabled',true)
			for(i=0;i<a.length;i++){
				$(elem).find('.p1 .'+a[i]).removeAttr('disabled')
			}
			chpr(el, 1)
		}else{
			sel=$(elem).find('.p1 option:selected').prop('disabled')
			if(sel){
				$(elem).find('.p1 .'+a[i]).prop('selected',false)
				a=$(elem).find('.p0').val().split(' ')	
				for(i=0;i<a.length;i++){
					if(!$(elem).find('.p1 .'+a[i]).prop('disabled')){
						$(elem).find('.p1 .'+a[i]).prop('selected',true);
						break;
					}
				}
			}
			z='';
			a0=$(elem).find('.p0').val().split(' ')	
			a1=$(elem).find('.p1').val().split(' ')	
			for(i0=0;i0<a0.length;i0++){
			for(i1=0;i1<a1.length;i1++){
				if(a0[i0]==a1[i1])
					z=a0[i0]
			}
			}
			$(elem).find('#vhidden').val( z.substring(1, z.length) )	
			$(elem).find('.price').html( $(elem).find('.pricelist .'+z).html() )
			$(elem).find('.unit').html( $(elem).find('.pricelist .'+z).attr('v_unit') )
			$(elem).find('.bonusnum').html( $(elem).find('.pricelist .'+z).attr('v_bonus') )
			$(elem).find('.sku').html( $(elem).find('.pricelist .'+z).attr('v_sku') )
			$(elem).find('.stock').html( $(elem).find('.pricelist .'+z).attr('v_stock') )
			$(elem).find('.compare_price').html( $(elem).find('.pricelist2 .'+z).html() )	
			
			maxamount=parseInt($(elem).find('.pricelist .'+z).attr('v_stock'));
			$('.productview #amount .amount').attr('data-max',maxamount);
			if($.isNumeric(maxamount)){
				oldamount=parseInt($('.productview #amount .amount').val());
				if(oldamount>maxamount)$('.productview #amount .amount').val(maxamount);
			}
		}
}
// Wish Compare
$(document).ready(function(){$(document).on('click','.towish .basewc',function(){var button=$(this);$('.mainloader').attr('style',"display:block;");$.ajax({url:"ajax/wishlist.php",data:{id:$(this).attr('data-wish')},success:function(data){$('.mainloader').attr('style',"display:none;");$('#wishlist').html(data);button.parent().find('.basewc').hide();button.parent().find('.activewc').show();}});return false;});$(document).on('click','#wishlist a.delete', function(){$.ajax({url:"ajax/wishlist.php",data:{id:$(this).attr('data-wish'),action:$(this).attr('delete')},});return false;});});$(document).on('click','.compare .basewc',function(){var val=$(this).attr('data-wish');var bl=$(this).closest('.compare');var button2=$(this);$('.mainloader').attr('style',"display:block;");$.ajax({url:"ajax/compare.php",data:{compare:val},dataType:'json',success:function(data){if(data){$('.mainloader').attr('style',"display:none;");$('#compare_informer').html(data);button2.parent().find('.basewc').hide();button2.parent().find('.activewc').show();}}});return false;});
// pricechange
$(function() {
	$(document).on('change', 'select[name=variant]', function () {
	//$('select[name=variant]').change(function() {
		price = $(this).find('option:selected').attr('price');
		sku = '';
		unit = '';
		bonus = '';
		sku = $(this).find('option:selected').attr('v_sku');
		unit = $(this).find('option:selected').attr('v_unit');
		bonus = $(this).find('option:selected').attr('v_bonus');
		stock = $(this).find('option:selected').attr('v_stock');
		compare_price = '';
		if(typeof $(this).find('option:selected').attr('compare_price') == 'string')
			compare_price = $(this).find('option:selected').attr('compare_price');
		//$(this).find('option:selected').attr('compare_price');
		$(this).closest('form').find('span.price').html(price);
		$(this).closest('form').find('.compare_price').html(compare_price);
		$(this).closest('form').find('.sku').html(sku);
		$(this).closest('form').find('.unit').html(unit);
		$(this).closest('form').find('.bonusnum').html(bonus);
		$(this).closest('form').find('.stock').html(stock);
		return false;		
	});
});
// cart
$(document).on('submit','form.variants', function(e) {
	e.preventDefault();
	button = $(this).find('input[type="submit"]');
	if($(this).find('input[name=variant]:checked').length>0)
		variant = $(this).find('input[name=variant]:checked').val();
	else if($(this).find('input[name=variant]').length>0)
		variant = $(this).find('input[name=variant]').val();
	if($(this).find('select[name=variant]').length>0)
		variant = $(this).find('select').val();
	var amnt = $(this).find('input[name="amount"]').val();
	if (amnt<1){amnt=1};
	$('.mainloader').attr('style',"display:block;");
	cartload();
	function cartload(){
		$.ajax({
			url: "ajax/cart.php",
			data: {variant: variant,'mode':'add',amount: amnt},
			dataType: 'json',
			success: function(data){
				$('#cart_informer').html(data);
				if(button.attr('data-result-text'))
					button.val(button.attr('data-result-text'));
				button.addClass('hover');
				$('.mainloader').attr('style',"display:none;");    
			}, error : function(xhr, ajaxOptions, thrownError){setTimeout(cartload, 2000)}
		});
	};
	return false;
});
// comments pagination
$(document).ready(function(){
	var show_per_page = 10; 
	var number_of_items = $('.comment_list').children().length;
	var number_of_pages = Math.ceil(number_of_items/show_per_page);
	$('#current_page').val(0);
	$('#show_per_page').val(show_per_page);
	var navigation_html = '<a class="previous_link" href="javascript:previous();">&laquo;</a>';
	var current_link = 0;
	while(number_of_pages > current_link){
		navigation_html += '<a class="page_link" href="javascript:go_to_page(' + current_link +')" longdesc="' + current_link +'">'+ (current_link + 1) +'</a>';
		current_link++;
	}
	navigation_html += '<a class="next_link" href="javascript:next();">&raquo;</a>';
	$('#comments #page_navigation').html(navigation_html);
	$('#comments #page_navigation .page_link:first').addClass('selected');
	$('#comments .comment_list').children().css('display', 'none');
	$('#comments .comment_list').children().slice(0, show_per_page).css('display', 'block');
});
function previous(){
	new_page = parseInt($('#current_page').val()) - 1;
	if($('.selected').prev('.page_link').length==true){
		go_to_page(new_page);
	}
}
function next(){
	new_page = parseInt($('#current_page').val()) + 1;
	if($('.selected').next('.page_link').length==true){
		go_to_page(new_page);
	}
}
function go_to_page(page_num){
	var show_per_page = parseInt($('#show_per_page').val());
	start_from = page_num * show_per_page;
	end_on = start_from + show_per_page;
	$('#comments .comment_list').children().css('display', 'none').slice(start_from, end_on).css('display', 'block');
	$('#comments .page_link[longdesc=' + page_num +']').addClass('selected').siblings('.selected').removeClass('selected');
	$('#comments #current_page').val(page_num);
}
// функция toggleText
$.fn.extend({
	toggleText: function(a, b){
		return this.text(this.text() == b ? a : b);
	}
});
// User forms handler	
$(window).load(function(){
	$('.showform').click(function(){ 
		var buttonId = $(this).attr('data-id');
		$('#'+buttonId+' .hideablebutton').addClass('form_submit');
		$.fancybox({ 'href':'#'+buttonId,scrolling:'no',margin:'13' });
	});
	$(document).on('click','.form_submit', function(){ 
		var form_approve = true;
		var formId = $(this).attr('data-formid');
		var $data = {};
		$('#'+formId+' .readform').find ('input, textarea, select').each(function() {
			if($(this).attr('required') && $(this).val().length == 0) {
				$(this).addClass('required');
				errorUserForm(formId,'Заполните обязательные поля!');
				form_approve = false;
				return false;
			}
			/*if(this.name == 'f-name'|| this.name == 'f-email')
				$data[this.name] = $(this).val();
		  	else
		  		$data[this.name] = $(this).attr('placeholder')+' : '+$(this).val();*/
		  	$data[this.name] = $(this).attr('placeholder')+' : '+$(this).val();	
		});
		$data['f-url'] = 'Со страницы : '+document.location.href;
		if(form_approve)
			sendUserForm(formId,$data);
	});
	$(document).on('focus', '.readform input', function () {
		$(this).removeClass('required');
	});
	function errorUserForm(formId,text){ 
		$('#'+formId+' .form_result').html('<div class="form_error">'+text+'</div>');
		setTimeout(function(){ $('#'+formId+' .form_error').slideUp("slow"); },3000);
	}
	function sendUserForm(formId,$data){ 
		// antibot
		if($('#'+formId+' .check_inp[name="btfalse"]').is(':checked')) {
			errorUserForm(formId,'Не пройдена проверка на бота!');
			return false;
		}
		if($('#'+formId+' .check_inp[name="bttrue"]').is(':checked')) {
			$.ajax({ 
				type:"POST",
				url:"ajax/form.php",
				data: $data,
				success:function(result){ 
					if(result=='form_success'){ 
						$('#'+formId+' .form_result').html('<div class="form_success">Сообщение отправлено</div>');
						$('#'+formId+' .user_form_main').css('display','none');
						setTimeout(function(){ $.fancybox.close(); },2000);
					} else {
						errorUserForm(formId,'Ошибка отправки, попробуйте чуть позже');
					}
				}
			});
		} else {
			errorUserForm(formId,'Не пройдена проверка на бота!');
			$('#'+formId+' .check_bt').addClass('look_here');
			return false;
		}
	}
});
// Cookie handler
function createCookie(name,value,days){if(days){var date=new Date();date.setTime(date.getTime()+(days*24*60*60*1000));var expires="; expires="+date.toGMTString();}else var expires="";document.cookie=name+"="+value+expires+"; path=/";}
function readCookie(name){var nameEQ=name+"=";var ca=document.cookie.split(';');for(var i=0;i<ca.length;i++){var c=ca[i];while(c.charAt(0)==' ')c=c.substring(1,c.length);if(c.indexOf(nameEQ)==0)return c.substring(nameEQ.length,c.length);}return null;}
// IE version
function ieVersion(){var rv=10;if(navigator.appName == 'Microsoft Internet Explorer'){var ua = navigator.userAgent;var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");if(re.exec(ua) != null) rv = parseFloat( RegExp.$1 );}return rv;}
// Placeholder IE < 10
if (ieVersion()<10) {(function(j,p){j(function(){j("["+p+"]").focus(function(){var i=j(this);if(i.val()===i.attr(p)){i.val("").removeClass(p)}}).blur(function(){var i=j(this);if(i.val()===""||i.val()===i.attr(p)){i.addClass(p).val(i.attr(p))}}).blur().parents("form").submit(function(){j(this).find(p).each(function(){var i=j(this);if(i.val()===i.attr(p)){i.val("")}})})})})(jQuery,"placeholder");}
// Check antibot & confpolicy before submit
$('.main_cart_form, .cartview form[name=cart], .register_form, .feedback_form, .comment_form, .user_form, #subscribe').submit(function(){ 
	if(!$(this).find('input[name=bttrue]').is(':checked') || $(this).find('input[name=btfalse]').is(':checked')) { 
	    $(this).find('.check_bt').addClass('look_here');
	    return false;
	} else {
	    $(this).find('.check_bt').removeClass('look_here');
	}
	if(!$(this).find('.button').is(":visible")) {
    	return false;
    }
});
$('.check_bt').click(function(){
	$(this).removeClass('look_here');
});
// error text handler
$(window).load(function(){
	if($('.message_error').length){ 
		var offset_top='.message_error';
		$('html, body').animate({ scrollTop:$(offset_top).offset().top - 60},500);
	}	
});
// Check error in cart
$('.cartview form[name=cart]').submit(function(){ 
	if($('.message_error').length){ 
		$(this).find('.message_error').addClass('look_here');
		var offset_top='.message_error';
		$('html, body').animate({ scrollTop:$(offset_top).offset().top - 60},500);
		return false;
	} else {
	    $(this).find('.message_error').removeClass('look_here');
	}	
});
// Scroll anchor function
$('.anchor').click(function(){ 
	var offset_top=$(this).attr('data-anchor');
	$('html, body').animate({ scrollTop:$(offset_top).offset().top + 60},500);
});
// .izoom & .image_half_width open in modal
$(window).load(function(){
	$('.izoom, img.image-half-width, .image-half-width img').click(function(){ 
		var modal_url = $(this).attr('src');
		$.fancybox({ 'href': modal_url, 'hideOnContentClick' : true });
	});
});
// .url redirect
$(window).load(function(){
	$('.url').click(function(){ 
		var url = $(this).attr('data-url');
		if(/iPhone|iPad|iPod/i.test(navigator.userAgent)){
			window.location = url;
		} else {
			window.open(url,'_blank');
		}
	});
});
/*
 * FancyBox - jQuery Plugin Version: 1.3.4 Requires: jQuery v1.3+ adapted for v1.9
 */
;(function(b){var m,t,u,f,D,j,E,n,z,A,q=0,e={},o=[],p=0,d={},l=[],G=null,v=new Image,J=/\.(jpg|gif|png|bmp|jpeg)(.*)?$/i,W=/[^\.]\.(swf)\s*$/i,K,L=1,y=0,s="",r,i,h=false,B=b.extend(b("<div/>")[0],{prop:0}),M=b.browser.msie&&b.browser.version<7&&!window.XMLHttpRequest,N=function(){t.hide();v.onerror=v.onload=null;G&&G.abort();m.empty()},O=function(){if(false===e.onError(o,q,e)){t.hide();h=false}else{e.titleShow=false;e.width="auto";e.height="auto";m.html('<p id="fancybox-error">The requested content cannot be loaded.<br />Please try again later.</p>');
F()}},I=function(){var a=o[q],c,g,k,C,P,w;N();e=b.extend({},b.fn.fancybox.defaults,typeof b(a).data("fancybox")=="undefined"?e:b(a).data("fancybox"));w=e.onStart(o,q,e);if(w===false)h=false;else{if(typeof w=="object")e=b.extend(e,w);k=e.title||(a.nodeName?b(a).attr("title"):a.title)||"";if(a.nodeName&&!e.orig)e.orig=b(a).children("img:first").length?b(a).children("img:first"):b(a);if(k===""&&e.orig&&e.titleFromAlt)k=e.orig.attr("alt");c=e.href||(a.nodeName?b(a).attr("href"):a.href)||null;if(/^(?:javascript)/i.test(c)||
c=="#")c=null;if(e.type){g=e.type;if(!c)c=e.content}else if(e.content)g="html";else if(c)g=c.match(J)?"image":c.match(W)?"swf":b(a).hasClass("iframe")?"iframe":c.indexOf("#")===0?"inline":"ajax";if(g){if(g=="inline"){a=c.substr(c.indexOf("#"));g=b(a).length>0?"inline":"ajax"}e.type=g;e.href=c;e.title=k;if(e.autoDimensions)if(e.type=="html"||e.type=="inline"||e.type=="ajax"){e.width="auto";e.height="auto"}else e.autoDimensions=false;if(e.modal){e.overlayShow=true;e.hideOnOverlayClick=false;e.hideOnContentClick=
false;e.enableEscapeButton=false;e.showCloseButton=false}e.padding=parseInt(e.padding,10);e.margin=parseInt(e.margin,10);m.css("padding",e.padding+e.margin);b(".fancybox-inline-tmp").unbind("fancybox-cancel").bind("fancybox-change",function(){b(this).replaceWith(j.children())});switch(g){case "html":m.html(e.content);F();break;case "inline":if(b(a).parent().is("#fancybox-content")===true){h=false;break}b('<div class="fancybox-inline-tmp" />').hide().insertBefore(b(a)).bind("fancybox-cleanup",function(){b(this).replaceWith(j.children())}).bind("fancybox-cancel", function(){b(this).replaceWith(m.children())});b(a).appendTo(m);F();break;case "image":h=false;b.fancybox.showActivity();v=new Image;v.onerror=function(){O()};v.onload=function(){h=true;v.onerror=v.onload=null;e.width=v.width;e.height=v.height;b("<img />").attr({id:"fancybox-img",src:v.src,alt:e.title}).appendTo(m);Q()};v.src=c;break;case "swf":e.scrolling="no";C='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+e.width+'" height="'+e.height+'"><param name="movie" value="'+c+
'"></param>';P="";b.each(e.swf,function(x,H){C+='<param name="'+x+'" value="'+H+'"></param>';P+=" "+x+'="'+H+'"'});C+='<embed src="'+c+'" type="application/x-shockwave-flash" width="'+e.width+'" height="'+e.height+'"'+P+"></embed></object>";m.html(C);F();break;case "ajax":h=false;b.fancybox.showActivity();e.ajax.win=e.ajax.success;G=b.ajax(b.extend({},e.ajax,{url:c,data:e.ajax.data||{},error:function(x){x.status>0&&O()},success:function(x,H,R){if((typeof R=="object"?R:G).status==200){if(typeof e.ajax.win==
"function"){w=e.ajax.win(c,x,H,R);if(w===false){t.hide();return}else if(typeof w=="string"||typeof w=="object")x=w}m.html(x);F()}}}));break;case "iframe":Q()}}else O()}},F=function(){var a=e.width,c=e.height;a=a.toString().indexOf("%")>-1?parseInt((b(window).width()-e.margin*2)*parseFloat(a)/100,10)+"px":a=="auto"?"auto":a+"px";c=c.toString().indexOf("%")>-1?parseInt((b(window).height()-e.margin*2)*parseFloat(c)/100,10)+"px":c=="auto"?"auto":c+"px";m.wrapInner('<div style="width:'+a+";height:"+c+
";overflow: "+(e.scrolling=="auto"?"auto":e.scrolling=="yes"?"scroll":"hidden")+';position:relative;"></div>');e.width=m.width();e.height=m.height();Q()},Q=function(){var a,c;t.hide();if(f.is(":visible")&&false===d.onCleanup(l,p,d)){b('.fancybox-inline-tmp').trigger('fancybox-cancel');h=false}else{h=true;b(j.add(u)).unbind();b(window).unbind("resize.fb scroll.fb");b(document).unbind("keydown.fb");f.is(":visible")&&d.titlePosition!=="outside"&&f.css("height",f.height());l=o;p=q;d=e;if(d.overlayShow){u.css({"background-color":d.overlayColor,
opacity:d.overlayOpacity,cursor:d.hideOnOverlayClick?"pointer":"auto",height:b(document).height()});if(!u.is(":visible")){M&&b("select:not(#fancybox-tmp select)").filter(function(){return this.style.visibility!=="hidden"}).css({visibility:"hidden"}).one("fancybox-cleanup",function(){this.style.visibility="inherit"});u.show()}}else u.hide();i=X();s=d.title||"";y=0;n.empty().removeAttr("style").removeClass();if(d.titleShow!==false){if(b.isFunction(d.titleFormat))a=d.titleFormat(s,l,p,d);else a=s&&s.length?
d.titlePosition=="float"?'<table id="fancybox-title-float-wrap" cellpadding="0" cellspacing="0"><tr><td id="fancybox-title-float-left"></td><td id="fancybox-title-float-main">'+s+'</td><td id="fancybox-title-float-right"></td></tr></table>':'<div id="fancybox-title-'+d.titlePosition+'">'+s+"</div>":false;s=a;if(!(!s||s==="")){n.addClass("fancybox-title-"+d.titlePosition).html(s).appendTo("body").show();switch(d.titlePosition){case "inside":n.css({width:i.width-d.padding*2,marginLeft:d.padding,marginRight:d.padding});
y=n.outerHeight(true);n.appendTo(D);i.height+=y;break;case "over":n.css({marginLeft:d.padding,width:i.width-d.padding*2,bottom:d.padding}).appendTo(D);break;case "float":n.css("left",parseInt((n.width()-i.width-40)/2,10)*-1).appendTo(f);break;default:n.css({width:i.width-d.padding*2,paddingLeft:d.padding,paddingRight:d.padding}).appendTo(f)}}}n.hide();if(f.is(":visible")){b(E.add(z).add(A)).hide();a=f.position();r={top:a.top,left:a.left,width:f.width(),height:f.height()};c=r.width==i.width&&r.height==
i.height;j.fadeTo(d.changeFade,0.3,function(){var g=function(){j.html(m.contents()).fadeTo(d.changeFade,1,S)};b('.fancybox-inline-tmp').trigger('fancybox-change');j.empty().removeAttr("filter").css({"border-width":d.padding,width:i.width-d.padding*2,height:e.autoDimensions?"auto":i.height-y-d.padding*2});if(c)g();else{B.prop=0;b(B).animate({prop:1},{duration:d.changeSpeed,easing:d.easingChange,step:T,complete:g})}})}else{f.removeAttr("style");j.css("border-width",d.padding);if(d.transitionIn=="elastic"){r=V();j.html(m.contents());
f.show();if(d.opacity)i.opacity=0;B.prop=0;b(B).animate({prop:1},{duration:d.speedIn,easing:d.easingIn,step:T,complete:S})}else{d.titlePosition=="inside"&&y>0&&n.show();j.css({width:i.width-d.padding*2,height:e.autoDimensions?"auto":i.height-y-d.padding*2}).html(m.contents());f.css(i).fadeIn(d.transitionIn=="none"?0:d.speedIn,S)}}}},Y=function(){if(d.enableEscapeButton||d.enableKeyboardNav)b(document).bind("keydown.fb",function(a){if(a.keyCode==27&&d.enableEscapeButton){a.preventDefault();b.fancybox.close()}else if((a.keyCode==
37||a.keyCode==39)&&d.enableKeyboardNav&&a.target.tagName!=="INPUT"&&a.target.tagName!=="TEXTAREA"&&a.target.tagName!=="SELECT"){a.preventDefault();b.fancybox[a.keyCode==37?"prev":"next"]()}});if(d.showNavArrows){if(d.cyclic&&l.length>1||p!==0)z.show();if(d.cyclic&&l.length>1||p!=l.length-1)A.show()}else{z.hide();A.hide()}},S=function(){if(!b.support.opacity){j.get(0).style.removeAttribute("filter");f.get(0).style.removeAttribute("filter")}e.autoDimensions&&j.css("height","auto");f.css("height","auto");
s&&s.length&&n.show();d.showCloseButton&&E.show();Y();d.hideOnContentClick&&j.bind("click",b.fancybox.close);d.hideOnOverlayClick&&u.bind("click",b.fancybox.close);b(window).bind("resize.fb",b.fancybox.resize);d.centerOnScroll&&b(window).bind("scroll.fb",b.fancybox.center);if(d.type=="iframe")b('<iframe id="fancybox-frame" name="fancybox-frame'+(new Date).getTime()+'" frameborder="0" hspace="0" '+(b.browser.msie?'allowtransparency="true""':"")+' scrolling="'+e.scrolling+'" src="'+d.href+'"></iframe>').appendTo(j);
f.show();h=false;b.fancybox.center();d.onComplete(l,p,d);var a,c;if(l.length-1>p){a=l[p+1].href;if(typeof a!=="undefined"&&a.match(J)){c=new Image;c.src=a}}if(p>0){a=l[p-1].href;if(typeof a!=="undefined"&&a.match(J)){c=new Image;c.src=a}}},T=function(a){var c={width:parseInt(r.width+(i.width-r.width)*a,10),height:parseInt(r.height+(i.height-r.height)*a,10),top:parseInt(r.top+(i.top-r.top)*a,10),left:parseInt(r.left+(i.left-r.left)*a,10)};if(typeof i.opacity!=="undefined")c.opacity=a<0.5?0.5:a;f.css(c);
j.css({width:c.width-d.padding*2,height:c.height-y*a-d.padding*2})},U=function(){return[b(window).width()-d.margin*2,b(window).height()-d.margin*2,b(document).scrollLeft()+d.margin,b(document).scrollTop()+d.margin]},X=function(){var a=U(),c={},g=d.autoScale,k=d.padding*2;c.width=d.width.toString().indexOf("%")>-1?parseInt(a[0]*parseFloat(d.width)/100,10):d.width+k;c.height=d.height.toString().indexOf("%")>-1?parseInt(a[1]*parseFloat(d.height)/100,10):d.height+k;if(g&&(c.width>a[0]||c.height>a[1]))if(e.type==
"image"||e.type=="swf"){g=d.width/d.height;if(c.width>a[0]){c.width=a[0];c.height=parseInt((c.width-k)/g+k,10)}if(c.height>a[1]){c.height=a[1];c.width=parseInt((c.height-k)*g+k,10)}}else{c.width=Math.min(c.width,a[0]);c.height=Math.min(c.height,a[1])}c.top=parseInt(Math.max(a[3]-20,a[3]+(a[1]-c.height-40)*0.5),10);c.left=parseInt(Math.max(a[2]-20,a[2]+(a[0]-c.width-40)*0.5),10);return c},V=function(){var a=e.orig?b(e.orig):false,c={};if(a&&a.length){c=a.offset();c.top+=parseInt(a.css("paddingTop"),
10)||0;c.left+=parseInt(a.css("paddingLeft"),10)||0;c.top+=parseInt(a.css("border-top-width"),10)||0;c.left+=parseInt(a.css("border-left-width"),10)||0;c.width=a.width();c.height=a.height();c={width:c.width+d.padding*2,height:c.height+d.padding*2,top:c.top-d.padding-20,left:c.left-d.padding-20}}else{a=U();c={width:d.padding*2,height:d.padding*2,top:parseInt(a[3]+a[1]*0.5,10),left:parseInt(a[2]+a[0]*0.5,10)}}return c},Z=function(){if(t.is(":visible")){b("div",t).css("top",L*-40+"px");L=(L+1)%12}else clearInterval(K)};
b.fn.fancybox=function(a){if(!b(this).length)return this;b(this).data("fancybox",b.extend({},a,b.metadata?b(this).metadata():{})).unbind("click.fb").bind("click.fb",function(c){c.preventDefault();if(!h){h=true;b(this).blur();o=[];q=0;c=b(this).attr("data-rel")||"";if(!c||c==""||c==="nofollow")o.push(this);else{o=b("a[data-rel="+c+"], area[rel="+c+"]");q=o.index(this)}I()}});return this};b.fancybox=function(a,c){var g;if(!h){h=true;g=typeof c!=="undefined"?c:{};o=[];q=parseInt(g.index,10)||0;if(b.isArray(a)){for(var k=
0,C=a.length;k<C;k++)if(typeof a[k]=="object")b(a[k]).data("fancybox",b.extend({},g,a[k]));else a[k]=b({}).data("fancybox",b.extend({content:a[k]},g));o=jQuery.merge(o,a)}else{if(typeof a=="object")b(a).data("fancybox",b.extend({},g,a));else a=b({}).data("fancybox",b.extend({content:a},g));o.push(a)}if(q>o.length||q<0)q=0;I()}};b.fancybox.showActivity=function(){clearInterval(K);t.show();K=setInterval(Z,66)};b.fancybox.hideActivity=function(){t.hide()};b.fancybox.next=function(){return b.fancybox.pos(p+
1)};b.fancybox.prev=function(){return b.fancybox.pos(p-1)};b.fancybox.pos=function(a){if(!h){a=parseInt(a);o=l;if(a>-1&&a<l.length){q=a;I()}else if(d.cyclic&&l.length>1){q=a>=l.length?0:l.length-1;I()}}};b.fancybox.cancel=function(){if(!h){h=true;b('.fancybox-inline-tmp').trigger('fancybox-cancel');N();e.onCancel(o,q,e);h=false}};b.fancybox.close=function(){function a(){u.fadeOut("fast");n.empty().hide();f.hide();b('.fancybox-inline-tmp, select:not(#fancybox-tmp select)').trigger('fancybox-cleanup');j.empty();d.onClosed(l,p,d);l=e=[];p=q=0;d=e={};h=false}if(!(h||f.is(":hidden"))){h=
true;if(d&&false===d.onCleanup(l,p,d))h=false;else{N();b(E.add(z).add(A)).hide();b(j.add(u)).unbind();b(window).unbind("resize.fb scroll.fb");b(document).unbind("keydown.fb");j.find("iframe").attr("src",M&&/^https/i.test(window.location.href||"")?"javascript:void(false)":"about:blank");d.titlePosition!=="inside"&&n.empty();f.stop();if(d.transitionOut=="elastic"){r=V();var c=f.position();i={top:c.top,left:c.left,width:f.width(),height:f.height()};if(d.opacity)i.opacity=1;n.empty().hide();B.prop=1;
b(B).animate({prop:0},{duration:d.speedOut,easing:d.easingOut,step:T,complete:a})}else f.fadeOut(d.transitionOut=="none"?0:d.speedOut,a)}}};b.fancybox.resize=function(){u.is(":visible")&&u.css("height",b(document).height());b.fancybox.center(true)};b.fancybox.center=function(a){var c,g;if(!h){g=a===true?1:0;c=U();!g&&(f.width()>c[0]||f.height()>c[1])||f.stop().animate({top:parseInt(Math.max(c[3]-20,c[3]+(c[1]-j.height()-40)*0.5-d.padding)),left:parseInt(Math.max(c[2]-20,c[2]+(c[0]-j.width()-40)*0.5-
d.padding))},typeof a=="number"?a:200)}};b.fancybox.init=function(){if(!b("#fancybox-wrap").length){b("body").append(m=b('<div id="fancybox-tmp"></div>'),t=b('<div id="fancybox-loading"><div></div></div>'),u=b('<div id="fancybox-overlay"></div>'),f=b('<div id="fancybox-wrap"></div>'));D=b('<div id="fancybox-outer"></div>').appendTo(f);
D.append(j=b('<div id="fancybox-content"></div>'),E=b('<a id="fancybox-close"></a>'),n=b('<div id="fancybox-title"></div>'),z=b('<a href="javascript:;" id="fancybox-left"><span class="fancy-ico" id="fancybox-left-ico"></span></a>'),A=b('<a href="javascript:;" id="fancybox-right"><span class="fancy-ico" id="fancybox-right-ico"></span></a>'));E.click(b.fancybox.close);t.click(b.fancybox.cancel);z.click(function(a){a.preventDefault();b.fancybox.prev()});A.click(function(a){a.preventDefault();b.fancybox.next()});
b.fn.mousewheel&&f.bind("mousewheel.fb",function(a,c){if(h)a.preventDefault();else if(b(a.target).get(0).clientHeight==0||b(a.target).get(0).scrollHeight===b(a.target).get(0).clientHeight){a.preventDefault();b.fancybox[c>0?"prev":"next"]()}});b.support.opacity||f.addClass("fancybox-ie");if(M){t.addClass("fancybox-ie6");f.addClass("fancybox-ie6");b('<iframe id="fancybox-hide-sel-frame" src="'+(/^https/i.test(window.location.href||"")?"javascript:void(false)":"about:blank")+'" scrolling="no" border="0" frameborder="0" tabindex="-1"></iframe>').prependTo(D)}}};
b.fn.fancybox.defaults={padding:10,margin:40,opacity:false,modal:false,cyclic:false,scrolling:"auto",width:560,height:340,autoScale:true,autoDimensions:true,centerOnScroll:true,ajax:{},swf:{wmode:"transparent"},hideOnOverlayClick:true,hideOnContentClick:false,overlayShow:true,overlayOpacity:0.6,overlayColor:"#777",titleShow:true,titlePosition:"float",titleFormat:null,titleFromAlt:false,transitionIn:"fade",transitionOut:"fade",speedIn:300,speedOut:300,changeSpeed:300,changeFade:"fast",easingIn:"swing",
easingOut:"swing",showCloseButton:true,showNavArrows:true,enableEscapeButton:true,enableKeyboardNav:true,onStart:function(){},onCancel:function(){},onComplete:function(){},onCleanup:function(){},onClosed:function(){},onError:function(){}};b(document).ready(function(){b.fancybox.init()})})(jQuery);