$(document).ready(function(){$('.super-menu > li').hover(function(){$('> div, > ul',this).hide();$('> div, > ul',this).css({'visibility':'visible','opacity':'1'});$('> div, > ul',this).stop(true,true).show();},function(){$('> div, > ul',this).stop(true,true).delay(300).fadeOut();});});$(function(){$('.box-category a > span').each(function(){if(!$('+ ul',$(this).parent()).length){$(this).hide();}});$('.box-category a > span').click(function(e){e.preventDefault();$('+ ul',$(this).parent()).toggle(100);$(this).parent().toggleClass('active');$(this).html($(this).parent().hasClass('active')?"-":"+");return false;});$('.filter-active span').click();});
// Search type
$(".searchchoose").click(function(){$('.listsearch').toggle();});
$(document).ready(function(){type=$('#search form').attr('action');if(type=="products"){initSearch();$('.autocomplete-suggestions').removeClass('hide');}else{$('.autocomplete-suggestions').addClass('hide');}});$(".listsearch li").click(function(){$('.listsearch').toggle();type=$(this).attr('data-type');typetitle=$(this).text();if(type=="products"){initSearch();$('.autocomplete-suggestions').removeClass('hide');}else{$('.autocomplete-suggestions').addClass('hide');}$('.searchchoose').text(typetitle);$('#search form').attr('action',type);});
// Size-Color
$(document).ready(function(){
	function trysplit(){
		try{
			$(".p0").each(function(n,elem){chpr(elem,0)});
		} catch(e) {window.location.replace(window.location);}
	}
	trysplit();
	$(".p0").change(function(){chpr(this,0,1)});
	$(".p1").change(function(){chpr(this,1,1)});
})
function chpr(el,num,select){
elem=$(el).closest('.variants')
if(num==0){
	a=$(elem).find('.p0').val().split(' ');
	$(elem).find('.p1 option').prop('disabled',true);
	for(i=0;i<a.length;i++){$(elem).find('.p1 .'+a[i]).prop('disabled',false)};
	chpr(el,1);
	
	maxamount=parseInt($(elem).find('.pricelist .'+z).attr('data-stock'));$('.productview #amount .amount').attr('data-max',maxamount);
	if($.isNumeric(maxamount)){
		oldamount=parseInt($('.productview #amount .amount').val());
		if(oldamount>maxamount)$('.productview #amount .amount').val(maxamount);
	} else if(select == 1) {
		$('.productview #amount .amount').val(1);
	}
}else{
sel=$(elem).find('.p1 option:selected').prop('disabled')
if(sel){$(elem).find('.p1 .'+a[i]).prop('selected')
a=$(elem).find('.p0').val().split(' ')
for(i=0;i<a.length;i++){if(!$(elem).find('.p1 .'+a[i]).prop('disabled')){$(elem).find('.p1 .'+a[i]).prop('selected',true);break;}}}z='';a0=$(elem).find('.p0').val().split(' ')
a1=$(elem).find('.p1').val().split(' ')
for(i0=0;i0<a0.length;i0++){for(i1=0;i1<a1.length;i1++){if(a0[i0]==a1[i1])z=a0[i0]}}$(elem).find('.vhidden').val(z.substring(1,z.length))
$(elem).find('.price').html($(elem).find('.pricelist .'+z).html());
$(elem).find('.unit').html($(elem).find('.pricelist .'+z).attr('data-unit'));
$(elem).find('.bonusnum').html($(elem).find('.pricelist .'+z).attr('data-bonus'));
$('.sku').html($(elem).find('.pricelist .'+z).attr('data-sku'));
$('.stock').html($(elem).find('.pricelist .'+z).attr('data-stock'));
compare_price=$(elem).find('.pricelist2 .'+z).html();if(compare_price==null) compare_price='';
$(elem).find('.compare_price').html(compare_price);
maxamount=parseInt($(elem).find('.pricelist .'+z).attr('data-stock'));$('.productview #amount .amount').attr('data-max',maxamount);
if($.isNumeric(maxamount)){
	oldamount=parseInt($('.productview #amount .amount').val());
	if(oldamount>maxamount)$('.productview #amount .amount').val(maxamount);
} else if(select == 1) {
	$('.productview #amount .amount').val(1);
}
}
}
// Clicker
function clicker(that){var pick=that.options[that.selectedIndex].value;location.href=pick;};
// Toggle text
$.fn.extend({toggleText:function(a,b){return this.text(this.text()==b?a:b);}});
// Wish Compare
$(document).ready(function(){$(document).on('click','.towish .basewc',function(){var button=$(this);$.ajax({url:"ajax/wishlist.php",data:{id:$(this).attr('data-wish')},success:function(data){$('#wishlist').html(data);button.parent().find('.basewc').hide();button.parent().find('.activewc').show();}});return false;});
$(document).on('click','#wishlist a.delete', function(){$.ajax({url:"ajax/wishlist.php",data:{id:$(this).attr('data-wish'),action:$(this).attr('delete')},});return false;});});$(document).on('click','.compare .basewc',function(){var val=$(this).attr('data-wish');var bl=$(this).closest('.compare');var button2=$(this);$.ajax({url:"ajax/compare.php",data:{compare:val},dataType:'json',success:function(data){if(data){$('#compare_informer').html(data);button2.parent().find('.basewc').hide();button2.parent().find('.activewc').show();}}});return false;
});
// Change on variant select: price, old price, stock, units, sku, bonus points  
$(function(){$(document).on('change','select[name=variant]',function(){price=$(this).find('option:selected').attr('data-varprice');sku='';unit='';bonus='';sku=$(this).find('option:selected').attr('data-sku');unit=$(this).find('option:selected').attr('data-unit');bonus=$(this).find('option:selected').attr('data-bonus');stock=$(this).find('option:selected').attr('data-stock');compare_price='';if(typeof $(this).find('option:selected').attr('data-cprice')=='string')compare_price=$(this).find('option:selected').attr('data-cprice');$(this).closest('form').find('span.price').html(price);$(this).closest('form').find('span.compare_price').html(compare_price);$('.sku').html(sku);$(this).closest('form').find('.sku').html(sku);$(this).closest('form').find('.unit').html(unit);$(this).closest('form').find('.bonusnum').html(bonus);$('.stock').html(stock);return false;});});
document.onkeydown=NavigateThrough;function NavigateThrough(event){if(!document.getElementsByClassName)return;if(window.event)event=window.event;if(event.ctrlKey){var link=null;var href=null;switch(event.keyCode?event.keyCode:event.which?event.which:null){case 0x25:link=document.getElementsByClassName('prev_page_link')[0];break;case 0x27:link=document.getElementsByClassName('next_page_link')[0];break;}if(link&&link.href)document.location=link.href;if(href)document.location=href;}};
// add to cart
$(document).on('submit', 'form.variants', function (e) {
	e.preventDefault();
	button = $(this).find('input[type="submit"]');
	if ($(this).find('input[name=variant]:checked').length > 0) variant = $(this).find('input[name=variant]:checked').val(); else if ($(this).find('input[name=variant]').length > 0) variant = $(this).find('input[name=variant]').val();
	if ($(this).find('select[name=variant]').length > 0) variant = $(this).find('select').val();
	amount = Number($(this).find('input[name="amount"]').val());
	if (amount == 0) amount = 1;
	$.ajax({
		url: "ajax/cart.php",
		data: {variant: variant, 'mode': 'add', amount: amount},
		dataType: 'json',
		success: function (data) {
			$('#cart_informer').html(data);
			if (button.attr('data-result-text')) button.val(button.attr('data-result-text'));
			if (popup_cart) {
				$.fancybox.open({
					src: '#data',
					type: 'inline',
					opts: {
						showCloseButton: false,
						scrolling: 'no'
					}
				});
			}
		}
	});
	return false;
});
// cart options
$(document).on('submit', 'form.cart_mini', function (e) {
	e.preventDefault();
	button = $(this).find('input[type="submit"]');
	$.ajax({
		url: "ajax/cart.php",
		data: {variant: $(this).find('input[name="variant_id"]').val(), 'mode': 'remove'},
		dataType: 'json',
		success: function (data) {
			$('#cart_informer').html(data);
			$('#cart').html(data);
			$.fancybox.getInstance().close();
			$.fancybox.open({
				src: '#data',
				type: 'inline',
				opts: {
					showCloseButton: false,
					scrolling: 'no'
				}
			});
		}
	});
	return false;
});
$(document).on('submit', 'form.cartt', function (e) {
	e.preventDefault();
	const data = {
		variant: $(this).find('input[name="variant_id"]').val(),
		new_variant: $(this).find('select[name="new_variant"]').val(),
		amount: $(this).find('select[name="amount"]').val()
	};
	if (parseInt(data.variant) === parseInt(data.new_variant)) {
		data.new_variant = 0;
	} else {
		data.amount = $(this).find('select[name="amount"] option:selected').text();
	}
	$.ajax({
		url: "ajax/cart.php",
		data: data,
		dataType: 'json',
		cache: false,
		success: function (data) {
			$('#cart_informer').html(data);
			$.fancybox.getInstance().close();
			$.fancybox.open({
				closeExisting: true,
				src: '#data',
				type: 'inline',
				opts: {
					showCloseButton: false,
					scrolling: 'no'
				}
			});
		}
	});
	return false;
});
// Scroll top
$(function(){
  $.fn.scrollToTop=function(){
    $(this).hide();
    if($(window).scrollTop()!="0"){
        $(this).fadeIn("slow")
  }
  var scrollDiv=$(this);
  $(window).scroll(function(){
    if($(window).scrollTop()=="0"){
    $(scrollDiv).fadeOut("slow")
    }else{
    $(scrollDiv).fadeIn("slow")
  }
  });
    $(this).click(function(){
      $("html, body").animate({scrollTop:0},"slow")
    })
  }
});
$(function() {$("#topcontrol").scrollToTop();});
// Backcall
$(function(){
	$(".topcallbutton").click(function(){
		$("#btf_form .hideablebutton").addClass('btf_submit');
		$.fancybox.open({src:'#btf_form', type:'inline'});
	});
	function errorBtfForm(text){ 
		$("#btf_result").html('<div class="btf_error">'+text+'</div>');
		setTimeout( function(){$(".btf_error").slideUp("slow");}, 4000);
		return false;
	}
	$(document).on('click','.btf_submit', function(){
		if($('#btf_form .check_inp[name="btfalse"]').is(':checked')) {
			errorBtfForm('Не пройдена проверка на бота!');
			return false;
		}
		if($('#btf_form .check_inp[name="bttrue"]').is(':checked')) { 
			$.ajax({ 
				type:"POST",
				url:"ajax/backcall.php",
				data:{
					btf_name:$("#btf_name").val(),
					btf_phone:$("#btf_phone").val(),
					btf_email:$("#btf_email").val(),
					btf_theme:$("#btf_theme").val(),
					btf_check:$("#btf_form .check_inp[name='bttrue']").val()
				},
				success:function(result){
					if(result=='wrong_name') {
						errorBtfForm('В имени можно использовать только кириллицу!');
					} else if(result=='wrong_email') {
						errorBtfForm('Некорректный Email!');
					} else if(result=='wrong_phone') {
						errorBtfForm('Некорректный телефон!');		
					} else if(result=='captcha') {
						errorBtfForm('Не пройдена проверка на бота!');		
					} else if(result=='btf_error'){
						errorBtfForm('Ошибка: заполните все поля со *');
					} else if(result=='already_sent'){
						errorBtfForm('Ваш заказ обратного звонка уже был отправлен ранее');	
					} else if(result=='btf_success'){
						$("#btf_result").html('<div class="btf_success">Сообщение успешно отправлено.</div>');$(".btf_form").hide();setTimeout(function(){$.fancybox.close();},1000);
						return false;
					} else {
						errorBtfForm('Ошибка отправки, попробуйте повторить через 5 минут');
					}
				}
			});
			//
		} else {
			errorBtfForm('Не пройдена проверка на бота!');
			$('#btf_form .check_bt').addClass('look_here');
			return false;
		}
	});
});
// Поддержка $.browser
(function($) {
    var userAgent = navigator.userAgent.toLowerCase();
    $.browser = { version: (userAgent.match( /.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [0,'0'])[1], safari: /webkit/.test( userAgent ), opera: /opera/.test( userAgent ), msie: /msie/.test( userAgent ) && !/opera/.test( userAgent ), mozilla: /firefox/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ) };
})(jQuery);
// Скрываем селекты в карусели для Firefox 
if($.browser.mozilla)
	$('.tiny_products.owl-carousel').addClass('expanded');
