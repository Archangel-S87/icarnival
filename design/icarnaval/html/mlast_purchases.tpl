{* Не забудьте раскомментировать блок в view/View.php *}
{if $last_purchases}
<!-- incl. mlast_purchases -->
<!--noindex-->
<div id="lastpurchases">
<h2>Недавно купили</h2>
	<ul>
		{foreach $last_purchases as $lp}
		<li>{$lp->product_name|escape} (<span class="price">{$lp->price|convert}</span> <span class="currency">{$currency->sign|escape}</span>)</li>
		{/foreach}
	</ul>
</div>
<!--/noindex-->
<!-- incl. mlast_purchases @ -->
{/if}