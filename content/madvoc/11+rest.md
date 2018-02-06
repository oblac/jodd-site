# REST

*Madvoc* supports REST APIs as well! Common thing with mapping REST endpoints is to specify _macros_: parts of request path that represents an ID - or input parameter, in general. Of course, you can use macros on any request, not only for the REST apis.

To simplify building the REST apis, *Madvoc* provides `@RestAction` annotation that does two things differently:

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

    	@Action("/user-{id}.jpg")
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

Path macros extracting is core feature of *Madvoc* and supported for `@Action` and `@RestAction` (i.e. you don't have to use REST api to have them).
{: .attn}

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

Path macros are always available in *Madvoc* - not only for the REST apis.
Let's look an example of some REST endpoints:

~~~~~ java
    @MadvocAction
    public class UserAction {

        @In @Out
        String id;

        @RestAction("{id}") @GET
        public User findUser() {
            return someUser;
        }

        @RestAction("{id}")
        public String post(
            @In @Scope(BODY) User user) {
                ...
        }
    }
~~~~~

`@RestAction` comes with custom name convention. First, you can use method names to specify the HTTP method - if a method name starts with it. In above example, the second method `post()` will be invoked only for `POST` requests. Of course, you can still use the specific annotations for that, like we do for the `findUser()` method.

## Path macros as method arguments

A common way for using REST endpoints is to have parameters injected as method arguments. Simply annotate method arguments with `@In` annotation and that is all. Here is an example:

~~~~~ java
    @MadvocAction
    public class TodoAction {
        @GET @RestAction("/{id:[0-9]+}")
        public JsonResult item(@In int id) {
            TodoEntry todoEntry = todoDb.get().find(id);
            if (todoEntry == null) {
                return JsonResult.of(error404().notFound());
            }
            return JsonResult.of(todoEntry);
        }

        @PATCH @RestAction("/{id}")
        public TodoEntry update(@In int id, @In @Scope(BODY) TodoEntry todoEntryPatch) {
            return todoDb.get().patch(id, todoEntryPatch);
        }
    }
~~~~~

The first method, `item()` takes a `id` from the path and injects it as method argument. The method returns `JsonResult` - a generic result, that can specify status codes and so on.

The seconf method, `update()` has two arguments. The first one comes from the path (`id`), but the second one comes from the request body - and not only that, the body is parsed as JSON into the target type, `TodoEntry`. Convenient, right? Note also the return type - it is a `TodoEntry`, that is serialized back to JSON.