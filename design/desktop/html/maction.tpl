<!-- incl. maction -->
<!--noindex-->
<div class="block" style="display: none;">
	<div class="box-heading">Внимание акция</div>
	<div class="box-content">
				<div class="text">{$settings->action_description}</div>
				<div class="timer">
					<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="24px"
						 height="24px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve">
					<g id="Bounding_Boxesa">
						<g id="ui_x5F_spec_x5F_header_copy_2a">
						</g>
						<path fill="none" d="M0,0h24v24H0V0z"/>
					</g>
					<g id="Duotone_a">
						<g id="ui_x5F_spec_x5F_header_copy_3a">
						</g>
						<g>
							<path fill="#cfef6b" opacity="0.8" d="M12.07,6.01c-3.87,0-7,3.13-7,7s3.13,7,7,7s7-3.13,7-7S15.94,6.01,12.07,6.01z M13.07,14.01h-2v-6h2V14.01z
								"/>
							<rect x="9.07" y="1.01" width="6" height="2"/>
							<rect x="11.07" y="8.01" width="2" height="6"/>
							<path d="M19.1,7.39l1.42-1.42c-0.43-0.51-0.9-0.99-1.41-1.41l-1.42,1.42c-1.55-1.24-3.5-1.98-5.62-1.98c-4.97,0-9,4.03-9,9
								c0,4.97,4.02,9,9,9s9-4.03,9-9C21.07,10.89,20.33,8.93,19.1,7.39z M12.07,20.01c-3.87,0-7-3.13-7-7s3.13-7,7-7s7,3.13,7,7
								S15.94,20.01,12.07,20.01z"/>
						</g>
					</g>
					</svg>
					<p>До конца акции</p>
					<div class="digits" data-date="{$settings->action_end_date}" data-time="{$settings->action_end_date_hours}:{$settings->action_end_date_minutes}"></div>
				</div>
	</div>
</div>
<script>
{literal}
$(document).ready(function(){ var response=$('.timer>.digits')[0];var date=response.getAttribute('data-date').split('.');var time=response.getAttribute('data-time').split(':');date=new Date(date[2],parseInt(date[1],10)-1,date[0],time[0],time[1],0,0);document.endActionDate=date;var block=$(".block")[0];var now=(new Date()).getTime();var endTS=document.endActionDate.getTime();if((endTS-now)>1){block.style.display='block';}setInterval(function(){ var now=new Date();var endTS=document.endActionDate.getTime();var totalRemains=(endTS-now.getTime());if(totalRemains>1){ var RemainsSec=(parseInt(totalRemains/1000));var RemainsFullDays=(parseInt(RemainsSec/(24*60*60)));var secInLastDay=RemainsSec-RemainsFullDays*24*3600;var RemainsFullHours=(parseInt(secInLastDay/3600));if(RemainsFullHours<10){ RemainsFullHours="0"+RemainsFullHours};var secInLastHour=secInLastDay-RemainsFullHours*3600;var RemainsMinutes=(parseInt(secInLastHour/60));if(RemainsMinutes<10){ RemainsMinutes="0"+RemainsMinutes};var lastSec=secInLastHour-RemainsMinutes*60;if(lastSec<10){lastSec="0"+lastSec};$('.timer>.digits').html((RemainsFullDays?"<span>"+RemainsFullDays+" дн.</span> ":"")+RemainsFullHours+":"+RemainsMinutes+":"+lastSec);}else{$(".block").remove();}},1000);});
{/literal}
</script>
<!--/noindex-->
<!-- incl. maction @ -->
