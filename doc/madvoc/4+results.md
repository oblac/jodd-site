# Results

<div class="doc1"><js>doc1('madvoc',20)</js></div>
**Action Result** is returning value (also known as **result object**)
of an action method. Result object provides **result string**; that is
it's `toString()` value. Result string is formed in the following way:

`result string = <result_type>:<result_value>`

* `result_type` - optional result type id;
* `result_value` - result value, used for building result path.

Result type defines which **result type handler** will process the
result. When result type is omitted, the default one is used (defined in
global *Madvoc* configuration).

Result value is used to build the **result path**. Result path is formed
in the following way:

`result path = <action_path_no_ext>.<result_value>`

* `action_path_no_ext` - action path with *stripped* extension;
* `result_value` - part of `toString()` result value.


Result type handler may use single value or any combination of these
values to process the action result: result object, result value and/or
result path. This makes *Madvoc* very flexible in processing the
results.

Actions may return result object of **any type**, not only `String`.
{: .attn}

Actions may also return `void`, what will trigger the default result
type handler with empty result value. Returning `null` has the same
effect.

## Full result path

When result value starts with the \'**/**\' sign, *Madvoc* will take it
as a full result path. In that case result path is equal to result
value.

## Dispatcher result (\'dispatch\')

Servlet dispatching is the default result type. This result type handler
appends \'jsp\' extension to result path to build the page name.

If this page is not found, dispatcher result type handler will start
removing one word from the result path starting from the end (that is
not including the extension), until the page is found.

The hello world example:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	public String world() {
    		return "ok";
    	}
    }
~~~~~

This action is mapped to action path: `/hello.world.html`. Now, the
results: since there is no explicit result type id, \'dispatch\' is
assumed. Result value is \'ok\', so *Madvoc* will try to dispatch to
following pages, in given order:

* /`hello.world.ok.jsp`
* ` /hello.world.jsp`
* ` /hello.jsp `

Dispatcher result type handler will dispatch to the first founded page
of above. If no pages is found, error 404 occurs.

Dispatcher detects if founded page is included, so finally it performs
either `include` or straight `forward` to the target page.

## Redirect result (\'redirect\')

