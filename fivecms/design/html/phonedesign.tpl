
<link rel="stylesheet" type="text/css" href="./design/css/style000.css" />
<style>
#menutop{ background-color: #{$mobtheme->colorPrimary}; }
#catalogtopbody svg{ fill: #{$mobtheme->colorSecondPrimary}; }
#catalogtopbody a{ color:#{$mobtheme->leftMenuItem}; }
#catalogtopbody .activeli a, #catalogtopbody li:hover a{ color:#{$mobtheme->leftMenuItemActive}; }
#catalogtopbody .activeli svg, #catalogtopbody li:hover svg { fill:#{$mobtheme->leftMenuIconActive}; }
#catalogtopbody .activeli, #catalogtopbody li:hover { background-color:#{$mobtheme->backgroundAccent}; }
#catalog svg, #cart_informer svg, #searchblock svg{ fill:#{$mobtheme->colorMain}; }
#menutoptitle{ color:#{$mobtheme->colorMain}; }
.badge{ background-color:#{$mobtheme->badgeBackground};border-color:#{$mobtheme->badgeBorder};color:#{$mobtheme->badgeText};}
.maincatalog { background-color:#{$mobtheme->sliderbg|escape};color:#{$mobtheme->slidertext|escape}; }
.pagination .selected, .pagination .butpag.selected, .htabs a, ul.tabs li, .buttonred, #content .logreg { background-color:#{$mobtheme->buybg|escape};color:#{$mobtheme->buytext|escape}; }
.buttonred.hover, #content .logreg:hover { background-color:#{$mobtheme->buybgactive|escape};color:#{$mobtheme->buytextactive|escape}; }
.addcompare svg, .towish svg, .purchase-remove svg, .wish-remove svg, #comparebody .delete svg { fill: #{$mobtheme->wishcomp|escape}; }
.gocompare svg, .inwish svg, .purchase-remove svg:active, .wish-remove svg:active, #comparebody .delete svg:active { fill: #{$mobtheme->wishcompactive|escape}; }
.breadcrumb { background-color:#{$mobtheme->breadbg|escape};color:#{$mobtheme->breadtext|escape}; }
.upl-trigger-prev, a.titlecomp, .product h3, #content a, .cutmore, .purchasestitle a, .pagination .butpag { color: #{$mobtheme->zagolovok|escape}; }
.tiny_products .product, .category_products .product { background-color:#{$mobtheme->zagolovokbg|escape};border: 1px solid #{$mobtheme->productborder|escape}; }
.bonus { background-color:#{$mobtheme->ballovbg|escape}; }
.various, .comment_form .button, #logininput, .register_form .button, .login_form .button, .feedback_form .button, .cart_form .button, #orderform .button, .checkout_button { background-color:#{$mobtheme->oneclickbg|escape};color:#{$mobtheme->oneclicktext|escape}; }

#logo { background-color: #{$mobtheme->colorPrimary}; }
#menutoptitle .searchtext { color:#{$mobtheme->textAccent}; }
#searchblock .hidecross { fill:#{$mobtheme->textAccent}; }
.about_window #container{ background-color:#{$mobtheme->aboutBackgroundText}; }
.about_window .abouttext{ background-color: #{$mobtheme->colorPrimary}; color:#{$mobtheme->colorMain}; }
.about_window .aboutText3{ color:#{$mobtheme->aboutText3}; }
.colorPrimaryDark{ background-color: #{$mobtheme->colorPrimaryDark}; }
.logoText{ color:#{$mobtheme->logoText}; }
.logoPhone{ color:#{$mobtheme->logoPhone}; }
</style>

<div id="body" class="nonwhitebg" style="">	
	
	<div class="colorPrimaryDark">
	</div>
	<div id="menutop">
		<div id="menutopbody">
			<div id="catalog" onclick="hideShowMenu(this);return false;" class="">
				<svg style="margin-top:1px;" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M0 0h24v24H0z" fill="none"/>
				    <path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/>
				</svg>
			</div>
			<div id="menutoptitle">
				<span class="hidetitle">Демо-магазин </span>
					<div id="searchtop" class="searchtext" style="display:none; font-weight:400;padding-left:10px;">Поиск...
					</div>
			</div>
			<div id="cart_informer">
				<svg height="24" viewBox="0 0 24 20" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M0 0h24v24H0zm18.31 6l-2.76 5z" fill="none"></path>
				    <path d="M11 9h2V6h3V4h-3V1h-2v3H8v2h3v3zm-4 9c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zm10 0c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2zm-9.83-3.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.86-7.01L19.42 4h-.01l-1.1 2-2.76 5H8.53l-.13-.27L6.16 6l-.95-2-.94-2H1v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.13 0-.25-.11-.25-.25z"></path>
				</svg>
				<div class="badge">1</div></div>
			<div id="searchblock" onclick="hideShowSearch(this);return false;">
				<svg height="24" class="hideloupe" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
				    <path d="M0 0h24v24H0z" fill="none"/>
				</svg>
				<svg style="display:none" class="hidecross" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
				    <path d="M0 0h24v24H0z" fill="none"/>
				</svg>
			</div>
		</div>
	</div>
	

	
	<div id="catalogtop" class="">
		<div id="logo">
			<div class="logoimage">
				<div class="logoimagewrap">
					<img src="./design/images/logo0000.png" alt="Демо-магазин ">
				</div>
			</div>
			<div class="logoinfo">
				<p class="logoText">Демо-магазин </p>
				<p class="logoPhone">+7 (123) 456-7089</p>
			</div>
		</div>
		<div id="catalogtopbody">
								
					<ul class="dropdown-menu catsjs">
						<li onClick="$('.first_window').show();$('.about_window').hide();hideShowOverlay(this);$('.dropdown-menu li').removeClass('activeli');$(this).addClass('activeli');return false;">
							<svg fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
							    <path d="M0 0h24v24H0z" fill="none"/>
							</svg>
							<a name="" title="Главная">Главная</a>
						</li>
						<li class="activeli" onClick="$('.first_window').show();$('.about_window').hide();hideShowOverlay(this);$('.dropdown-menu li').removeClass('activeli');$(this).addClass('activeli');return false;">							
							<svg fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M0 0h24v24H0z" fill="none"/>
							    <path d="M20 13H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1v-6c0-.55-.45-1-1-1zM7 19c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM20 3H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1V4c0-.55-.45-1-1-1zM7 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
							</svg>
							<a name="" title="Каталог">Каталог</a>
						</li>
						<li onClick="$('.first_window').show();$('.about_window').hide();hideShowOverlay(this);$('.dropdown-menu li').removeClass('activeli');$(this).addClass('activeli');return false;">
							<svg fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M0 0h24v24H0z" fill="none"/>
							    <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm-2 14l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
							</svg>
							<a name="" title="Новости">Новости</a>
						</li>
						<li onClick="$('.first_window').show();$('.about_window').hide();hideShowOverlay(this);$('.dropdown-menu li').removeClass('activeli');$(this).addClass('activeli');return false;">
							<svg fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
								    <path d="M-74 29h48v48h-48V29zM0 0h24v24H0V0zm0 0h24v24H0V0z" fill="none"/>
								    <path d="M13 12h7v1.5h-7zm0-2.5h7V11h-7zm0 5h7V16h-7zM21 4H3c-1.1 0-2 .9-2 2v13c0 1.1.9 2 2 2h18c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 15h-9V6h9v13z"/>
							</svg>
							<a name="" title="Статьи">Статьи</a>
						</li>
						<li onClick="$('.first_window').show();$('.about_window').hide();hideShowOverlay(this);$('.dropdown-menu li').removeClass('activeli');$(this).addClass('activeli');return false;">
							<svg fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/>
							    <path d="M0 0h24v24H0z" fill="none"/>
							</svg>
							<a name="" title="Контакты">Контакты</a>
						</li>
					</ul>
					<ul class="dropdown-menu">
						<li onClick="$('.first_window').hide();$('.about_window').show();hideShowOverlay(this);return false;">
							<a style="cursor:pointer;" name="about">Открыть "О приложении"</a>
						</li>
					</ul>
		</div>
	</div>
	
	<div id="catoverlay" style="display:none;" onclick="hideShowOverlay(this);return false;" class="">
	</div>
	
	
	<!-- first window -->
	<div class="first_window">
		<div class="breadcrumb ">
				<span>Телефоны  	</span>
		</div>
			
		<div id="container">
		
			<div id="content">
			
			
				<!-- subcat start -->
				<!-- subcat end -->
				
					
				<ul id="start" class="tiny_products">
				
					
				
					<li id="4" class="product">
						
						
				<!--  quick view -->
				
						<div class="hit"><img alt="" src="/js/hit.png"></div>		<div class="image qwbox">
											<img src="./design/images/HTC-Sensation-4G-1.200x200.jpeg">
									</div>
					
				
				<!--  quick view end -->
				
				
						<div class="product_info separator">
							<h3><a name="products/htc-sensation">HTC Sensation</a></h3>
				
							
							<!-- rating -->
								<div class="ratecomp" id="product_4">
									<div class="statVal catrater">
										<span class="rater_sm">
											<span class="rater-starsOff_sm" style="width:60px;">
												<span class="rater-starsOn_sm" style="width:48px"></span>
											</span>
										</span>
									</div>
								</div>
							
							<!-- rating (The End) -->
							
									<select class="b1c_option" name="variant">
																	<option value="5" v_unit="шт" compare_price="50 000" price="39 400" click="Вариант 1">
												Вариант 1&nbsp;
											</option>
																	<option value="255" v_unit="шт" compare_price="52 000" price="39 200" click="Вариант 2">
												Вариант 2&nbsp;
											</option>
															</select>
							 							
									<div class="price">
										<span style="display:none;">
											<input size="2" name="amount" min="1" type="number" value="1" style="width:42px; text-align:center;">&nbsp;x&nbsp;
										</span>
																	<span class="compare_price">50 000</span>
																<span class="price">39 400</span>
										<span class="currency">руб.</span>
									</div>
							
											
									<input type="submit" class="buttonred hover" value="добавлено" data-result-text="добавлено">
									<div class="wishcomp">
				
										<div class="compare addcompare">
														<a style="display:none;" class="gocompare activewc" name="/compare">
													<svg viewBox="0 0 24 24">
										    			<path d="M12 6v3l4-4-4-4v3c-4.42 0-8 3.58-8 8 0 1.57.46 3.03 1.24 4.26L6.7 14.8c-.45-.83-.7-1.79-.7-2.8 0-3.31 2.69-6 6-6zm6.76 1.74L17.3 9.2c.44.84.7 1.79.7 2.8 0 3.31-2.69 6-6 6v-3l-4 4 4 4v-3c4.42 0 8-3.58 8-8 0-1.57-.46-3.03-1.24-4.26z"></path>
										    			<path d="M0 0h24v24H0z" fill="none"></path>
													</svg>
												</a>
												<svg class="basewc" rel="4" viewBox="0 0 24 24">
														<path d="M19 8l-4 4h3c0 3.31-2.69 6-6 6-1.01 0-1.97-.25-2.8-.7l-1.46 1.46C8.97 19.54 10.43 20 12 20c4.42 0 8-3.58 8-8h3l-4-4zM6 12c0-3.31 2.69-6 6-6 1.01 0 1.97.25 2.8.7l1.46-1.46C15.03 4.46 13.57 4 12 4c-4.42 0-8 3.58-8 8H1l4 4 4-4H6z"></path>
														<path d="M0 0h24v24H0z" fill="none"></path>
												</svg>
												</div>
										
										<div class="wishprod">
											<div class="wishlist towish">
										        		        <a name="/wishlist" class="inwish">
														<svg viewBox="0 0 24 24">
													    	<path d="M0 0h24v24H0z" fill="none"></path>
													    	<path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
														</svg>
													</a>
											    	    </div>
										</div>
									
									</div>
						</div>
						
					</li>
				
					<li id="1" class="product">
						
						
				<!--  quick view -->
				
						<div class="hit"><img alt="" src="/js/hit.png"></div>		<div class="image qwbox">
											<img src="./design/images/iphone4s-white.200x200.jpeg">
									</div>
					
				
				<!--  quick view end -->
				
				
						<div class="product_info separator">
							<h3><a name="products/apple-iphone-4s-16gb">Apple iPhone 4S 16Gb</a></h3>
				
							
							<!-- rating -->
								<div class="ratecomp" id="product_1">
									<div class="statVal catrater">
										<span class="rater_sm">
											<span class="rater-starsOff_sm" style="width:60px;">
												<span class="rater-starsOn_sm" style="width:51.6px"></span>
											</span>
										</span>
									</div>
								</div>
							
							<!-- rating (The End) -->
										
									<span class="pricelist" style="display:none;">
																	<span class="c247" v_unit="шт">50 000</span>
																								<span class="c248" v_unit="шт">60 000</span>
																						</span>
							
														<span class="pricelist2" style="display:none;">
																	<span class="c247">80 000</span>																				<span class="c248">75 000</span>																		</span>
									
									<input id="vhidden" name="variant" value="247" type="hidden">
									
									<div style="display: table; margin-bottom: 5px; height: 20px;">
									
									<select class="p0" style="display:none;">
																		<option value="c247 c248" class="c247 c248"></option>
																	</select>
							
							
							
									<select class="p1">
																		<option value="c247" class="c247">Белый</option>
																		<option value="c248" class="c248">Черный</option>
																	</select>
									
									</div>
									<div class="pricecolor">
									<span style="display:none;"><input type="number" min="1" size="2" name="amount" value="1" style="width:42px; text-align:center;">&nbsp;x&nbsp;</span>
									<span id="priceold" class="compare_price">80 000</span> <span id="price" class="price">50 000</span> <span class="currency">руб.</span>
									</div>
							
											
									<input type="submit" class="buttonred" value="в корзину" data-result-text="добавлено">
									<div class="wishcomp">
									
										<div class="compare addcompare">
														<a style="display:none;" class="gocompare activewc" name="/compare">
													<svg viewBox="0 0 24 24">
										    			<path d="M12 6v3l4-4-4-4v3c-4.42 0-8 3.58-8 8 0 1.57.46 3.03 1.24 4.26L6.7 14.8c-.45-.83-.7-1.79-.7-2.8 0-3.31 2.69-6 6-6zm6.76 1.74L17.3 9.2c.44.84.7 1.79.7 2.8 0 3.31-2.69 6-6 6v-3l-4 4 4 4v-3c4.42 0 8-3.58 8-8 0-1.57-.46-3.03-1.24-4.26z"></path>
										    			<path d="M0 0h24v24H0z" fill="none"></path>
													</svg>
												</a>
												<svg class="basewc" rel="1" viewBox="0 0 24 24">
														<path d="M19 8l-4 4h3c0 3.31-2.69 6-6 6-1.01 0-1.97-.25-2.8-.7l-1.46 1.46C8.97 19.54 10.43 20 12 20c4.42 0 8-3.58 8-8h3l-4-4zM6 12c0-3.31 2.69-6 6-6 1.01 0 1.97.25 2.8.7l1.46-1.46C15.03 4.46 13.57 4 12 4c-4.42 0-8 3.58-8 8H1l4 4 4-4H6z"></path>
														<path d="M0 0h24v24H0z" fill="none"></path>
												</svg>
												</div>
										
										<div class="wishprod">
											<div class="wishlist towish">
										        		        <a name="/wishlist" class="inwish">
														<svg viewBox="0 0 24 24">
													    	<path d="M0 0h24v24H0z" fill="none"></path>
													    	<path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
														</svg>
													</a>
											    	    </div>
										</div>
									
									</div>
						
						</div>
						
					</li>
				

					<li id="17" class="product">
						
						
				<!--  quick view -->
				
						<div class="hit"><img alt="" src="/js/hit.png"></div>		<div class="image qwbox">
											<img src="./design/images/Samsung-Diva-S7070.200x200.jpeg">
									</div>
					
				
				<!--  quick view end -->
				
				
						<div class="product_info separator">
							<h3><a name="products/samsung-s7070-diva">Samsung S7070 Diva</a></h3>
				
				
							
							<!-- rating -->
								<div class="ratecomp" id="product_17">
									<div class="statVal catrater">
										<span class="rater_sm">
											<span class="rater-starsOff_sm" style="width:60px;">
												<span class="rater-starsOn_sm" style="width:48px"></span>
											</span>
										</span>
									</div>
								</div>
							
							<!-- rating (The End) -->
							
															<span style="display: block; height: 20px;"></span>
									
									<select class="b1c_option" name="variant" style="display:none;">
																	<option value="25" v_unit="шт" price="16 400" click="">
												&nbsp;
											</option>
															</select>
							 							
									<div class="price">
										<span style="display:none;">
											<input size="2" name="amount" min="1" type="number" value="1" style="width:42px; text-align:center;">&nbsp;x&nbsp;
										</span>
																<span class="price">16 400</span>
										<span class="currency">руб.</span>
									</div>
							
											
									<input type="submit" class="buttonred" value="в корзину" data-result-text="добавлено">
									<div class="wishcomp">
				
										<div class="compare addcompare">
														<a style="display:none;" class="gocompare activewc" name="/compare">
													<svg viewBox="0 0 24 24">
										    			<path d="M12 6v3l4-4-4-4v3c-4.42 0-8 3.58-8 8 0 1.57.46 3.03 1.24 4.26L6.7 14.8c-.45-.83-.7-1.79-.7-2.8 0-3.31 2.69-6 6-6zm6.76 1.74L17.3 9.2c.44.84.7 1.79.7 2.8 0 3.31-2.69 6-6 6v-3l-4 4 4 4v-3c4.42 0 8-3.58 8-8 0-1.57-.46-3.03-1.24-4.26z"></path>
										    			<path d="M0 0h24v24H0z" fill="none"></path>
													</svg>
												</a>
												<svg class="basewc" rel="17" viewBox="0 0 24 24">
														<path d="M19 8l-4 4h3c0 3.31-2.69 6-6 6-1.01 0-1.97-.25-2.8-.7l-1.46 1.46C8.97 19.54 10.43 20 12 20c4.42 0 8-3.58 8-8h3l-4-4zM6 12c0-3.31 2.69-6 6-6 1.01 0 1.97.25 2.8.7l1.46-1.46C15.03 4.46 13.57 4 12 4c-4.42 0-8 3.58-8 8H1l4 4 4-4H6z"></path>
														<path d="M0 0h24v24H0z" fill="none"></path>
												</svg>
												</div>
										
										<div class="wishprod">
											<div class="wishlist towish">
										        				<a style="display:none;" name="/wishlist" class="inwish activewc">
														<svg viewBox="0 0 24 24">
													    	<path d="M0 0h24v24H0z" fill="none"></path>
													    	<path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
														</svg>
													</a>
													<svg class="basewc" rel="17" viewBox="0 0 24 24">
													    <path d="M0 0h24v24H0z" fill="none"></path>
													    <path d="M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z"></path>
													</svg>
											    	    </div>
										</div>
									
									</div>
							
						</div>
						
					</li>
								
				</ul>
			
			<div>
				<div class="pagination separator">
					<span class="butpag selected">1</span>
					<span class="butpag">2</span>
					<a class="next_page_link" name="/catalog/telefony?page=2"><span class="v-middle">»</span></a>	
				</div>
			</div>	

	
		</div>
		
	</div>
	<!-- first window end -->	

	
		 <script type="text/javascript">{literal}
			function hideShowSearch(el){ 
				$(el).toggleClass('show');
				$('#searchtop, .hidetitle').toggle('fast');
				/*if ( $('#catalog').hasClass('showcat') ) {
					hideShowOverlay(this);
				}*/
		
				return false;
			};
			
			function hideShowMenu(el){ 
				$(el).toggleClass('showcat');
				$('#catalogtop').toggleClass('showpanel');
				$('#catoverlay').toggleClass('blur');
				$('#body').toggleClass('dontmove');
				return false;
			};
		
			function hideShowOverlay(el){ 
				$('#catalog').toggleClass('showcat');
				$('#catalogtop').toggleClass('showpanel');
				$('#catoverlay').toggleClass('blur');
				$('#body').toggleClass('dontmove');
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
			 $('+ ul', $(this).parent()).slideToggle();
			 $(this).parent().toggleClass('active');
			 $(this).html($(this).parent().hasClass('active') ? "-" : "+");
			 return false;
			 });
			 $('.filter-active span').click();
			});
		
		 {/literal}</script>
		
	
			
		
		
	
	

	
	<script type="text/javascript">
	{literal}
	
		document.addEventListener('touchstart', function(e) {
			document.addEventListener('touchend', function(e) {
			});
		});
	
		$(function() {
	        $("img,.category_products .product, a").click(function() {
	        $(this).toggleClass("active");
	        })

	    });


	      
	

	
	{/literal}
	</script>
	


</div>

	<!-- about window -->	
	<div class="about_window" style="display:none;">
		<div id="container">
			<div id="content">
				<div class="logoimagewrap">
					<img src="./design/images/logo0000.png" alt="Демо-магазин ">
				</div>
				<div class="abouttext">
					<p>Мобильное приложение Демо-магазин</p>
					<p>Все права защищены</p>
				</div>
				<div class="aboutText3">
					Разработчик www.app-for-cms.ru
				</div>
			</div>
		</div>
	</div>
	<!-- about window end -->

</div>