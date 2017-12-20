# Default Action Results

Here goes the list of all *Madvoc* Action results. Some of them
are registered for names, some are meant to be used differently.

## Dispatcher result ('dispatch')

Servlet dispatcher is the default action result when name is not specified.
In short, this result finds the closest JSP that match result path and
then forwards to it.

Remember when we said that result path is not just a simple string,
but it always has two parts: action path and result value? Dispatcher
result uses this to find matching JSP. It first start with full
action path with or without result path. If JSP page is not found,
the action path is shorten (by removing word after the last dot)
and the same check goes on again.

It will be much clearer when you see the following example:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public String world() {
    		return "ok";
    	}
    }
~~~~~

This action is mapped to action path: `/hello.world.html`.
Result value is `ok`. The following list of JSPs are checked,
in given order:

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

Dispatcher finds the first matching JSP(F). If no page is found, error
404 is returned.

Dispatcher caches results, so scanning for each result value is done
only once!
{: .attn}

Finally, when target JSP is found, dispatcher detects if
current request is included, so to performs either `include`
or straight `forward` to the target page.

## Redirect result ('redirect')

Servlet redirection is simple: result value specifies the redirection
URL. Usually, result value specifies full result path (starts with
'**/**'):

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public String world() {
    		return "redirect:/index.html";
    	}
    }
~~~~~

Redirection URL may contain all necessary parameters within it. Speaking
of which, *Jodd* provides nice utility for building url's and encoding
parameters: `UrlEncoder`.

Moreover, it is possible to inject action properties into the resulting
URL:

~~~~~ java
    @MadvocAction
    public class OneAction {

    	String value;

    	@Action
    	public String execute() {
    		value = "173";
    		return "redirect:/index.html?value=${value}";
    	}
    }
~~~~~

Invocation of action path: `/one.html` will perform the redirection to:
`/index.html?value=173`.


## Redirect Permanently ('url')

This result redirects permanently (301) to an external URL. For everything else
it works just like redirect result.


## Chain result ('chain')

Chaining actions is similar to forwarding, except it is done by `Madvoc`
and not by servlet container. Chain result handler takes result
value as the next action path. Chaining to the next action happens after
the complete execution of first action, including all interceptors
(but not filters!). The following example illustrates this:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public String chain() {
    		return "chain:/hello.link.html";
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

## Move result ('move')

Main problem with the redirection is the necessity of sending parameters
through the URL as GET parameters. This means that you have to write
the complete and properly formed URL string as result. Although there are some
helpers in *Jodd* for this, it is still not very maintainable and visual
solution.

Move result handler works similar as redirect one, except it stores
the current action in the session before the redirection. After the
redirection, *Madvoc* detects the stored (source) action and performs
the outjection of its data to request attributes. Like that, all data
from source action becomes visible (via servlet attributes) for the
target action! This frees from hard-coding the parameters in the url
string.

Not only that no parameter is passed in query, **move** result
implicitly support passing complex types with redirection!
{: .attn}

The best way to understand 'moving' is to compare it with the
'redirect'. The target action is a simple and has one input value
(property `value` annotated with `@In`):

~~~~~ java
	// Target action
    @MadvocAction
    public class TwoAction {

    	@In
    	String value;

    	@Action(alias = "two")
    	public void view() {
    		System.out.println(value);
    	}
    }
~~~~~

Now, the caller action. This example will show two versions of an
action: one that uses 'redirect' result, and the second that uses
'move' result:

~~~~~ java
	// Version #1: action that uses redirection to target
    @MadvocAction
    public class OneAction {

    	String value;

    	@Action
    	public String execute() {
    		value = "173";
    		return "redirect:/<two>?value=${value}";
    	}
    }
~~~~~

~~~~~ java
	// Version #2: action that uses moving to target
    @MadvocAction
    public class OneAction {

    	@Out
    	String value;

    	@Action
    	public String execute() {
    		value = "173";
    		return "move:/<two>";
    	}
    }
~~~~~

Both actions work exactly the same. The difference is obvious: second
example doesn't prepare url string and parameters, but just data.

As everything, this approach has one downside: there are no actual request
parameters available for target action! After moving to the requested
target page, stored action is immediately removed from the session.
Therefore, any further target page reload will not have any available
parameter. Also, if there is some part of code that explicitly depends
on request parameters it will not work if it is executed during
invocation of second, target action.

## No results ('none')

There are situations when data needs to be sent directly to the output
stream of HTTP response. In that case, action method is responsible for
sending the full response. Action also has to return `none:`, the
name of action result that will not perform any additional result processing,
since action is responsible for sending the result data back. This
result handler doesn't takes any result value and result value in
result string may be omitted.

## TextResult ('text')

Allows you to simply define text that has to be written back to the
output stream:

~~~~~ java
    @Action
    public String hello() {
        return "text:Jodd is awesome!";
    }
~~~~~

String is encoded using *Madvoc* encoding.

## RawResult

`RawResult` is a result that renders any subclass of
`RawResultData` returned from action method. This result does
not need result path for rendering; obviously we are using
here the `@RenderWith` annotation.

There are two types (but you can add more): `RawData` for returning
`byte[]` and `RawDownload` for returning `File`, `InputStream`
or `byte[]` as downloaded file.

Example:

~~~~~ java
    @Action
    public RawData image() {
        return new RawData(SMALLEST_GIF, MimeTypes.lookupMimeType("gif"));
    }
~~~~~

This is just one way of using it, mime types can be automatically detected
when download file name is specified and so on.
