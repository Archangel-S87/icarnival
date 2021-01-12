// Звёздный рейтинг товаров
$.fn.rater = function (options) {
    var opts = $.extend({}, $.fn.rater.defaults, options);
    return this.each(function () {
        var $this = $(this);
        var $on = $this.find('.rater-starsOn');
        var $off = $this.find('.rater-starsOff');
        opts.size = $on.height();
        if (opts.rating == undefined) opts.rating = $on.width() / opts.size;
        if (opts.id == undefined) opts.id = $this.attr('id');

        $off.mousemove(function (e) {
            var left = e.clientX - $off.offset().left;
            var width = $off.width() - ($off.width() - left);
            width = Math.ceil(width / (opts.size / opts.step)) * opts.size / opts.step;
            $on.width(width);
        }).hover(function (e) { $on.addClass('rater-starsHover'); }, function (e) {
            $on.removeClass('rater-starsHover'); $on.width(opts.rating * opts.size);
        }).click(function (e) {
            var r = Math.round($on.width() / $off.width() * (opts.units * opts.step)) / opts.step;
            $off.unbind('click').unbind('mousemove').unbind('mouseenter').unbind('mouseleave');
            $off.css('cursor', 'default'); $on.css('cursor', 'default');
            $.fn.rater.rate($this, opts, r);
        }).css('cursor', 'pointer'); $on.css('cursor', 'pointer');
    });
};

$.fn.rater.defaults = {
    postHref: location.href,
    units: 5,
    step: 1
};

$.fn.rater.rate = function ($this, opts, rating) {
    var $on = $this.find('.rater-starsOn');
    var $off = $this.find('.rater-starsOff');
    $off.fadeTo(600, 0.4, function () {
        $.ajax({
            url: opts.postHref,
            type: "POST",
            data: 'id=' + opts.id + '&rating=' + rating,
            complete: function (req) {
                if (req.status == 200) { //success
                    opts.rating = parseFloat(req.responseText);

                    if (opts.rating > 0) {
                        opts.rating = parseFloat(req.responseText);
                        $off.fadeTo(200, 0.1, function () {
                            $on.removeClass('rater-starsHover').width(opts.rating * opts.size);
                            var $count = $this.find('.rater-rateCount');
                            $count.text(parseInt($count.text()) + 1);
                            $this.find('.rater-rating').text(opts.rating.toFixed(1));
                            $off.fadeTo(200, 1);
                        });
                        //alert('Спасибо! Ваш голос учтен.');
                    }
                    else
					if (opts.rating == -1) {
						$off.fadeTo(200, 0.6, function () {
                            $this.find('.test-text').text('Вы уже голосовали!');
                        });
						//alert('Вы уже голосовали за данный товар!');
					}
                    else {
						$off.fadeTo(200, 0.6, function () {
                            $this.find('.test-text').text('Вы уже голосовали!');
                        });
						//alert('Вы уже голосовали за данный товар!');
					}
                } else { //failure
                    alert(req.responseText);
                    $on.removeClass('rater-starsHover').width(opts.rating * opts.size);
                    $this.rater(opts);
                    $off.fadeTo(2200, 1);
                }
            }
        });
    });
};
// end