# Results

**Action Result** is a handler that process (i.e. renders) a value of an action method (also known as **result object**). The result object can be of any type and for any purpose; *Madvoc* uses action results to _render_ the response. Results handlers are defined as implementations of `ActionResult`.

*Madvoc* offers many ways how to specify action result handler! You will be
surprised:

+ action returns an object annotated with `@RenderWith` annotation;
+ action returns a `String` with result name as a prefix;
+ actions returns a `Result` helper object;
+ action returns an object that has registered handler matched by its type;
+ action specify the result in the action configuration.

So many choices! Let's see each of these in action.


## @RenderWith

Actions result object annotated with `@RenderWith` defines `ActionResult`
class that is going to be used for rendering the result.
This `ActionResult` class is also registered on the first use.

The example is quite simple:

~~~~~ java
    @Action
    public RawDownload hello() {
        return new RawDownload(new File(..), mimeType);
    }
    ...
    @RenderWith(RawResult.class)
    public class RawDownload {...
    }
~~~~~


## Result name, value and path

Common action's return value is a `String` that defines where action
should forward or redirect to - it defines the _result path_. Actions
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

_Result path_ is a path created from action path and result value, in the following way:

~~~~~
    result path = <action_path>.<result_value>
~~~~~

This value can be used by `ActionResult` to perform the rendering.
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

Actions may also return `void` to trigger the default result type handler with empty value. Returning `null` has the same effect.

### Full result path

When result value starts with the '**/**' sign, *Madvoc* will take it
as a full result path. In that case result path is equal to result
value and action path is ignored.

## Action Result associated to a type

Action result handler may be associated to a type. For example, your action
may return a `Book` that is going to be rendered using `BookActionResult<Book>`.
Such action result has to be registered on *Madvoc* startup.


## Action result from Action configuration

Action result can be specified by the Action configuration (that is binded to an annotation).

~~~~~ java
    public class BookAction {
        @BookAction
        public Book view() {
            return new Book();
        }
    }
~~~~~

Here the `@BookAction` is configured to use the `BookActionResult` for rendering a book.
Good thing here is that you may use the same action result for different types. You can render
books, comics, novel etc with the very same action result.

## Result tool

As said above, most *Madvoc* actions in web app return strings to define paths
where to forward (or move, chain, see later). Common thing is also to
jump to the result of other action: for example, one action may deal with
some form post and then to redirect to a view action.

While *Madvoc* gives you a way to manipulate result path with returned result
value (by using special chars, see next page), you are still hardcoding names
in strings. If target action name is changed, your compiler would not
see the change and the wrong value would stay in the string.

`Result` is a great little tool that can significantly help when specifying the result:

~~~~ java
    @MadvocAction
    public class MyAction {

        @Action
        public Result hello() {
            return Result.forward().to("ok");
        }

        @Action
        public void save() {
            return Result.redirect().to(this, MyAction::hello);
        }
    }
~~~~~

In the first action we just define result value `ok`. However, pay attention to the second action.
It uses `this` instance (or any other action class) and allows you to
actually define target method by virtually invoking it! Of course, the real
method is not being called; you are playing here with proxified
instances. Underneath we are using [*Methref*](/util/methref.html)
super-tool for this.

## The Order

With all this ways of specifying Action result, there must be the order. Here
is the ordered list of how Action result is resolved:

1. First check if the `Result` helper object is used.
2. Then check the `@Action` annotation.
3. Check if returned value is annotated with `@RenderWith`.
4. Find action result by returned value type.
5. Finally, perform `toString()` on returned value and find action result by name.

