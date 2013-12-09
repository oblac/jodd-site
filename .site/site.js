
/* Generates Jodd javadoc link */
function javadoc(key) {
	return "<a href=\"http://jodd.org/api/index.html?jodd/" + key + "/package-summary.html\" target=\"_new\" class=\"javadoc\"><img src=\"/gfx/javadoc.png\" alt=\"javadoc\"></a>";
}

/* Generates toc */
function toc() {
	try {
		eval("var _t = " + _toc)
	} catch(e) {
		return "";
	}
	if (_t.length == 0) {
		return "";
	}
	var str = "<h2>Content</h2>\n<ul class=\"toc-1\">";
	for (var i = 0; i < _t.length; i++) {
		var t = _t[i];
		str = str + "<li class=\"toc-" + t[1];
		str = str + "\"><a href=\"#" + t[0] + "\">";
		str = str + t[2] + "</a></li>\n";
	}

	return str;
}

/* Generates chapter list */
function doc1(name, maxlen, all) {
	try {
		eval("var _d = " + _doc)
	} catch(e) {
		return e;
	}
	eval("var _f = " + _file);

	all = all || -1;
	maxlen = maxlen || -1;

	var str = "";
	var chapters = _d[name];

	if (!chapters) {
		return str;
	}

	var first = true;

	str = str + "<ul class=\"doc-all\">";
	chapters.forEach(function(chap) {
		if (all != -1) {
			if (all == 0 && chap.ndx != 0) {
				return;
			}
			if (all == 1 && chap.ndx == 0) {
				return;
			}
		}

		str = str + "<li class=\"doc-item";
		if (_f.path == chap.source) {
			str = str + " doc-this";
		}
		if (all == -1) {
			if (chap.ndx == 0 && first == true) {
				first = false;
				str = str + " doc-more";
			}
		}
		str = str + "\"><a href=\"" + chap.path + "\"";
		str = str + " title=\"" + chap.title + "\">";
		if (chap.ndx != 0) {
			str = str + "<span>" + chap.ndx + ". </span>";
		}

		var title = chap.title;
		if (maxlen != -1) {
			if (title.length > maxlen) {
				title = title.substring(0, maxlen) + "...";
			}
		}
		str = str + title;
		str = str + "</a>";
	});
	str = str + "</ul>";

	return str;
}