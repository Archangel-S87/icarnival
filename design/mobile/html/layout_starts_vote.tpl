<div class="">
	<div class="poll_title">Ваш ответ:</div>
	<form class="pollform" method="post">
		<div class="">
			<div id="star-rating" class="js-starts">
				{foreach $survey->fields as $field}
					<input type="radio" name="stars" value="{$field->id}">
				{/foreach}
			</div>
	
		</div>
		<input type="submit" class="votebutton js-submit-vote" name="starts_submit" value="Завершить голосование" disabled="disabled" />
	</form>
</div>

<!-- 
<div class="testRater" id="post_{$survey->id}">
	<div class="poll_title">Ваша оценка:</div>

	<form class="pollform" method="post">
		<div id="star-rating" class="js-starts">
			{foreach $survey->fields as $field}
				<input type="radio" name="stars" value="{$field->id}">
			{/foreach}
		</div>
		<input type="submit" class="votebutton" value="Завершить голосование" name="starts_submit" disabled="disabled" />
	</form>
</div>

<div class="stars_poll">
	<form class="pollform" method="post">
		<div class="polloptions">
			{foreach $survey->fields as $field}
				<input name="stars" id="field_{$field->id}" value="{$field->id}" type="radio" />
			{/foreach}
		</div>
		<input type="submit" class="votebutton" value="Завершить голосование" name="starts_submit" disabled="disabled" />
	</form>
</div>
 -->

<script type="text/javascript">

;(function(factory) {
	if (typeof define === 'function' && define.amd) {
		// AMD
		define(['jquery'], factory);
	} else if (typeof exports === 'object') {
		// CommonJS
		module.exports = factory(require('jquery'));
	} else {
		factory(jQuery);
	}
}(function($) {
	'use strict';
	$.fn.rating = function(b) {
		b = b || function() {};

		this.each(function(d, c) {
			$(c).data("rating", {
				callback: b
			})
			.bind("init.rating", $.fn.rating.init)
			.bind("set.rating", $.fn.rating.set)
			.bind("hover.rating", $.fn.rating.hover)
			.trigger("init.rating");
		});
	};
	$.extend($.fn.rating, {
		init: function(h) {
			console.log('rating:init');
			var d = $(this),
				g = "",
				j = null,
				f = d.children(),
				c = 0,
				b = f.length;
			for (; c < b; c++) {
				g = g + '<a class="star" title-val="' + $(f[c]).val() + '" title="' + $(f[c]).attr('title') + '" />';
				if ($(f[c]).is(":checked")) {
					j = $(f[c]).val()
				}
			}
			f.hide();
			d.append('<div class="stars">' + g + "</div>").trigger("set.rating", j);
			$("a", d).bind("click", $.fn.rating.click);
			d.trigger("hover.rating")
		},
		set: function(f, g) {
			var c = $(this),
				d = $("a", c),
				b = undefined;
			if (g) {
				d.removeClass("fullStar");
				b = d.filter(function(e) {
					if ($(this).attr("title-val") == g) {
						return $(this)
					} else {
						return false
					}
				});
				b.addClass("fullStar").prevAll().addClass("fullStar")
			}
			return
		},
		hover: function(d) {

			var c = $(this),
				b = $("a", c);
			b.bind("mouseenter", function(f) {
				$(this).addClass("tmp_fs").prevAll().addClass("tmp_fs");
				$(this).nextAll().addClass("tmp_es")
			});
			b.bind("mouseleave", function(f) {
				$(this).removeClass("tmp_fs").prevAll().removeClass("tmp_fs");
				$(this).nextAll().removeClass("tmp_es")
			})
		},
		click: function(g) {
			g.preventDefault();
			var f = $(g.target),
				c = f.parent().parent(),
				b = c.children("input"),
				d = f.attr("title-val");

			var matchInput = b.filter(function(e) {
				if ($(this).val() == d) {
					return true
				} else {
					return false
				}
			});

			matchInput.attr("checked", true);
			c.trigger("set.rating", matchInput.val()).data("rating").callback(d, g)
		}
	});
}));

$(document).ready(function(){
	$('.js-starts').rating(function(val){
		$('.js-submit-vote')
			.attr('disabled', false);
	});
});

</script>