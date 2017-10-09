# FAQ

Everything you always wanted to know about *HTTP* (but were afraid to ask).

## How to save a binary file?

~~~~~ java
final String link =
	"https://repo1.maven.org/maven2/org/jodd/jodd-http/3.9.1/jodd-http-3.9.1.jar";

HttpResponse response = HttpRequest
	.get(link)
	.send();

byte[] bytes = response.bodyBytes();

FileUtil.writeBytes(
	new File(SystemUtil.userHome(), "jodd-http.jar"), bytes);
~~~~~
