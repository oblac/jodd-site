# REST

*Madvoc* supports REST APIs as well! Common thing with mapping REST endpoints is to specify _macros_: parts of request path that represents an ID - or input parameter, in general. Of course, you can use macros on any request, not only for the REST apis.

To simplify building the REST apis, *Madvoc* provides `@RestAction` annotation that does two things:

1. it changes the naming strategy for REST apis, and
2. renders the result object as JSON.

## Path Macros

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

### RegExp matching

By default, *Madvoc* uses regular expression when mapping paths. RegExp pattern can be defined after the macro name, as in the following
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

Here is another result how to filter out all paths that does not contain just letters:

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

## Wildcard matching

Alternatively, paths may be matched using wildcards. It's simple and fast.

### Custom matching

Of course, it is possible to create custom path macro definition - one
that may be more complex then regular expression, or more specific
to your needs.

## REST annotation

Example of an REST endpoints:

~~~~~ java
    @MadvocAction
    public class UserAction {

        @InOut
        String id;

        @RestAction("${id}") @GET
        public User findUser() {
            return someUser;
        }

        @RestAction("${id}")
        public String post(
            @In @Scope(BODY) User user) {
                ...
        }
    }
~~~~~

`@RestAction` comes with custom name convention. First, you can use method names to specify the HTTP method - if a method name starts with it. In above example, the second method `post()` will be invoked only for `POST` requests. Of course, you can still use the specific annotations for that.