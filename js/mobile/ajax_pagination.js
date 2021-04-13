			var loadAjax = false;
			var offset_scroll;
			if (offset_scroll == null) offset_scroll = -10;
			
			// history back and forward
			window.addEventListener('popstate', function(e){ 
				if(e.state !== null)
					$('html, body').animate({ scrollTop: $('.ajax_pagination').offset().top + offset_scroll}, 500);
					get_pagination(e.state.url);
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
				$.get(href, function(data){ 
					if(data){ 
						$('.content_wrapper').html(data);
						$('.pagination').show();
						$('title').text( $('.refresh_title').val() );
						
						$('html, body').animate({ scrollTop: $('.ajax_pagination').offset().top + offset_scroll}, 500);
						
						refresh_current_num = $(data).filter('.refresh_curr_page').val();
						if(refresh_current_num != null) $('.refresh_curr_page').val(refresh_current_num);
						
						$('.mainloader').hide();
					} else {
						window.location.reload();
					}
					loadAjax = false;
				});
			}
			