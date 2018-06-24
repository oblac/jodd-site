# Actions (cont.)

Let's continue with some more action-related features.

## Action Configurations

Each action in *Madvoc* is defined by it's action configuration, represented in `ActionConfig` class. Action configuration defines things like action interceptors, filters, the type of action result and, very important, a naming strategy.

There are several ways how you can set custom action configuration to an action. Maybe the easiest way is to use custom action annotation (explained next). Simply define new annotation, annotate it with `@ActionConfiguredBy` and use it instead of default `@Action` annotation.

Alternatively you can use `@ActionConfiguredBy` directly on a action method. Or you can forget all about annotations and configure everything using just fluent *Madvoc* api.


## Custom action method annotations

Now something super cool - you may use your own annotations! Why? Because you can bind your own configuration to it - and not repeat all over again. This is very convenient way to have action that are configured differently. Even *Madvoc* provides two annotations: `@Action` and `@RestAction`.

Custom annotation is created to contain _everything_ you would use on the annotation place. For example, let's say that action method names must be always resolved as `process.do`, regardless the action method name. In that case you could define something like:

~~~~~ java
    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD})
    public @interface ProcessAction {

    	String value() default "process.do";

    	String alias() default "";

    }
~~~~~

Now, when an action method is annotated with this custom annotation:

~~~~~ java
    @ProcessAction
    public void someMethod() {}
~~~~~

it would be equivalent to:

~~~~~ java
    @Action("process.do")
    public void someAction() {}
~~~~~

Custom annotation reduces the amount of repeated code.

But this is not the best part yet - you can even specify custom action configuration for the custom annotation, too! By using the same annotation `@ActionConfiguredBy` you can change default behavior. For example, the `@RestAction` uses different behavior, as it has to return an JSON instead to render a view.


## Asynchronous actions

*Madvoc* actions can become _asynchronous_ (in Servlets 3.0 terms) by simply annotating them as `@Async`. That is all!

What happens in the bcakground? When at least one async action handler is registered, *Madvoc* will create a worker thread pool (in `AsyncActionExecutor` component). When async action is called, *Madvoc* will take the request, start the async execution and execute the action using the worker thread pool.


## Name replacements

It is possible to reference class and method names in `@Action` annotations. For example, when specifying the full action path, it is possible to reference the default method name, prevent it to be hardcoded:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action("/bonjour-{:name}.html")
    	public void monde() {
    	}
    }
~~~~~

Such action would be mapped to: `/bonjour-monde.html`. The following replacements are available:

* `{:package}` - replaces default package name;
* `{:class} `- replaces default class name;
* `{:name}` - replaces default method name;
* `{:method}` - replaces default HTTP method;


## Action naming strategies

We figured that is very important for users which naming convention is going to be used. Therefore *Madvoc* provides several ways how action names are defined. The final way how action names are created is by some _action name strategy_. The strategy is defined as an implementation of the `ActionNamingStrategy` interface.

Naming strategy is part of the action configuration (explained above).