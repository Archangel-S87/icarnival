<!-- incl. cookie -->
<!--noindex-->
	<div class="cookwarning">
		<div class="cookwrapper">
			<div class="cooktext">
				<p>{$settings->cookwarn}</p>
			</div>
			<div class="cookokwrap">
				<div class="cookok">ОК</div>
			</div>
		</div>
	</div>
	<script>
		$(document).ready(function() { 
			$('.cookok').click(function() { 
				createCookie('cookwarn', '1', '365'); 
				$('.cookwarning').hide();
			});
		});
	</script>
<!--/noindex-->	
<!-- incl. cookie @ -->