# Default Action Results

Here goes the list of all *Madvoc* Action results. Vast number of these results handlers work in the same way: they create a _result path_ based on action path and specified string value. Result path is then used for actual redirection/fowarding and so on.


## Dispatcher result ('Forward')

This result finds the closest JSP that match the result path and then forwards to it.

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public Forward world() {
    		return Forward.to("ok");
    	}
    }
~~~~~

The action is mapped to the action path: `/hello.world`, but will be invoked also when user calls `/hello.world.html`. Result value is `ok`. Now, the following list of JSPs are checked, in given order:

* `/hello.world.html.ok.jspf`
* `/hello.world.html.ok.jsp`
* `/hello.world.html.jspf`
* `/hello.world.html.jsp`
* `/hello.world.ok.jspf`
* `/hello.world.ok.jsp`
* `/hello.world.jspf`
* `/hello.world.jsp`
* `/hello.ok.jspf`
* `/hello.ok.jsp`
* `/hello.jspf`
* `/hello.jsp`
* `/ok.jspf`
* `/ok.jsp`

Dispatcher finds the first matching JSP(F). If no page is found, error 404 is returned.

Dispatcher caches results, so scanning for each result value is done only once!
{: .attn}

Finally, when target JSP is found, dispatcher detects if current request is included, so to performs either `include` or straight `forward` to the target page.

## Redirect result ('Redirect')

Servlet redirection is simple: result value specifies the redirection
URL. Usually, result value specifies full result path (starts with
'**/**'):

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public Redirect world() {
    		return Redirect.to("/index.html");
    	}
    }
~~~~~

Redirection URL may contain all necessary parameters within it. Speaking of which, *Jodd* provides nice utility for building url's and encoding parameters: `UrlEncoder`.

Moreover, it is possible to inject action properties into the resulting URL:

~~~~~ java
    @MadvocAction
    public class OneAction {

    	String value;

    	@Action
    	public Redirect execute() {
    		value = "173";
    		return "Redrect.to("/index.html?value=${value}");
    	}
    }
~~~~~

Invocation of action path: `/one.html` will perform the redirection to: `/index.html?value=173`.


## Redirect Permanently ('Url')

This result redirects permanently (301) to an external URL. For everything else
it works just like redirect result.


## Chain result ('Chain')

Chaining actions is similar to forwarding, except it is done by `Madvoc`
and not by servlet container. Chain result handler takes result
value as the next action path. Chaining to the next action happens after
the complete execution of first action, including all interceptors
(but not filters!). The following example illustrates this:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public Chain chain() {
    		return Chain.to("/hello.link.html");
    	}

    	@Action
    	public void link() {
    	}
    }
~~~~~

First action is mapped to the `/hello.chain.html`. After the execution
of this action finishes, *Madvoc* will continue to the next action,
`/hello.link.html`. When the send action is invoked, it is executed in
the very same way as it would be if the request would come from the
outside. There is no difference between chained execution and regular
one.

When chaining, first action may send custom data to the next action by
setting values in various scopes (request, session, etc).

## No results

There are situations when data needs to be sent directly to the output
stream of HTTP response. In that case, action method is responsible for
sending the full response.

## TextResult

Allows to simply define text that has to be written back to the output stream:

~~~~~ java
    @Action
    public TextResult hello() {
        return TextResult.of("Jodd is awesome!").asHtml();
    }
~~~~~

## RawData

The `RawData` result specifies byte content (from file or memory) that has to be returned.

Example:

~~~~~ java
    @Action
    public RawData image() {
        return RawData.of(SMALLEST_GIF).as("gif");
    }
~~~~~

This action returns a GIF content, but also specifies mime type common to the `gif` extension.