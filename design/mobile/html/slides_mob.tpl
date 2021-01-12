{get_slidesm var=slidem}
{if !empty($slidem)}
	<script src="androidcore/slider.js"></script>
	<div id="slider" class="swipe">
		<div class="swipe-wrap">
			{foreach $slidem as $s}
				{if !empty($s->image)}
					<div>
						<img loading="lazy" {if $s->url}onclick="window.location='{$s->url}'"{/if} src="{$s->image}" alt="{if !empty($s->name)}{$s->name}{/if}" {if !empty($s->name)}title="{$s->name}"{/if} />
					</div>
				{/if}
			{/foreach}
		</div>
	</div>
	<div class="sliderdots">
		<div class="dotswrapper">
			{$cslidem = 0}
			{foreach $slidem as $s}
				{if !empty($s->image)}
					<div id="{$cslidem}" class="dot{if $cslidem == 0} active{/if}"></div>
					{$cslidem = $cslidem + 1}
				{/if}
			{/foreach}
		</div>
	</div>
{/if}