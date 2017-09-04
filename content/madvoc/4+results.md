# Results

**Action Result** is handler returning value (also known as **result object**)
of an action method. Result object can be of any type and for any purpose;
and *Madvoc* uses action results to _render_ the response. Results handlers
are defined as implementations of `ActionResult`.

*Madvoc* offers many ways how to specify action result handler! You will be
surprised:

+ return object annotated with `@RenderWith` annotation;
+ return `String` with result name as a prefix;
+ use `Result` helper object in your action method (and ignore the returns);
+ simply return an object that has registered handler matched by its type;
+ use `result` element of `@Action` annotation.

So many choices! Let's see each of these in action.

## @RenderWith

This is the simplest and most basic way how to deal with the results.
Actions result object annotated with `@RenderWith` defines `ActionResult`
class that is going to be used for rendering the result.
This `ActionResult` class is also registered on first use,
so you don't need to specially register them on initialization
(although that would not make any difference).

Example is quite simple:

~~~~~ java
    @Action
    public RawDownload hello() {
        return new RawDownload(new File(..), mimeType);
    }
~~~~~

Few *Madvoc* results are defined like this (`RawResult` etc).
While this is a basic way dealing with the results, it's works
only for types we have control on. You can not
use this approach when you e.g. return a `String`; you
would need to wrap it in your class that can be annotated.
In most cases in web application, we actually need to return strings
for various paths (redirect, forward...), so wrapping them
(although possible) is not so user-friendly. Moreover, adding
view-related annotation to your domain classes may not be acceptable.
Fortunately, with *Madvoc* you have more alternatives.

## Result name, value and path

Common action return value is `String` that defines where action
should forward or redirect to - defines the _result path_. Actions
that return `String` (or `toString()` of non-annotated object!)
are treated in a special way. Returned result string consist of the
result _name_ and result value:

~~~~~
result string = <result_name>:<result_value>
~~~~~

* `result_name` - optional unique result name identification;
* `result_value` - result value, used for building result path.

Result name defines which `ActionResult` instance will be used to
render the result. When result name is missing, the default one
is used (defined in global *Madvoc* configuration). Result value
is used to build the **result path**. Result path is then usually
used to build a path that will be used for forwarding, redirecting etc.

### Result path

_Result path_ is a path created from action path and
result value, in the following way:

~~~~~
    result path = <action_path>.<result_value>
~~~~~

This value can be used by `ActionResult` to perform rendering.
Although result path can be represented as a one string, it is actually
a join (or tuple) of two strings: action path and result value,
both strings are stored separately.
This is important as some `ActionResult` may combine different variants
of action path with same result value, or to resolve aliases just in
result value etc.

Example:

~~~~~ java
    public class FooAction {
        @Action
        public String hello() {
            return "ok";
        }
    }
~~~~~

In above example, the action path for `hello()` method (if using defaults)
is: `/foo.hello.html`. Result name is not specified. Returned value is `ok`.
So the result path is: `/foo.hello.html.ok`.

Actions may also return `void` to trigger the default result
type handler with empty value. Returning `null` has the same
effect.

### Full result path

When result value starts with the '**/**' sign, *Madvoc* will take it
as a full result path. In that case result path is equal to result
value and action path is ignored.

## Action Result associated to a type

Action result handler may be associated to a type. For example, your action
may return a `Book` that is going to be rendered using `BookActionResult<Book>`.
Such action result has to be registered on *Madvoc* startup.

## Action result from `@Action` annotation

Action result can be specified in the `@Action` annotation.

~~~~~ java
    public class BookAction {
        @Action(result = BookActionResult.class)
        public Book view() {
            return new Book();
        }
    }
~~~~~

Above action is going to be rendered by a `BookActionResult`. Good thing here is
that you may use the same action result for different types. You can render
books, comics, novel etc with the very same action result.

Another thing to remember - *Madvoc* allows usage of _custom_ annotations. You
may create predefined annotations so not to repeat same elements values all
over your code.

## Result object

As said above, most *Madvoc* actions in web app return strings to define paths
where to forward (or move, chain, see later). Common thing is also to
jump to the result of other action: for example, one action may deal with
some form post and then to redirect to a view action.

While *Madvoc* gives you a way to manipulate result path with returned result
value (by using special chars, see next page), you are still hardcoding names
in strings. If target action name is changed, your compiler would not
see the change and the wrong value would stay in the string.

`Result` object is cool, little tool that can significantly help you
with specifying result paths. All you have to do is to put a field
of type `Result` (or any your subclass!) and use it in your actions:

~~~~ java
    @MadvocAction
    public class MyAction {

        Result result = new Result();

        @Action
        public void hello() {
            result.forwardTo("ok");     // == return "ok"
        }

        @Action
        public void save() {
            result.redirectTo(this).hello();
        }
    }
~~~~~

Since action objects are created on each request, you are safe to use
result object between the actions. In the first action we just
define result value `ok`. However, pay attention to the second action.
It uses `this` instance (or any other action class) and allows you to
actually define target method by invoking it! Of course, the real
method is not being called; you are playing here with proxified
instances. Underneath we are using [*Methref*](/util/methref.html)
super-tool for this, so your project must include <var>jodd-proxetta</var>
optional dependency.

## Order

With all this ways of specifying Action result, there must be the order. Here
is the ordered list of how Action result is resolved:

1. First check if the `Result` helper object is used.
2. Then check the `@Action` annotation.
3. Check if returned value is annotated with `@RenderWith`.
4. Find action result by returned value type.
5. Finally, perform `toString()` on returned value and find action result by name.

## Madvoc Action results

Here goes the list of all *Madvoc* Action results. Some of them
are registered for names, some are meant to be used differently.

### Dispatcher result ('dispatch')

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

### Redirect result ('redirect')

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

### Redirect Permanently ('url')

This result redirects permanently (301) to an external URL. For everything else
it works just like redirect result.

### Chain result ('chain')

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

### Move result ('move')

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

### No results ('none')

There are situations when data needs to be sent directly to the output
stream of HTTP response. In that case, action method is responsible for
sending the full response. Action also has to return `none:`, the
name of action result that will not perform any additional result processing,
since action is responsible for sending the result data back. This
result handler doesn't takes any result value and result value in
result string may be omitted.

### TextResult ('text')

Allows you to simply define text that has to be written back to the
output stream:

~~~~~ java
    @Action
    public String hello() {
        return "text:Jodd is awesome!";
    }
~~~~~

String is encoded using *Madvoc* encoding.

### RawResult

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
