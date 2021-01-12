<div class="wishcomp">
	<div class="compare addcompare">
		{if !empty($compare_informer->items_id[{$product->id}])}
			<span class="gocompare activewc" onclick="window.location='/compare'">
				<svg><use xlink:href='#activec' /></svg>
			</span>
		{else}
			<span style="display:none;" class="gocompare activewc" onclick="window.location='/compare'">
				<svg><use xlink:href='#activec' /></svg>
			</span>
			<svg class="basewc" data-wish="{$product->id}"><use xlink:href='#basec' /></svg>
		{/if}
	</div>
	<div class="wishprod">
		<div class="wishlist towish">
			{if $product->id|in_array:$wished_products}
				<span onclick="window.location='/wishlist'" class="inwish activewc">
					<svg><use xlink:href='#activew' /></svg>
				</span>
			{else}
				<span style="display:none;" onclick="window.location='/wishlist'" class="inwish activewc">
					<svg><use xlink:href='#activew' /></svg>
				</span>
				<svg class="basewc" data-wish="{$product->id}"><use xlink:href='#basew' /></svg>
			{/if}
		</div>
	</div>
</div>