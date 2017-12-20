# Actions (cont.)

Let's continue with some more action-related features.


## Custom action configuration.

For each action you can define a custom set of 'action configuration' - set of configuration and *Madvoc* components that defines the _behavior_ of an action. This set is simply stored in `ActionConfig` class. If you need a custom set, you would need to extend this class and change it (as for any other *Madvoc* component).

To apply the custom action configuration, use `@ActionConfiguredBy` on the action.


## Custom action method annotations

Now this is super cool - you may use your own annotations! Why? Because you can bind your own configuration to it.

For example, let's say that your `POST` actions must have the `.do` extension. In that case you could define something like:

~~~~~ java
    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD})
    public @interface MyPostAction {

    	String value() default "";

    	String extension() default "do";

    	String alias() default "";

    	String method() default "POST";

    }
~~~~~

Now, when an action method is annotated with this custom annotation:

~~~~~ java
    @MyPostAction
    public void someAction() {}
~~~~~

it will be equivalent to the:

~~~~~ java
    @Action(extension = "do", method = "POST")
    public void someAction() {}
~~~~~

Custom annotation reduces the amount of repeated code.

But this is not the best part yet - you can even specify custom action configuration for the custom annotation, too! By using the same annotation `@ActionConfiguredBy` you can change default behavior. For example, the `@RestAction` uses different behavior, as it has to return an JSON instead to render a view.

Custom annotations are registered in `MadvocConfig`, either in pure Java or in properties file.


## Asynchronous actions

*Madvoc* actions can become `asynchronous` (in Servlets 3.0 terms) by simply setting the annotation element `async` to `true`. That is all!


## Name replacements

It is possible to reference class and method names in name values of the
*Madvoc* annotations. For example, when specifying the full action path
it is possible to reference the default extension, allowing it to be no
more hard-coded in the action string:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action("/bonjour-monde.{:ext}")
    	public void world() {
    	}
    }
~~~~~

In this action path value, extension `{:ext}` will be replaced with
default *Madvoc* extension. The following replacements are available:

* `{:package}` - replaces default package name in package annotations;
* `{:class} `- replaces default class name in class annotations;
* `{:method}` - replaces default method name in method annotations;
* `{:ext}` - replaces default extension in `extension` and `value`
  elements of method annotations.
* `{:http-method}` - replaces default HTTP method in method annotations;


## Action naming strategies

One way to control the convention of building action paths is to use
action name strategy. Default naming strategy is already defined.
It uses action class and action method name to build action path.

Action naming strategy is a part of action configuration.