Servlet redirection is simple: result value specifies the redirection
URL. Usually, result value specifies full result path (starts with
\'**/**\'):

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
of which, *Jodd* provides nice utility for building url\'s and encoding
parameters: `UrlEncoder`.

Moreover, it is possible to inject action properties into the resulting
url:

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

## Url Redirect (\'url\')

This result redirects to an external url.

## Chain result (\'chain\')

Chaining actions is similar to forwarding, except it is done by `Madvoc`
and not by servlet container. Chain result type handler takes result
value as the next action path. Chaining to the next action happens after
the complete execution of first action, including all interceptors. The
following example illustrates this result type:

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

## Move result (\'move\')

Main problem with the redirection is the necessity of sending parameters
through the URL as GET parameters. This means that it is needed to write
the complete and properly formed url string. Although there are some
helpers in *Jodd* for this, it is still not very maintainable and visual
solution.

Move result type handler works similar as redirect one, except it stores
the current action in the session before the redirection. After the
redirection, *Madvoc* detects the stored (source) action and performs
the outjection of its data to request attributes. Like that, all data
from source action becomes visible (via servlet attributes) for the
target action! This frees from hard-coding the parameters in the url
string.

Not only that no parameter is passed in query, **move** result
implicitly support passing complex types with redirection!
{: .example}

The best way to understand \'moving\' is to compare it with the
\'redirect\'. The target action is a simple and has one input value
(property \'`value`\' annotated with `@In`):

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
action: one that uses \'redirect\' result, and the second that uses
\'move\' result:

~~~~~ java
	// Version #1: action that uses redirection to target
    @MadvocAction
    public class OneAction {

    	String value;

    	@Action
    	public String execute() {
    		value = "173";
    		return "redirect:/%two%?value=${value}";
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
    		return "move:/%two%";
    	}
    }
~~~~~

Both actions work exactly the same. The difference is obvious: second
example doesn't prepare url string and parameters, but just data.

As everything, this approach has its cons: there are no actual request
parameters available for target action! After moving to the requested
target page, stored action is immediately removed from the session.
Therefore, any further target page reload will not have any available
parameter. Also, if there is some part of code that explicitly depends
on request parameters it will not work if it is executed during
invocation of second, target action.

## No results (\'none\')

There are situations when data needs to be sent directly to the output
stream of HTTP response. In that case, action method is responsible for
sending the full response. Action also has to return \'`none:`\', the
result type that will not perform any additional result processing,
since action is responsible for sending the result data back. This
result type handler doesn't takes any result value and result value in
result string may be omitted.

## Using result objects

When working with direct responses, action needs direct access to the
http request and response. Although they can be easily injected in
action class instance, such class becomes \'hard-wired\' with servlets
interfaces: it can't be initialized easily outside the container,
therefore it is less testable, and so on...

The purpose of result type handlers is to divide this process into two
parts: preparing of data (in action class, by action method) and actual
data transfer (in result type handler), leaving the action class
\'clean\' of HTTP servlets.

Sending some raw results (image, file download...) is common example.
Although raw content can be sent directly to the output using \'none\'
result type handler, it is not considered as a good practice. Action
instead can just prepare the resulting byte array (raw data) that will
be transferred back to the client by (custom) result type handler.

Now, *Madvoc* offers two approaches how to achieve this. The first one
is quite obvious: action method may prepare byte array (or whatever the
result is) and store it somewhere in its object. Action then returns
result value that indicates somehow what field(s) contain prepared
result data, so result type handler may use it for transferring back to
the client. Something like an example of custom result type and raw access:

~~~~~ java
    @MadvocAction
    public class RawAction {

    	byte[] bytes;

    	@Action
    	public RawResultData view() {
    		bytes = ...		// create byte array somehow
    		return "foo:bytes";
    	}
    }
~~~~~

Here some result type handler (\'foo\' in this example) may process the
action object using reflection and reads all fields marked as holders of
returned data (\'bytes\' in this example) and then transfer this data
back. Of course, this is just one scenario; many variations are
available, such as using annotations instead of result value etc.

*Madvoc* offers one more convenient solution. Instead of returning a
string, action may return result object of any type! It is on result
type handler to process result value, result path and/or result object
how it likes. Until now, all result type handlers just used the result
value (`toString()` of result object) or result path. But result type
handler may go further and consider whole result object to prepare the
result. The best way to understand this is to refactor the previous
example using this approach.

Instead of storing byte array in the field of the action class, byte
array can be wrapped into some custom data holder that will be returned
from the action as result object. This data holder must have
`toString()` overridden so *Madvoc* will invoke corresponding result
type handler that knows how to deal with this data holder. Simple as
this:

~~~~~ java
    @MadvocAction
    public class RawAction {

    	@Action
    	public RawResultData view() {
    		byte[] bytes = ... 	// create byte array somehow
    		return new RawResultData(bytes);
    	}
    }
~~~~~

## RawResultData (\'raw\')

`RawResultData` is just a simple wrapper for byte arrays that has to be
sent back to the client. It works together with \'raw\' type handler,
that recognizes and works with this type. `RawResultData` has overrided
`toString()` method and returns just \'raw:\'. All what action method
has to do is to prepare byte array and return it as `RawResultData`.

Returning just string \'raw:...\' will send result value string back to
the client. This is especially useful for non-html text responses, like
from JSON.

## Result path cheat-sheet

Following table summarize default behavior of `ResultMapper` - *Madvoc*
component dedicated for building result paths from results and action
path.

| action path (no extension) | result value    | result path             |
|----------------------------|-----------------|-------------------------|
| *                          | /foo            | /foo                    |
| *                          | /foo.ext        | /foo.ext                |
| /zoo/boo.foo               | ok              | /zoo/boo.foo.ok         |
| /zoo/boo.foo               | doo.ok          | /zoo/boo.foo.doo.ok     |
| /zoo/boo.foo               | #               | /zoo/boo                |
| /zoo/boo.foo               | #ok             | /zoo/boo.ok             |
| /zoo/boo.foo               | #doo.ok         | /zoo/boo.doo.ok         |
| /zoo/boo.foo               | (void) or (null)| /zoo/boo.foo            |
| /zoo/boo.foo               | ##ok            | /zoo/ok                 |

Following table summarize default behavior of `ResultMapper` when action
path extension should not be stripped from the result path (see next
page).

| action path with extension | result value    | result path             |
|----------------------------|-----------------|-------------------------|
| /zoo/boo.foo.ext           | ok              | /zoo/boo.foo.ok         |
| /zoo/boo.foo.ext           | .ok             | /zoo/boo.foo.ext.ok     |
| /zoo/boo.foo.ext           | .               | /zoo/boo.foo.ext        |
| /zoo/boo.foo               | ok              | /zoo/boo.ok             |
| /zoo/boo.foo               | .ok             | /zoo/boo.foo.ok         |
| /zoo/boo.foo               | .               | /zoo/boo.foo            |
| /zoo/boo                   | ok              | /zoo/boo.ok             |
| /zoo/boo                   | .ok             | /zoo/boo.ok             |

