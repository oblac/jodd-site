(function($) { 
$.toc = function(dest, tocList) {
	$(tocList).addClass('jquery-toc');
	var tocListArray = tocList.split(',');
	$.each(tocListArray, function(i,v) { tocListArray[i] = $.trim(v); });
	
	var $elements = $('.jquery-toc');
	var $toc = $(dest);
	
	var lastLevel = 1;
	var anchorList = [];
	$toc.append('<ul class="jquery-toc-1"><li><a href="#">' + $('h1').text() + '</a></li></ul>');
	
	$elements.each(function() {
		var $e = $(this);
		var text = $e.text();
		var anchor = text.replace(/[^A-za-z0-9]/g,'-');
		var z = 0; 
		$e.before('<a class="anchor" name="' + anchor + '"></a>');
		var level;
		
		$.each(tocListArray, function(i,v) { 
		if (v.match(' ')) {
			var vArray = v.split(' '); 
			var e = vArray[vArray.length - 1];
		} else { e = v; }
			if ($e.is(e)) { level = i+1; } 
		});
		
		var className = 'jquery-toc-' + level;
		var li = '<li><a href="#' + anchor + '">' + text + '</a></li>';
		
		if (level == lastLevel) {
			$('ul.' + className + ':last',$toc).append(li);
		} else if (level > lastLevel) {
			var parentLevel = level - 1;
			var parentClassName = 'jquery-toc-' + parentLevel;
			$('ul.' + parentClassName + ':last',$toc).append('<ul class="' + className + '"></ul>');
			$('ul.' + className + ':last',$toc).append(li);
		} else if (level < lastLevel) {
			$('ul.' + className + ':last',$toc).append(li);
		}
		lastLevel = level;
	
	});
}
})(jQuery);
