<!-- incl. mreviews -->
<!--noindex-->
{if $settings->purpose == 0}
	{get_comments var=last_comments limit=3 type='product'}
{else}
	{get_comments var=last_comments limit=3 type='blog'}
{/if}
{if $last_comments}
	<div class="box-heading">Последние <a href="reviews-archive" class="bloglink" title="Все отзывы">отзывы</a></div>
	<div class="box-content adapt-carousel">
		<div class="box-product">
			<div id="commnts">
				<ul class="response">
					{foreach $last_comments as $comment}
						<li>
				            <p><strong>{$comment->name}</strong> 
				            {if $settings->purpose == 0}
				            	о товаре <a title="{$comment->product|escape}" href="products/{$comment->url}">{$comment->product|escape}</a>:
				            {else}
				            	к записи <a title="{$comment->product|escape}" href="blog/{$comment->url}">{$comment->product|escape}</a>:
				            {/if} 
				            &laquo;{$comment->text|truncate:150:"...":true}&raquo;</p>
				        </li>
				    {/foreach}
				</ul>  
			</div>
		</div>
	</div>
{/if}
<!--/noindex-->
<!-- incl. mreviews @ -->