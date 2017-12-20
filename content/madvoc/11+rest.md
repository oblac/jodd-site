# REST

*Madvoc* supports REST URLs. Parts of mapped action path may
contain **macros** - text chunk surrounded with **{** and **}** signs.
Macros are used to resolve values from the request action path. Values are
injected in the action object, similarly as request parameters and
attributes gets injected.

Macros are always resolved in *Madvoc*.

*Madvoc* provides `@RestAction` to specify the REST actions. This annotation defines no extension and specifies custom action configuration, i.e. custom behavior of action mapping and results rendering.


## Macro Examples

Here is a simple action class:

~~~~~ java
    @MadvocAction
    public class RestAction {

    	Long id;

    	@Action("/user/{id}")
    	public void get() {
    	}
    }
~~~~~

It's quite obvious: the action method is registered to the set of action
paths that starts with `/user/`. For example, if request action path
is `/user/173` *Madvoc* will match it to above action method. Second
part of the request will be recognized as macros value. This value will
be injected into the action object using the macro name, `id`.

~~~~~ java
    @MadvocAction
    public class RestAction {

    	Long id;

    	@Action("/user-${id}.jpg")
    	public void viewUserImage() {
    	}
    }
~~~~~

In this example, *Madvoc* will match whole set of request action paths:
`/user-*.jpg` to this action method. For example, request:
`/user-173.jpg` would be served by this method.

One action path may contain multiple macros - usually separated by at
least one character in between.

## Matching

*Madvoc* supports macros matching, too. By defining regular expression
or wildcard pattern (default), you can narrow down request paths that
invoke some action.

Matching is usually important for the root actions. For example, macro
`/{city}` will practically match **all** requests to one action (except
explicitly defined using e.g. annotations). This means, for example,
that even paths like `/favico.ico` or `/robots.txt` or even all `/*.png`
will be mapped to the same action - which is probably something you
didn't want. Therefore we have to filter out requests that we don't
need.

### Wildcard matching

By default, paths are matched using wildcards. It's simple and fast.

### RegExp matching

For advanced use cases, user may turn on regular expression.

In above examples there are no checking if the macro value is a number -
so, even invalid action paths (e.g. `/user/huh`) will be invoked by
mapped action methods.

*Madvoc* provides regular expression matching of the macro values.
RegExp pattern can be defined after the macro name, as in the following
example:

~~~~~ java
    @MadvocAction
    public class RestAction {

    	Long id;

    	@Action("/user/{id:^[0-9]+}")
    	public void viewUser() {
    	}
    }
~~~~~

This action method is mapped on all request action paths that starts
with `/user/` and have a number appended as a macro value. Invalid urls
will be simply ignored and error 404 will be raised.

Here is another result how to filter out all paths that does not contain
just letters:

~~~~~ java
    @MadvocAction
    public class RestAction {

    	String city

    	@Action("/{city:^[a-z]+}")
    	public void city() {
    	}
    }
~~~~~

Since in root, this macro will successfully filter out requests like
`/favico.ico` or all images, and this action will be invoked only for
cities.

### Custom matching

Of course, it is possible to create custom path macro definition - one
that may be more complex then regular expression, or more specific
to your needs. See the code for how :)

## Result path

Result path is build from the action path. When action path contains
RegExp pattern, resulting path may not be a valid file name (for
dispatching to, for example). For such situation we can use replacements
in the result, as in following example:

~~~~~ java

    	@Action("/user/{id:^[0-9]+}")
    	public String viewUser() {
    		return "#{:method}.ok";
    	}
~~~~~

Let's analyze the result value. First character is `#`, that means
'go back', i.e. strip action method part from the end. Then we are
adding a replacement `{:method}`, that will be replaced with the real
method name. So, the result path of the above action method is:
`/user/viewUser.ok`.

## REST annotation naming convention

But there are even more REST in *Madvoc*: REST naming convention.
It is just a different convention how action paths are built. Here
is an example:

~~~~~ java
    @MadvocAction
    public class UserAction {

        @InOut
        String id;

        @RestAction("${id}")
        public User get() {
            return someUser;
        }

        @RestAction("${id}")
        public String post() {
        }
    }
~~~~~

With REST naming convention active (by `@RestAction`) the method `get()` is
going to be mapped to url: `/user/${id}`, but only for `GET` requests.
`POST` requests get mapped to method `post()` and so on. In this approach
one action represents one REST _resource_.

This is common approach for REST APIs. Still, you are able to build your
own naming convention if you like.

