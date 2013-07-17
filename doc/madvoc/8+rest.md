# REST urls

*Madvoc* supports REST-alike URLs. Parts of mapped action path may
contain **macros** - text chunk surrounded with **$\{** and **}** signs.
Macros are used to resolve values from request action path. Values are
injected in the action object, similarly as request parameters and
attributes gets injected.

## Examples

Here is a simple action class

~~~~~ java
    @MadvocAction
    public class RestAction {

    	Long id;

    	@Action("/user/${id}")
    	public void viewUser() {
    	}
    }
~~~~~

It\'s quite obvious: above action method is registered to set of action
paths that starts with \'`/user/`\'. For example, if request action path
is \'`/user/173`\' *Madvoc* will match it to above action method. Second
part of the request will be recognized as macros value. This value will
be injected into the action object using the macro name, \'`id`\'.

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
\'`/user-*.jpg`\' to this action method. For example, request:
`/user-173.jpg` would be served by this method.

In all above examples, `@Action` define absolute action path. This is
not required, i.e. action path with macros is built as usual,
considering package, class and method annotations. However, only
`@Action` annotation may contain macros.

## Multiple macros

One action path may contain multiple macros - usually separated by at
least one character in between.

## Matching

*Madvoc* supports macros matching, too. By defining regular expression
or wildcard pattern (default), you can narrow down request paths that
invoke some action.

Matching is usually important for the root actions. For example, macro
`/${city}` will practically match **all** requests to one action (except
explicitly defined using e.g. annotations). This means, for example,
that even paths like `/favico.ico` or `/robots.txt` or even all `/*.png`
will be mapped to the same action - which is probably something you
didn't want. Therefore we have to filter out requests that we don't
need.

### Wildcard matching

By default, paths are matched using wildcards. Its simple and fast.

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

    	@Action("/user/${id:^[0-9]+}")
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

    	@Action("/${city:^[a-z]+}")
    	public void city() {
    	}
    }
~~~~~

Since in root, this macro will successfully filter out requests like
`/favico.ico` or all images, and this action will be invoked only for
cities.

### Custom matching

Of course, it is possible to create custom path macro definition - one
that may be more complex then this.

## Result path

Result path is build from the action path. When action path contains
RegExp pattern, resulting path may not be a valid file name (for
dispatching to, for example). For such situation we can use replacements
in the result, as in following example:

~~~~~ java

    	@Action("/user/${id:^[0-9]+}")
    	public String viewUser() {
    		return "#[method].ok";
    	}
~~~~~

Let's analyze the result value. First character is \'`#`\', that means
\'go back\', i.e. strip action method part from the end. Then we are
adding a replacement \'`[method]`\', that will be replaced with the real
method name. So, the result path of the above action method is:
\'`/user/viewUser.ok`\'.