// Features m
var ajax_process_m=false;$(function(){$(document).on("click",'#features input[type="checkbox"]',function(event){ajax_filter_m(event.target);});$(document).on("change",'#features input[type="text"]',function(){ajax_filter_m();});});function ajax_filter_m(event){if(!ajax_process_m){ajax_process_m=true;$('#features').css('opacity','0.5');filter_form=$('#features form');price_min=filter_form.find('#minCurrm');price_max=filter_form.find('#maxCurrm');url=current_url+'?aj_mf=true';params='&';inputs=filter_form.find('input[type="checkbox"]:checked');inputs.each(function(){params+=$(this).attr('name')+"="+encodeURIComponent($(this).val())+"&";});diaps=filter_form.find('input.diaps');diaps.each(function(){params+=$(this).attr('name')+"="+encodeURIComponent($(this).val())+"&";});if(!$(price_min).is(":disabled"))params+='minCurr='+encodeURIComponent(price_min.val())+"&";if(!$(price_max).is(":disabled"))params+='maxCurr='+encodeURIComponent(price_max.val())+"&";url+=params;$.ajaxPrefilter(function(options,originalOptions,jqXHR){options.async=true;});$.ajax({url:url,dataType:'json',success:function(data){if(data.filter_block){$('#features').html(data.filter_block);ajax_process_m=false;$('#features').css('opacity','1');var active_feature=$(event).closest('.feature_values').attr('data-f');$('.feature_values[data-f='+active_feature+']').after($('.prods_num_flag'));}},error:function(jqXHR,exception){ajax_process_m=false;$('#features').css('opacity','1');}});}}
// Features c
var ajax_process=false;$(function(){$(document).on("click",'#cfeatures input[type="checkbox"]',function(){ajax_filter();});$(document).on("change",'#cfeatures input[type="text"]',function(){ajax_filter();});});function ajax_filter(){if(!ajax_process){ajax_process=true;$('#cfeatures').css('opacity','0.5');filter_form=$('#cfeatures form');price_min=filter_form.find('#minCurr');price_max=filter_form.find('#maxCurr');url=current_url+'?aj_f=true';params='&';inputs=filter_form.find('input[type="checkbox"]:checked');inputs.each(function(){params+=$(this).attr('name')+"="+encodeURIComponent($(this).val())+"&";});diaps=filter_form.find('input.diaps');diaps.each(function(){params+=$(this).attr('name')+"="+encodeURIComponent($(this).val())+"&";});if(!$(price_min).is(":disabled"))params+='minCurr='+encodeURIComponent(price_min.val())+"&";if(!$(price_max).is(":disabled"))params+='maxCurr='+encodeURIComponent(price_max.val())+"&";url+=params;$.ajaxPrefilter(function(options,originalOptions,jqXHR){options.async=true;});$.ajax({url:url,dataType:'json',success:function(data){if(data.filter_block){$('#cfeatures').html(data.filter_block);ajax_process=false;$('#cfeatures').css('opacity','1');}},error:function(jqXHR,exception){ajax_process=false;$('#cfeatures').css('opacity','1');}});}}
// Обновления при смене кол-ва товара в cart.tpl
$(document).on('change','#purchases1 .amount input', function() {
	document.cart.submit();
});
// Search
$(window).load(function(){ type = $('#search form').attr('action');initSearch() });
function initSearch(){if (type=="products"){$(".newsearch").autocomplete({serviceUrl:'ajax/search_products.php',minChars:1,noCache:false,onSelect:function(suggestion){$(".newsearch").closest('form').submit();},formatResult:function(suggestion,currentValue){var reEscape=new RegExp('(\\'+['/','.','*','+','?','|','(',')','[',']','{','}','\\'].join('|\\')+')','g');var pattern='('+currentValue.replace(reEscape,'\\$1')+')';return(suggestion.data.image?"<span class='sugimage'><img align=absmiddle src='"+suggestion.data.image+"'></span> ":'')+suggestion.value.replace(new RegExp(pattern,'gi'),'<strong>$1<\/strong>');}});}
}
/*function initSearch(){if (type=="products"){$(".newsearch").autocomplete({serviceUrl:'ajax/search_products.php',minChars:1,noCache:false,formatResult:function(suggestion,currentValue){var reEscape=new RegExp('(\\'+['/','.','*','+','?','|','(',')','[',']','{','}','\\'].join('|\\')+')','g');var pattern='('+currentValue.replace(reEscape,'\\$1')+')';return(suggestion.data.image?"<span class='sugimage'><img align=absmiddle src='"+suggestion.data.image+"'></span> ":'')+suggestion.value.replace(new RegExp(pattern,'gi'),'<strong>$1<\/strong>');}});};$(document).on('click','.autocomplete-suggestion',function(){$(".newsearch").closest('form').submit();});
}*/
// Features diapazone
function clickerdiapmin(that){var pick=that.options[that.selectedIndex].text;if(pick){$(that).closest(".feature_values").find(".diapmin").val(pick).prop('disabled',false);}else{$(that).closest(".feature_values").find(".diapmin").val(pick).prop('disabled',true);}ajax_filter();};
function clickerdiapmax(that){var pick=that.options[that.selectedIndex].text;if(pick){$(that).closest(".feature_values").find(".diapmax").val(pick).prop('disabled',false);}else{$(that).closest(".feature_values").find(".diapmax").val(pick).prop('disabled',true);}ajax_filter();};
$(document).on('click','.hide_feat',function(){$(this).toggleClass('show').siblings('.feature_values').fadeToggle('normal');return false;});
// Cookie handler
function createCookie(name,value,days){if(days){var date=new Date();date.setTime(date.getTime()+(days*24*60*60*1000));var expires="; expires="+date.toGMTString();}else var expires="";document.cookie=name+"="+value+expires+"; path=/";}
function readCookie(name){var nameEQ=name+"=";var ca=document.cookie.split(';');for(var i=0;i<ca.length;i++){var c=ca[i];while(c.charAt(0)==' ')c=c.substring(1,c.length);if(c.indexOf(nameEQ)==0)return c.substring(nameEQ.length,c.length);}return null;}
// User forms handler
$(window).load(function(){
	$('.showform').click(function(){ 
		var buttonId = $(this).attr('data-id');
		$('#'+buttonId+' .hideablebutton').addClass('form_submit');
		$.fancybox({ 'href':'#'+buttonId,scrolling:'no' });
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
		  	if(this.name == 'f-name'|| this.name == 'f-email')
				$data[this.name] = $(this).val();
		  	else
		  		$data[this.name] = $(this).attr('placeholder')+' : '+$(this).val();
		});
		$data['f-url'] = 'Со страницы : '+document.location.href;
		if(form_approve)
			sendUserForm(formId,$data);
	});
	$(document).on('focus', '.readform input, .readform textarea', function () {
		$(this).removeClass('required');
	});
	function errorUserForm(formId,text){ 
		$('#'+formId+' .form_result').html('<div class="form_error">'+text+'</div>');
		setTimeout(function(){ $('#'+formId+' .form_error').slideUp("slow"); },4000);
	}
	function sendUserForm(formId,$data){ 
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
					} else if(result=='wrong_name') {
						errorUserForm(formId,'В имени можно использовать только кириллицу!');
					} else if(result=='wrong_email') {
						errorUserForm(formId,'Некорректный Email!');
					} else if(result=='captcha') {
						errorUserForm(formId,'Не пройдена проверка на бота!');
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
// IE version
function ieVersion(){var rv=10;if(navigator.appName == 'Microsoft Internet Explorer'){var ua = navigator.userAgent;var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");if(re.exec(ua) != null) rv = parseFloat( RegExp.$1 );}return rv;}
// Placeholder IE < 10
if (ieVersion()<10) {(function(j,p){j(function(){j("["+p+"]").focus(function(){var i=j(this);if(i.val()===i.attr(p)){i.val("").removeClass(p)}}).blur(function(){var i=j(this);if(i.val()===""||i.val()===i.attr(p)){i.addClass(p).val(i.attr(p))}}).blur().parents("form").submit(function(){j(this).find(p).each(function(){var i=j(this);if(i.val()===i.attr(p)){i.val("")}})})})})(jQuery,"placeholder");}
// Check antibot & confpolicy before submit
$('.main_cart_form, .register_form, .feedback_form, .comment_form, .user_form, #subscribe').submit(function(){ 
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
$(document).on('click', '.check_bt', function () {
	$(this).removeClass('look_here');
});
// error text handler
$(window).load(function(){if($('.message_error').length){var offset_top='.message_error';$('html, body').animate({ scrollTop:$(offset_top).offset().top - 60},500);}});
// Check error in cart
$('.main_cart_form').submit(function(){ 
	if($('.message_error').length){ 
		$(this).find('.message_error').addClass('look_here');
		var offset_top='.message_error';
		$('html, body').animate({ scrollTop:$(offset_top).offset().top - 60},500);
	} else {
	    $(this).find('.message_error').removeClass('look_here');
	}	
});
// Scroll anchor function
$('.anchor').click(function(){ 
	var offset_top=$(this).attr('data-anchor');
	$('html, body').animate({ scrollTop:$(offset_top).offset().top - 60},500);
});
// .izoom open in modal
$(window).load(function(){
	$('.izoom').click(function(){ 
		var modal_url = $(this).attr('src');
		$.fancybox({ 'href': modal_url, 'hideOnContentClick' : true });
	});
});
// .url redirect
$('.url').click(function(){ 
	var url = $(this).attr('data-url');
	window.open(url,'_blank');
});
