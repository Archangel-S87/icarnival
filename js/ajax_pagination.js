			var loadAjax = false;
			var offset_scroll;
			var update_products;
			if (offset_scroll == null) offset_scroll = -10;
			
			// history back and forward
			window.addEventListener('popstate', function(e){ 
				if(e.state !== null){
					$('html, body').animate({ scrollTop: $('.pagination').offset().top + offset_scroll}, 500);
					get_pagination(e.state.url);
				}
			}, false);
			
			// pagination button click
			$(document).on('click', '.pagination a', function () { 
				if (!loadAjax) {
					var url = $(this).attr("href");
					if(url != null) {
						loadAjax = true;
						var state = {
							title: "pagination",
							url: url
						}
						if(window.history && history.pushState)
							history.pushState( state, state.title, state.url );
						get_pagination(url);
					} else {
						loadAjax = false;
					}
					return false;
				}
			});
			
			// accept direct url
			function direct_pagination(href){ 
				if (!loadAjax) {
					url = href;
					if(url != null) {
						loadAjax = true;
						var state = {
							title: "pagination",
							url: url
						}
						if(window.history && history.pushState)
							history.pushState( state, state.title, state.url );
						get_pagination(url);
					} else {
						loadAjax = false;
					}
					return false;
				}
			}
			
			function get_pagination(href){ 
				$('.mainloader').show();
				$.ajaxPrefilter(function( options, originalOptions, jqXHR ) { options.async = true; });
				$.get(href, function(data){ 
					if(data){ 
						$('.content_wrapper').html(data);
						$('title').text( $('.refresh_title').val() );
						$('html, body').animate({ scrollTop: $('.pagination').offset().top + offset_scroll}, 500);
						$('.mainloader').hide();
						if(update_products == 1) $.getScript('/androidcore/infinite_update_products.js');
					} else {
						window.location.reload();
					}
					loadAjax = false;
				}).fail(function() {
					$('.mainloader').hide();
					loadAjax = false;
				});
			}
			