<!--noindex-->
<div id="installapp">
	<div class="mapp_icon "></div>
	<div class="mtext">Нашим интернет-магазином намного удобнее пользоваться с помощью бесплатного приложения!</div>
	<div class="iosshow" style="display:none;">
		<div class="mlogo ios_logo"></div>
		<a class="mbutton mios_button" href="">Установить</a>
	</div>
	<div class="androidshow" style="display:none;">
		<div class="mlogo android_logo"></div>
		<a class="mbutton mios_button" href="">Установить</a>
	</div>
	<div class="micon_close"></div>
</div>
<!--/noindex-->

<script>
	var isMobile = {
		Google: function() { 
	        return navigator.userAgent.match(/(Google|Googlebot|Yandex|bot)/i);
	    },
	    Android: function() { 
	        return navigator.userAgent.match(/Android/i);
	    },
	    iOS: function() { 
	        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
	    }
	};
	
	if(!isMobile.Google()){
		if(isMobile.Android()){
			$('#installapp').show();
			$('.androidshow').show();
		} else if(isMobile.iOS()){
			$('#installapp').show();
			$('.iosshow').show();
		}
	}

	$('.micon_close').click(function() { 
		createCookie('appadv', '1', '365'); 
		$('#installapp').hide();
	});
</script>

<style type="text/css">#installapp {  display:table; position: fixed;  -moz-user-select: none;  -webkit-user-select: none;  -ms-user-select: none;  user-select: none;  left: 0;  top: 0;  right: 0;  box-sizing: border-box;  min-height: 120px;  width: 100%;  border-bottom: solid 1px #c4c4c4;  background-color: #fff;  font-family: tahoma, arial, verdana, sans-serif, Lucida Sans;  color: #000;  box-shadow: 0px 3px 5px 0px rgba(0, 0, 0, 0.38);  z-index: 99990;}#installapp .mtext {  -moz-user-select: none;  -webkit-user-select: none;  -ms-user-select: none;  user-select: none;  box-sizing: border-box;  position: absolute;  width: 65%;  margin: 4%;  left: 20%;  font-size: 14px; line-height: 14px; color: #888;  z-index: 99995;  text-align: left;}#installapp .mbutton {  text-decoration: none;  -moz-user-select: none;  -webkit-user-select: none;  -ms-user-select: none;  user-select: none;  box-sizing: border-box;  width: 30%;  margin: 2%;  padding: 2%;  right: 0;  bottom: 0;  font-size: 16px;  line-height: 16px; text-align: center;  display: inline-block;  z-index: 99995;  position: absolute;}#installapp .mandroid_button {  color: #fff;  background-color: #8BC34A;  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 1px 5px 0 rgba(0, 0, 0, 0.12), 0 3px 1px -2px rgba(0, 0, 0, 0.2);}#installapp .mios_button {  background-color: transparent;  color: #1498d9;}#installapp .micon_close {  user-select: none;  width: 2%;  box-sizing: border-box;  height: 2%;  position: absolute;  padding: 2%;  margin: 2%;  opacity: .5;  right: 0;  top: 0;  background-repeat: no-repeat;  background-position: center;  background-size: 100%;  background-image: url(androidcore/images/close.png);  z-index: 99995;  display: inline-block;}#installapp .mapp_icon {  -moz-user-select: none;  -webkit-user-select: none;  -ms-user-select: none;  user-select: none;  width: 17%;  height: 65%;  position: absolute;  border-radius: 10%;  margin: 3%;  left: 0;  top: 0;  background-repeat: no-repeat;  background-position: center;  background-color: #fff;  background-size: 100%;  background-image: url(androidcore/images/appicon_152.png);  z-index: 99995;  display: inline-block;}#installapp .mlogo {  -moz-user-select: none;  -webkit-user-select: none;  -ms-user-select: none;  user-select: none;  width: 22%;  height: 35%;  box-sizing: border-box;  position: absolute;  padding: 2%;  margin: 1%;  left: 23%;  bottom: 0;  background-repeat: no-repeat;  background-position: center;  background-size: 100%;  z-index: 99995;  display: inline-block;}
	#installapp .android_logo {  background-image: url(androidcore/images/android.png);}
	#installapp .ios_logo {  background-image: url(androidcore/images/ios.png);}
</style>