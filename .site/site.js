/* Generates Jodd javadoc link */
function javadoc(key) {
	return "<a href=\"http://jodd.org/api/index.html?jodd/" + key + "/package-summary.html\" target=\"_new\" class=\"javadoc\"><img src=\"/gfx/javadoc.png\" alt=\"javadoc\"></a>";
}

/* Generates toc */
function toc() {
	try {
		eval("var _t = " + _toc)
	} catch(er) {
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