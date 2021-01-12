			var loadAjax = false;
			var last_num;
			var next_num;
			var start_num;
			var prev_num;
			var offset;
			var scroll_timeout;
			var update_products;
			if (start_num == null) start_num = $(".curr_page").val();
      		if (last_num == null) last_num = $(".curr_page").val();
      		if (next_num == null) next_num= $(".curr_page").val();
      		if (prev_num == null) prev_num= $(".curr_page").val();
      		if (offset == null) offset = 800;
      		if (update_products == null) update_products = 0;
			if (scroll_timeout == null) scroll_timeout = 500;
      		var total_num = $('.total_pages').val();
			var url;
      		$.ajaxPrefilter(function( options, originalOptions, jqXHR ) { options.async = true; });
      		
      		// next page getting while scrolling
      		//$(window).scroll(throttle(function() {
      		$(window).scroll(debounce(function() {
      		
				// trigger from bottom of website - offset
      			//if (($(window).scrollTop() + $(window).height() > $(document).height() - offset) && !loadAjax) {
      			
      			// trigger from element .infinite_trigger - offset
      			if ( !loadAjax && ($(window).scrollTop() + $(window).height()) > ($('.infinite_trigger').offset().top - offset) && $('.ajax_pagination').is(":visible") ) {
      				
      				url = $(".refresh_next_page").attr("data-url");
      				
      				next_num = $(".refresh_next_page").val();
      				if (start_num == null) start_num = $(".curr_page").val();
      				if (last_num == null) last_num = $(".curr_page").val();
      				
					//console.log('loadAjax = ' + loadAjax + ' / prev_num = ' + prev_num + ' / last_num = ' + last_num + ' / start_num = ' + start_num + ' / next_num = ' + next_num + ' / total_num = ' + total_num);

      				if(url != null) {
      					
      					loadAjax = true;
      					$('.infinite_pages').show();
						var state = {
							title: "pagination",
							url: url
						}
						
						if(parseInt(next_num) > parseInt(last_num)) {
							history.replaceState( state, state.title, state.url );
							infinite_load(url);
							return false;
						} else {
							loadAjax = false;
						}

					} else {
						$('.infinite_pages').show();
      				}
      			}
      		}, scroll_timeout));

      		// if something got wrong
      		/*$(document).on('click', '.mainloader', function () { 
      			url = $(".refresh_next_page").attr("data-url");
      			if(url != null) {
      				window.location = url;
				} else {
					window.location.reload();
      			}
      			return false;
			});*/
      		
      		// prev button click
			$(document).on('click', '.trigger_prev', function () { 
				if (!loadAjax) {
					url = $(".refresh_prev_page").attr("data-url");
				
					prev_num = $(".refresh_prev_page").val();
					if (start_num == null) start_num= $(".curr_page").val();
					if (next_num == null) next_num= $(".curr_page").val();
				
						if(url != null) {
							loadAjax = true;
							$('.infinite_pages').show();
							var state = {
								title: "pagination",
								url: url
							}

							history.replaceState( state, state.title, state.url );
						
							if(parseInt(prev_num) < parseInt(start_num) ) {
								$('.infinite_prev').show();
								infinite_load_prev(url);
							} else {
								$('.infinite_prev').hide();
								loadAjax = false;
							}
						
							if(parseInt(prev_num) > 1 ) {
								$('.infinite_prev').show();
							} else {
								$('.infinite_prev').hide();
							}
						
						} else {
							$('.infinite_pages').show();
						}
				
					return false;
				}
			});
			
			// next page append
			function infinite_load(href){ 
				$('.mainloader').show();
				$.get(href, function(data){ 
					if(data){ 
						appnd = $(data).find('.infinite_load').html();
						refresh_next_page = $(data).filter('.refresh_next_page').attr("data-url");
						refresh_next_num = $(data).filter('.refresh_next_page').val();
						refresh_current_num = $(data).filter('.refresh_curr_page').val();
						last_num = next_num;
						refresh_title = $(data).filter('.refresh_title').val();
						if(refresh_next_page != null) $('.refresh_next_page').attr("data-url",refresh_next_page);
						if(refresh_next_num != null) $('.refresh_next_page').val(refresh_next_num);
						if(refresh_current_num != null) $('.refresh_curr_page').val(refresh_current_num);
						$('.infinite_pages').html('<div>Стр. ' + start_num + ' - ' + next_num + ' из ' + total_num + '</div>');
						$('title').text(refresh_title);
						$('.infinite_load').append(appnd);
						$('.mainloader').hide();
						if(update_products == 1) update_prods();
						loadAjax = false;
					} else {
						window.location.reload();
						loadAjax = false;
					}
					//loadAjax = false;
				}).fail(function() {
					$('.mainloader').hide();
					loadAjax = false;
				});
			}
			
			// prev page append
			function infinite_load_prev(href){ 
				$('.mainloader').show();
				$.get(href, function(data){ 
					if(data){ 
						appnd = $(data).find('.infinite_load').html();
						refresh_prev_page = $(data).filter('.refresh_prev_page').attr("data-url");
						refresh_prev_num = $(data).filter('.refresh_prev_page').val();
						refresh_current_num = $(data).filter('.refresh_curr_page').val();
						start_num = prev_num;
						refresh_title = $(data).filter('.refresh_title').val();
						if(refresh_prev_page != null) $('.refresh_prev_page').attr("data-url",refresh_prev_page);
						if(refresh_prev_num != null) $('.refresh_prev_page').val(refresh_prev_num);
						if(refresh_current_num != null) $('.refresh_curr_page').val(refresh_current_num);
						$('.infinite_pages').html('<div>Стр. ' + start_num + ' - ' + next_num + ' из ' + total_num + '</div>');
						$('title').text(refresh_title);
						$('.infinite_load').prepend(appnd);
						$('.mainloader').hide();
						if(update_products == 1) update_prods();
					}
					else {
						window.location.reload();
					}
					loadAjax = false;
				}).fail(function() {
					$('.mainloader').hide();
					loadAjax = false;
				});
			}
			
			function update_prods(){
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
			}

			function throttle(callback, delay) {
				var timeoutHandler = null;
				return function () {
					if (timeoutHandler == null) {
						timeoutHandler = setTimeout(function () {
							callback();
							clearInterval(timeoutHandler);
							timeoutHandler = null;
						}, delay);
					}
				}
			}

			function debounce(callback, delay) {
				var timeoutHandler = null;
				return function () {
					clearTimeout(timeoutHandler);
					timeoutHandler = setTimeout(function () {
						callback();
					}, delay);
				}
			}
			