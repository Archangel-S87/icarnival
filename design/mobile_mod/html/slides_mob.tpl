{get_slidesm var=slidem}
{if !empty($slidem)}
<!-- incl. slides_mob -->
	<script src="js/mobile/slider.js"></script>
	<div id="slider" class="swipe">
		<div class="swipe-wrap">
			{foreach $slidem as $s}
				{if !empty($s->image)}
					<div>
						<img {if !$s@first}loading="lazy" {/if}{if $s->url}onclick="window.location='{$s->url}'"{/if} src="{$s->image}?v={filemtime("{$s->image}")}" alt="{if !empty($s->name)}{$s->name}{/if}" {if !empty($s->name)}title="{$s->name}"{/if} />
					</div>
				{/if}
			{/foreach}
		</div>
	</div>
	<div class="sliderdots">
		<div class="dotswrapper">
			{foreach $slidem as $s}
				{if !empty($s->image)}
					<div id="{$s@iteration - 1}" class="dot{if $s@first} active{/if}"></div>
				{/if}
			{/foreach}
		</div>
	</div>
<!-- incl. slides_mob @ -->	
{/if}