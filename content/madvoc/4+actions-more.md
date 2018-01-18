# Actions (cont.)

Let's continue with some more action-related features.


## Custom action configuration

For each action you can define a custom set of 'action configuration' - set of configuration and *Madvoc* components that defines the _behavior_ of an action. This set is stored in `ActionConfig` class. If some of your actions require a custom configuration, you would need to extend this class and change it (as for any other *Madvoc* component). If all actions require different configuration, just set it in `MadvocConfig`.

To apply the custom action configuration on actions, use `@ActionConfiguredBy` on the action with your implementation of `ActionConfig`.


## Custom action method annotations

Now something super cool - you may use your own annotations! Why? Because you can bind your own configuration to it. And not repeat all over again.

For example, let's say that action method names must be always resolved as `process.do`, regardless the action method name. In that case you could define something like:

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

Custom annotations are registered in `MadvocConfig`, either in pure Java or in properties file.


## Asynchronous actions

*Madvoc* actions can become _asynchronous_ (in Servlets 3.0 terms) by simply annotating them as `@Async`. That is all!

What happens in the bcakground? When at least one async action handler is registered, *Madvoc* will create a worker thread pool. It's `AsyncActionExecutor` component, that you, again, can easily replace. Anyhow, when async action is called, *Madvoc* will take the request, start the async execution and execute the action using the worker thread pool.


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

We figured that is very important for users which naming convention is going to be used. Therefore *Madvoc* provides several ways how action names are defined. The final way on how action names are created is  to use _action name strategy_. The strategy is defined as an implementation of the `ActionNamingStrategy` interface.

Action naming strategy is a part of action configuration.