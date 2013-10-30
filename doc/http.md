# HTTP ![HTTP](/gfx/http.png)

*HTTP* is tiny, raw HTTP client - and yet simple and convenient. It
offers a simple way to send requests and read responses. The goal is to
make things simple for everyday use; this can make developers happy :)

The best way to learn about *HTTP* is through examples.

## Simple GET

~~~~~ java
    HttpRequest httpRequest = HttpRequest.get("http://jodd.org");
    HttpResponse response = httpRequest.send();

    System.out.println(response);
~~~~~

All *HTTP* classes offers fluent interface, so you can write:

~~~~~ java
    HttpRequest httpRequest = HttpRequest.get("http://jodd.org").send();

    System.out.println(response);
~~~~~

You can build the request step by step:

~~~~~ java
    HttpRequest request = new HttpRequest();
    request
		.method("GET")
		.protocol("http")
		.host("srv")
		.port(8080)
		.path("/api/jsonws/user/get-user-by-id");
~~~~~


## Reading response

When HTTP request is sent, the whole response is stored in `HttpResponse` instance.
You can use response for various stuff. You can get the `statusCode()` or
`statusPhrase()`; or any header attribute.

Most important thing is how to read received response body. You may use one
of the following methods:

+ `body()` - raw body content, always in ISO-8859-1 encoding.
+ `bodyText()` - body text, ie string encoded as specified by "Content-Type" header.
+ `bodyBytes()` - returns raw body as byte array, so e.g. downloaded file
can be saved.


## Query parameters

Query parameters may be specified in the URL line (but then they have to
be correctly encoded).

~~~~~ java
    HttpResponse response = HttpRequest
		.get("http://srv:8080/api/jsonws/user/get-user-by-id?userId=10194")
		.send();
~~~~~

Other way is by using `query()` method:

~~~~~ java
    HttpResponse response = HttpRequest
		.get("http://srv:8080/api/jsonws/user/get-user-by-id")
		.query("userId", "10194")
		.send();
~~~~~

You can use `query()` for each parameter, or pass many arguments in one
call (varargs). You can also provide `Map<String, String>` as a
parameter too.

Note: query parameters (as well as headers and form parameters) can be
duplicated. Therefore, they are stored in an array internally. Use method
`removeQuery` to remove some parameter, or overloaded method to
replace parameter.
{: .attn}

Finally, you can reach internal query map, that actually holds all
parameters:

~~~~~ java
    Map<String, Object[]> httpParams = request.query();
    httpParams.put("userId", new String[] {"10194"});
~~~~~

## Basic Authentication

Basic authentication is made easy:

~~~~~ java
    request.basicAuthentication("test", "test");
~~~~~

## POST and form parameters

Looks very similar:

~~~~~ java
    HttpResponse response = HttpRequest
		.post("http://srv:8080/api/jsonws/user/get-user-by-id")
		.form("userId", "10194")
		.send();
~~~~~

As you can see, use `form()` in the same way to specify form parameters.
Everything what is said for `query()` applies to the `form()`.

## Upload files

Again, it's easy: just add file form parameter. Here is one real-world
example:

~~~~ java
    HttpRequest httpRequest = HttpRequest
		.post("http://srv:8080/api/jsonws/dlapp/add-file-entry")
		.form(
			"repositoryId", "10178",
			"folderId", "11219",
			"sourceFileName", "a.zip",
			"mimeType", "application/zip",
			"title", "test",
			"description", "Upload test",
			"changeLog", "testing...",
			"file", new File("d:\\a.jpg.zip")
		);

	HttpResponse httpResponse = httpRequest.send();
~~~~~

And that's really all!

## Headers

Add or reach header parameters with method `header()`. Some common
header parameters are already defined as methods, so you will find
`contentType()` etc.

## GZipped content

Just `unzip()` the response.

~~~~~ java
    HttpResponse response = HttpRequest
		.get("http://www.liferay.com")
		.acceptEncoding("gzip")
		.send();

    System.out.println(response.unzip());
~~~~~

## Use body

You can set request body manually - sometimes some APIs allow to specify
commands in it:

~~~~~ java
    HttpResponse response = HttpRequest
		.get("http://srv:8080/api/jsonws/invoke")
		.body("{'$user[userId, screenName] = /user/get-user-by-id' : {'userId':'10194'}}")
		.basicAuthentication("test", "test")
		.send();
~~~~~

Setting the body discards all previously set `form()` parameters.
{: .attn}

However, using `body()` have more sense on `HttpResponse` object, to see
the received content.

## Charsets and Encodings

By default, query and form parameters are encoded in UTF-8. This can be
changed globally in `JoddHttp`, or per instance:

~~~~~ java
    HttpResponse response = HttpRequest
		.get("http://server/index.html")
		.queryEncoding("CP1251")
		.query("param", "value")
		.send();
~~~~~

You can set form encoding similarly. Moreover, form posting detects
value of **charset** in "Content-Type" header, and if present,
it will be used.

With received content, `body()` method always returns the **raw** string
(encoded as ISO-8859-1). To get string in usable form, use method
`bodyText()`. This method uses provided **charset** from
"Content-Type" header and encodes the body string.

## Socket

As said, all communication goes through the plain `Socket`. Sometimes
you will need to configure socket before sending data. Once
`HttpRequest` is set, call `open()` first, just before `send()`:

~~~~~ java
    HttpRequest request = HttpRequest.get()...;
    Socket socket = request.open().getSocket();
    socket.setSoTimeout(1000);
    HttpResponse response = request.send();
~~~~~

## Parse from InputStreams

Both `HttpRequest` and `HttpResponse` have a method
`readFrom(InputStream)`. Basically, you can parse input stream with
these methods. This is, for example, how you can read request on server
side.

## HttpBrowser

Sending simple requests and receiving response is not enough for situation
when you have to emulate some 'walking' scenario through a target site. For
example, you might need to login, like you would do that in the browser and
than to continue browsing withing current session.

`HttpBrowser` is a tool just for that. It sends requests for you; handles
301 and 302 redirections automatically, reads cookies from the response
and stores into the new request and so on. Usage is simple:

~~~~~ java
	HttpBrowser browser = new HttpBrowser();

	HttpRequest request = HttpRequest.get("www.facebook.com");
	browser.sendRequest(request);

	// request is sent and response is received

	// process the page:
	String page = browser.getPage();

	// create new request
	HttpRequest newRequest = HttpRequest.post(formAction);

	browser.sendRequest(newRequest);
~~~~~

Browser instance handles all the cookies, allowing session to be tracked while
browsing using HTTP.

## HttpTunnel

*HTTP* is so flexible that you can easily build a HTTP tunnel with it -
small proxy between you and destination. We even give you a base class:
`HttpTunnel` class, that provides easy HTTP tunneling. It opens server
socket on one port and tunnels the whole HTTP traffic to some target
address.

[TinyTunnel][1] is one implementation that simply prints
out the whole communication to the console.


[1]: https://github.com/oblac/tools/blob/master/src/jodd/tools/http/TinyTunnel.java
