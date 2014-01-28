var q = ['what is jodd?', 'why jodd?', 'try jodd!']

$(document).ready(function() {

	var $window = $(window);
	var height, width;

	var $cursor = $('.cursor');
	var $cursor2 = $('#headbar .curs');

	var cursor_blink = setInterval(function() {
		$cursor.toggleClass('cursor-blink').css('visibility','');
	}, 600);
	var cursor_blink2 = setInterval(function() {
		$cursor2.toggleClass('cursor-blink').css('visibility','');
	}, 400);

	var $jodd = $('#jodd');
	var $jodd2 = $('#jodd2');

	var $info = $('#headbar .rr');
	var $bbar2a = $('#bbar2 a')

	var separatorTop, separatorBottom;
	var secondTop;
	var q1Top, q2Top, q3Top;
	var thirdTop;
	var bb2Top;

	/** RESIZE **/
	var resizeFn = function() {
		height = $window.height();
		width = $window.width();

		separatorTop = $('#separator').offset().top;
		separatorBottom = separatorTop + 80;
		secondTop = $('#second').offset().top;
		q1Top = $('#q1').offset().top;
		q2Top = $('#q2').offset().top;
		q3Top = $('#q3').offset().top;
		thirdTop = $('#third').offset().top;
		bb2Top = $('#bbar2').offset().top;

		$jodd.css('left', ((width - 360) / 2) + 'px');
		$jodd2.css('left', ((width - 360) / 2) + 'px');
		$jodd2.css('opacity', 0);

		var offset = width / 2 - 600;
		if (offset < 0) {
			offset = 0;
		}
		$('#msg .left').css('margin-left', offset + 'px');

		offset = (width / 2 - 600);
		if (offset < 0) {
			offset = 0;
		}
		$('#msg .right').css('margin-right', offset + 'px');

		$('#separator2').css('border-right-width', width);
	};

	/** SCROLL **/
	var toggle = false;
	var scrollFn = function() {
		var top = $window.scrollTop();
		var bottom = top + height;
		var bot = top + height * 0.8;

		// $('#headbar .ll').text('top:' + top + ' bot:' + bot);

		// jodd
		var vis = 0;
		if ((200 <= top) && (top < 400)) {
			vis = (top - 200) / 200;
		} else if (top < 200) {
			vis = 0;
		} else if (top >= 400) {
			vis = 1;
		}
		if (vis > 1) {
			vis = 1;
		}

		$('#msg').css('opacity', vis);

		if (top < 500) {
			$jodd.css('opacity', 1);
			$jodd2.css('opacity', 0);
		} else {
			$jodd.css('opacity', 0);
			$jodd2.css('opacity', 1);
		}

		// separator
		if ((bottom > separatorTop) && (top < separatorTop + 80)) {
			var value = (bottom - separatorTop) / 2;
			$('#separator').css('background-position', value + 'px 0')
		}

		// titles
		var ratio1 = (bot - q1Top) / 360;
		if (ratio1 > 1) {
			ratio1 = 1;
		}
		if (ratio1 > 0) {
			var newTitle = q[0].substr(0, q[0].length * ratio1);
			$('#q1 .title').text(newTitle);
		}

		var ratio2 = (bot - q2Top) / 360;
		if (ratio2 > 1) {
			ratio2 = 1;
		}
		if (ratio2 > 0) {
			var newTitle = q[1].substr(0, q[1].length * ratio2);
			$('#q2 .title').text(newTitle);
		}

		var ratio3 = (bot - q3Top) / 360;
		if (ratio3 > 1) {
			ratio3 = 1;
		}
		if (ratio3 > 0) {
			var newTitle = q[2].substr(0, q[2].length * ratio3);
			$('#q3 .title').text(newTitle);
		}
			

		// orange circle
		$('#counter').css('top', (200 -((top - secondTop) * 0.15)) + 'px');

		if (bot > q3Top) {
			$('#counter span').text('3');
		} else if (bot > q2Top) {
			$('#counter span').text('2');
		} else if (bot > q1Top) {
			$('#counter span').text('1');
		} else if (bot > secondTop + 40) {
			$('#counter span').html('&nbsp;&nbsp;');
		}

		// info
		if (top < 600) {
			$info.text('welcome! scroll down for jodd experience!');
		} else
		if (top < secondTop - 400) {
			$info.text('keep scrolling for jodd key points');
		} else 
		if (bot > bb2Top + 200) {
			$info.text('done. click jodd!');
		} else
		if (bot > thirdTop) {
			$info.text('keep scrolling...');
		} else
		if (bot > q3Top) {
			$info.text('be brave, try jodd!');
		} else
		if (bot > q2Top) {
			$info.text('find out why to use jodd');
		} else
		if (bot > q1Top) {
			$info.text('learn what is jodd');
		} else {
			$info.text('');
		}

/*		// down bar
		if (bot > bb2Top + 350) {
			if ((toggle == false) && ($bbar2a.hasClass('hover'))) {
				toggle = true;
				$bbar2a.toggleClass('hover', 'normal');
			}
		} else {
			if ($bbar2a.hasClass('hover') == false) {
				$('#bbar2 a').addClass('hover');
				toggle = false;
			}
		}
*/	};

	$window.scroll(scrollFn);
	$window.resize(resizeFn);
	
	// initialize
	resizeFn();
	scrollFn();

});
