{$totalvotes = 0}
{foreach $survey->fields as $field}
	{$totalvotes = $totalvotes + $field->count}
{/foreach}
<!-- incl. pollresults -->
<div class="article_poll">
	<div class="poll_title">Результаты <span class="percent_title">%</span></div>
		<div class="polloptions results">
			{foreach $survey->fields as $field}
				<div>
					{if $survey->vote_type == 3}
						<label for="field_{$field->id}">{for $foo=1 to $field->name|intval}<img src="/js/surveys/stars_active_small.png" alt=""/>{/for}</label>
					{else}
						<label for="field_{$field->id}">{$field->name|escape}</label>
					{/if}
					<span class="variant_percent">
						{$percent = 0}
						{$percent = (($field->count * 100)/$totalvotes)|round:0}
						{if $percent>0}<span class="vote-line" style="width:{$percent*2}px;">{$percent}</span>{/if}
					</span>
				</div>
			{/foreach}
		</div>
		<div class="votebutton active voteback" onclick="window.location='/surveys';">Вернуться</div>
</div>
<!-- incl. pollresults @ -->