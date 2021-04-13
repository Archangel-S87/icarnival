<div class="scroll_wrapper">
	<div class="scroll_container">

		<div id="cmslogo">
			<img src="/fivecms/design/images/5cms.png" alt="5CMS"/>
		</div>
		{if in_array('products', $manager->permissions) || in_array('categories', $manager->permissions) || in_array('brands', $manager->permissions) || in_array('features', $manager->permissions)}
		<div class="menuseparator {if $mod=="ProductsAdmin" || $mod=="ProductAdmin" || $mod=="CategoriesAdmin" || $mod=="CategoryAdmin" || $mod=="BrandsAdmin" || $mod=="BrandAdmin" || $mod=="FeaturesAdmin"  || $mod=="FeatureAdmin"} showed{/if}">
			<div class="menutitle">{$tr->prods_cat|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>	
				{if in_array('products', $manager->permissions)}
					<li><a href="index.php?module=ProductsAdmin">{$tr->products|escape}</a></li>
				{/if}
				{if in_array('categories', $manager->permissions)}
					<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>
				{/if}
				{if in_array('brands', $manager->permissions)}
					<li><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>
				{/if}
				{if in_array('features', $manager->permissions)}
					<li><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>
				{/if}
			</ul>
		</div>
		{/if}

		{if in_array('orders', $manager->permissions) || in_array('labels', $manager->permissions)}
		<div class="menuseparator {if $mod=="OrdersAdmin" || $mod=="OrderAdmin" || $mod=="OrdersLabelsAdmin" || $mod=="OrdersLabelAdmin"} showed{/if}">
			<div class="menutitle">{$tr->orders|escape}					
				<div onclick="window.location='/fivecms/index.php?module=OrdersAdmin'" class="counter tooltips" id="count_new_orders" style="{if !$new_orders_counter}display:none{/if}">
					<span>{$new_orders_counter}</span> 
				</div>
			</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul id="main_menu">				
				<li>
					<a href="index.php?module=OrdersAdmin">{$tr->orders|escape} <div onclick="window.location='/fivecms/index.php?module=OrdersAdmin'" class="counter tooltips" id="count_new_orders" style="{if !$new_orders_counter}display:none{/if}">
					<span>{$new_orders_counter}</span> 
				</div></a>
				</li>
				<li><a href="index.php?module=OrdersLabelsAdmin">{$tr->orders_labels|escape}</a></li>
			</ul>
		</div>
		{/if}

		{if in_array('users', $manager->permissions) || in_array('groups', $manager->permissions) || in_array('mailer', $manager->permissions) || in_array('trigger', $manager->permissions)}
		<div class="menuseparator {if $mod=="UsersAdmin" || $mod=="UserAdmin" || $mod=="GroupsAdmin" || $mod=="GroupAdmin" || $mod=="MailerAdmin" || $mod=="MailListAdmin" || $mod=="TriggerAdmin"} showed{/if}">
			<div class="menutitle">{$tr->users|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>			
				{if in_array('users', $manager->permissions)}
					<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>
				{/if}					
				{if in_array('groups', $manager->permissions)}
					<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>
				{/if}	
				{if in_array('mailer', $manager->permissions)}
					<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>
				{/if}
				{if in_array('trigger', $manager->permissions)}
					<li><a href="index.php?module=TriggerAdmin">{$tr->trigger|escape}</a></li>
				{/if}
			</ul>
		</div>		
		{/if}	

		{if in_array('pages', $manager->permissions) || in_array('menus', $manager->permissions)}
		<div class="menuseparator {if $mod=="PagesAdmin" || $mod=="PageAdmin" || $mod=="MenuAdmin"} showed{/if}">
			<div class="menutitle">{$tr->pages|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>				
				<li><a href="index.php?module=PagesAdmin">{$tr->pages|escape}</a></li>
				<li><a href="index.php?module=MenuAdmin">{$tr->pages_menu|escape}</a></li>
			</ul>
		</div>		
		{/if}

		{if in_array('blog', $manager->permissions) || in_array('articles_categories', $manager->permissions) || in_array('articles', $manager->permissions)}
		<div class="menuseparator {if $mod=="BlogAdmin" || $mod=="PostAdmin" || $mod=="ArticlesCategoriesAdmin" || $mod=="ArticlesCategoryAdmin" || $mod=="ArticlesAdmin" || $mod=="ArticleAdmin" || $mod=="BlogCategoriesAdmin" || $mod=="BlogCategoryAdmin"} showed{/if}">
			<div class="menutitle">{$tr->blog_articles|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>				
				{if in_array('blog', $manager->permissions)}
					<li><a href="index.php?module=BlogCategoriesAdmin">{$tr->blog_categories|escape}</a></li>
					<li><a href="index.php?module=BlogAdmin">{$tr->blog|escape}</a></li>
				{/if}					
				{if in_array('articles_categories', $manager->permissions)}
					<li><a href="index.php?module=ArticlesCategoriesAdmin">{$tr->articles_categories|escape}</a></li>
				{/if}
				{if in_array('articles', $manager->permissions)}
					<li><a href="index.php?module=ArticlesAdmin">{$tr->articles|escape}</a></li>
				{/if}
			</ul>
		</div>			
		{/if}

		{if in_array('comments', $manager->permissions) || in_array('feedbacks', $manager->permissions) || in_array('design', $manager->permissions)}
		<div class="menuseparator {if $mod=="CommentsAdmin" || $mod=="CommentAdmin" || $mod=="FeedbacksAdmin" || $mod=="FormsAdmin" || $mod=="FormAdmin" || $mod=="MailTemplatesAdmin"} showed{/if}">
			<div class="menutitle">{$tr->feedback|escape} {if $new_comments_counter}<div onclick="window.location='/fivecms/index.php?module=CommentsAdmin'" style="margin-left:10px;position: relative;" class='counter'><span>{$new_comments_counter}</span></div>{/if}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul id="main_menu">				
				{if in_array('comments', $manager->permissions)}
					<li><a href="index.php?module=CommentsAdmin">{$tr->comments|escape} {if $new_comments_counter}<div onclick="window.location='/fivecms/index.php?module=CommentsAdmin'" style="margin-left:10px;position: relative;" class='counter'><span>{$new_comments_counter}</span></div>{/if}</a>
					</li>
				{/if}					
				{if in_array('feedbacks', $manager->permissions)}
					<li><a href="index.php?module=FeedbacksAdmin">{$tr->email|escape}</a></li>
					<li><a href="index.php?module=FormsAdmin">{$tr->forms|escape}</a></li>
				{/if}
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=MailTemplatesAdmin">{$tr->mail_templates|escape}</a></li>
				{/if}	
			</ul>
		</div>			
		{/if}	

		{if in_array('import', $manager->permissions) || in_array('export', $manager->permissions) || in_array('multichanges', $manager->permissions) || in_array('backup', $manager->permissions) || in_array('import', $manager->permissions)}
		<div class="menuseparator {if in_array($mod, array('ImportAdmin', 'ImportYmlAdmin', 'ExportAdmin', 'MultichangesAdmin', 'BackupAdmin', 'OnecAdmin'))} showed{/if}"
		>
			<div class="menutitle">{$tr->automation|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>				
				{if in_array('import', $manager->permissions)}
					<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>
					<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>
				{/if}					
				{if in_array('export', $manager->permissions)}
					<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>
				{/if}
				{if in_array('settings', $manager->permissions)}
					<li><a href="index.php?module=SetCatAdmin#manageyandex">{$tr->export|escape} YML</a></li>
				{/if}	
				{if in_array('multichanges', $manager->permissions)}
					<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>
				{/if}
				{if in_array('backup', $manager->permissions)}
					<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>
				{/if}	
				{if in_array('import', $manager->permissions)}
					<li><a href="index.php?module=OnecAdmin">{$tr->cml|escape}</a></li>
				{/if}
			</ul>
		</div>		
		{/if}		

		{if in_array('stats', $manager->permissions)}
		<div class="menuseparator" onclick="window.location='/fivecms/index.php?module=StatsAdmin'">
			<div class="menutitle"><a href="index.php?module=StatsAdmin">{$tr->stats|escape}</a></div>
		</div>				
		{/if}

		{if in_array('design', $manager->permissions) || in_array('slides', $manager->permissions)}
		<div class="menuseparator {if in_array($mod, array('ThemeAdmin', 'ColorAdmin', 'SlidesAdmin', 'SlideAdmin', 'MobthemeAdmin', 'SlidesmAdmin', 'SlidemAdmin', 'MobsetAdmin', 'MobileTemplatesAdmin', 'MobileStylesAdmin', 'ImagesAdmin', 'TemplatesAdmin', 'StylesAdmin', 'BannersAdmin', 'ScriptsAdmin', 'MobileScriptsAdmin'))} showed{/if}">
			<div class="menutitle">{$tr->design|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul><li><a class="menu_nonactive" name="desktop">- {$tr->desktop|escape} -</a></li>	
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=ThemeAdmin">{$tr->themes|escape}</a></li>
				{/if}
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=ColorAdmin">{$tr->gamma|escape}</a></li>
				{/if}
				{if in_array('slides', $manager->permissions)}
					<li><a href="index.php?module=SlidesAdmin">{$tr->slider|escape}</a></li>
					<li><a href="index.php?module=BannersAdmin">{$tr->banners|escape}</a></li>
				{/if}
				<li><a class="menu_nonactive" name="mob-diz">- {$tr->mobile|escape} -</a></li>	
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=MobileTemplatesAdmin">{$tr->mob_diz|escape}</a></li>
				{/if}
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>
				{/if}
				{if in_array('slides', $manager->permissions)}
					<li><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>
				{/if}
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>
				{/if}
			</ul>
		</div>
		{/if}
		{if in_array('settings', $manager->permissions) || in_array('delivery', $manager->permissions) || in_array('payment', $manager->permissions) || in_array('managers', $manager->permissions) || in_array('currency', $manager->permissions) || in_array('discountgroup', $manager->permissions) || in_array('settings', $manager->permissions)}	
		<div class="menuseparator {if in_array($mod, array('SettingsAdmin', 'SetCatAdmin', 'SetModAdmin', 'SmtpAdmin', 'SocialAdmin', 'DeliveriesAdmin', 'DeliveryAdmin', 'PaymentMethodsAdmin', 'PaymentMethodAdmin', 'ManagersAdmin', 'ManagerAdmin', 'CurrencyAdmin', 'DiscountGroupAdmin', 'SystemAdmin', 'CouponsAdmin', 'CouponAdmin'))}showed{/if}">
			<div class="menutitle">{$tr->settings|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>	
				{if in_array('settings', $manager->permissions)}
					<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>
					<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat|escape}</a></li>
					<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules|escape}</a></li>
					<li><a href="index.php?module=SmtpAdmin">{$tr->smtp|escape}</a></li>
					<li><a href="index.php?module=SocialAdmin">{$tr->social|escape}</a></li>
				{/if}
				{if in_array('delivery', $manager->permissions)}
					<li><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>
				{/if}
				{if in_array('payment', $manager->permissions)}
					<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>
				{/if}
				{if in_array('managers', $manager->permissions)}
					<li><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>
				{/if}
				{if in_array('currency', $manager->permissions)}
					<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>
				{/if}
				{if in_array('discountgroup', $manager->permissions)}
					<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>
				{/if}
				{if in_array('settings', $manager->permissions)}
					<li><a href="index.php?module=SystemAdmin">{$tr->system_title|escape}</a></li>
				{/if}
				{if in_array('design', $manager->permissions)}
					<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>
				{/if}
			</ul>
		</div>
		{/if}
		{if in_array('promo', $manager->permissions)}
		<div class="menuseparator {if in_array($mod, array('PromoAdmin', 'MetadataPageAdmin', 'MetadataPagesAdmin', 'LinksAdmin', 'LinkAdmin', 'RobotsAdmin'))}showed{/if}">
			<div class="menutitle">SEO</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>
				<li><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>
				<li><a href="index.php?module=MetadataPagesAdmin">{$tr->metadata_pages|escape}</a></li>
				<li><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>
				<li><a href="index.php?module=RobotsAdmin">robots.txt</a></li>
			</ul>
		</div>
		{/if}

		{if in_array('pages', $manager->permissions)}
		<div class="menuseparator" onclick="window.location='/fivecms/index.php?module=ServicesCategoriesAdmin'">
			<div class="menutitle"><a href="index.php?module=ServicesCategoriesAdmin">{$tr->services|escape}</a></div>
		</div>				
		{/if}

		{if in_array('surveys', $manager->permissions) || in_array('surveys_categories', $manager->permissions)}
		<div class="menuseparator {if $mod=="SurveysCategoriesAdmin" || $mod=="SurveysCategoryAdmin" || $mod=="SurveysAdmin" || $mod=="SurveyAdmin"} showed{/if}">
			<div class="menutitle">{$tr->surveys|escape}</div>
			<div class="arrow">
				<svg viewBox="0 0 20 20"><path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"></path><path d="M0-.25h24v24H0z" fill="none"></path></svg>
			</div>
			<ul>				
				<li><a href="index.php?module=SurveysCategoriesAdmin">{$tr->surveys_categories|escape}</a></li>
				<li><a href="index.php?module=SurveysAdmin">{$tr->surveys|escape}</a></li>
			</ul>
		</div>		
		{/if}

	</div>
 </div>

<script type="text/javascript">
	$(".menuseparator").click(function() { 
		if($(this).hasClass('showed')) {
			$(".menuseparator").removeClass("showed");
		} else {
			$(".menuseparator").removeClass("showed");
			$(this).addClass("showed");
		}
	});
</script>	

