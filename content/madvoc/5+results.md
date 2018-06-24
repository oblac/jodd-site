# Results

**Action Result** is a handler that process (i.e. renders) a return value of an action method (also known as **result object**). The result object can be of any type and for any purpose; *Madvoc* uses action results to _render_ the response. Results handlers are defined as implementations of `ActionResult`.

*Madvoc* offers many ways how to specify action result handler:

+ action returns an object annotated with `@RenderWith` annotation;
+ action has a `@RenderWith` annotation;
+ action returns implementation of `PathResult`;
+ action specify the result in the action configuration (and annotation).

So many choices! Let's see each of these in action.


## @RenderWith

Actions result object annotated with `@RenderWith` defines `ActionResult` class that is going to be used for rendering the result. This `ActionResult` class is registered in the *Madvoc* on the first use.

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

Alternately, action can be annotated as well:

~~~~~ java
    @Action
    @RenderWith(RawResult.class)
    public RawDownload hello() {
        return new RawDownload(new File(..), mimeType);
    }
    ...
    public class RawDownload {...
    }
~~~~~

Those two has the same effect.

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

And:

~~~~~ java
    @ActionConfiguredBy(BookActionConfig.class)
    public @interface BookAction {...}
~~~~~

Finally:

~~~~~ java
    public class BookActionConfig extends ActionConfig {

        public BookActionConfig(final ActionConfig parentActionConfig) {
            super(parentActionConfig);
            setActionResult(BookActionResult.class);
        }
    }
~~~~~


Here the `@BookAction` is configured to use the `BookActionResult` for rendering a book. Good thing here is that you may use the same action result for different types. You can render books, comics, novel etc with the very same action result.

## PathResult

*Madvoc* provides several classes that uses human-readable fluent API to specify the common results.

~~~~ java
    @MadvocAction
    public class MyAction {

        @Action
        public Forward hello() {
            return Forward.to("ok");
        }

        @Action
        public Redirect save() {
            return Redirect.to(this, MyAction::hello);
        }
    }
~~~~~

In the first action we just define result value `ok`. This value is used by the "redirect" result type (as you will see on the next page).

Pay attention to the second action. It uses `this` reference (or any other action class) and allows you to actually define the target method by virtually invoking it! Of course, the real method is not being called; you are playing here with proxified instances. Underneath we are using [*Methref*](/util/methref.html) super-tool for this.
