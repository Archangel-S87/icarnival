<div class="article_poll">
	<div class="poll_title">Ваш ответ:</div>
	<form class="pollform" method="post">
		<div class="polloptions">
			{foreach $survey->fields as $field}
				<div>
					<label for="field_{$field->id}">{$field->name|escape}</label>
					<input class="js-change-checkbox-vote" name="checkbox[]" id="field_{$field->id}" value="{$field->id}" type="checkbox">
				</div>
			{/foreach}
		</div>
		<input type="submit" class="votebutton js-submit-vote" name="vote_submit" value="Завершить голосование" disabled="disabled" />
	</form>
</div>

<script type="text/javascript">
	$(document).on('change', '.js-change-checkbox-vote', function(event) {
		event.preventDefault();

		$('.js-submit-vote').attr("disabled", !$('.js-change-checkbox-vote').is(":checked"));
	
		$(this).parent().toggleClass('active'); // TODO перенсти в css
	});
</script>

