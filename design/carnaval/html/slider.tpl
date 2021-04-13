{get_slides var=slide}
{if !empty($slide)}
<!-- incl. slider -->
	<script src="js/jquery/jquery.nivo.slider.pack.js"></script>
	<div class="slider-wrapper theme-default">
		<div id="slider" class="nivoSlider">
			{foreach $slide as $s}
				{if !empty($s->image)}
					{if !empty($s->url)}<a {if !empty($s->name)}title="{$s->name|escape}"{/if} href="{$s->url}">{/if}
						<img style="display:none;" src="{$s->image}?v={filemtime("{$s->image}")}" alt="{$s->name|escape}" title="{$s->name|escape}" {if $s->description}data-title="#slide_{$s->id}"{/if} />
					{if !empty($s->url)}</a>{/if}
				{/if}
			{/foreach}
		</div>
	</div>
	{foreach $slide as $s}
		{if !empty($s->description)}
			<div id="slide_{$s->id}" class="nivo-html-caption">
				{$s->description}
			</div>
		{/if}
	{/foreach}
<!-- incl. slider @-->
{/if}