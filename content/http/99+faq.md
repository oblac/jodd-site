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


## How to follow multi redirects?

`HttpRequest` by default does not follow the redirect instruction sent in response.
You can use `HttpBrowser`:

~~~~~ java
HttpBrowser browser = new HttpBrowser();

browser.sendRequest(HttpRequest.get("jodd.org"));

// read response
Response response = browser.getResponse();
String page = browser.getPage();
~~~~~

From v4 `HttpRequest` has the flag `followRedirects()` to enable redirects
following.


## What is the difference between `HttpRequest` and `HttpBrowser`?

`HttpRequest` represents just a single request; clean and simple.

`HttpBrowser` emulates browsing of a website (i.e. set of URLs) like a browser.
Besides sending requests, it also stores and resends cookies, to maintain
current user session.
