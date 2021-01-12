<div class="article_poll">
	<div class="poll_title">Ваш ответ:</div>
	<form class="pollform" method="post">
		<div class="polloptions">
			{foreach $survey->fields as $field}
				<div>
					<label for="field_{$field->id}">{$field->name|escape}</label>
					<input class="js-change-radio-vote" name="radio" id="field_{$field->id}" value="{$field->id}" type="radio">
				</div>
			{/foreach}
		</div>
		<input type="submit" class="votebutton js-submit-vote" name="vote_submit" value="Завершить голосование" disabled="disabled" />
	</form>
</div>

<script type="text/javascript">
	$(document).on('change', '.js-change-radio-vote', function(event) {
		event.preventDefault();
		$('.js-change-radio-vote').parent().removeClass('active'); // TODO я бы перенес в css
		$('.js-submit-vote')
			.attr('disabled', false);

		$(this).parent().addClass('active'); // TODO я бы перенес в css
	});
</script>

