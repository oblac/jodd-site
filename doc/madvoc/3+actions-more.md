# Actions (cont.)

This page describes some more action-related features.

## Custom action method annotations

It's very common that most of your action methods will be annotated
with two-three sets of element values for `@Action` annotation. For
example, most of view actions paths may be mapped to **GET** requests,
all forms may be mapped to **\*.do** and **POST** requests, all json
actions may be mapped to **\*.json** requests. So every time when you
need to annotated a method, you will have to repeat the most of
annotation elements, over and over again.

Fortunately, *Madvoc* is clever;) It allows you to define custom
annotations with different default values. Since we can not extend
annotations, custom action annotation must contains the same elements as
the default one (`@Action`) - and even not all, but just the modified
ones.

Let's create custom annotation for all forms, that will have extension
"**.do**"" and mapped to **POST** method:

~~~~~ java
    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD})
    public @interface PostAction {

    	String value() default "";

    	String extension() default "do";

    	String alias() default "";

    	String method() default "POST";

    }
~~~~~

As said above, it is not necessary to repeat definition for `alias`
element. Now, when an action method is annotated with this custom
annotation:

~~~~~ java
    @PostAction
    public void someAction() {}
~~~~~

it will be equivalent to the:

~~~~~ java
    @Action(extension = "do", method = "POST")
    public void someAction() {}
~~~~~

It is obvious that custom annotation reduces the amount of repeated
code.

Finally, custom annotations are registered in `MadvocConfig`, either in
pure Java or in properties file.

## Name replacements

It is possible to reference class and method names in name values of the
*Madvoc* annotations. For example, when specifying the full action path
it is possible to reference the default extension, allowing it to be no
more hard-coded in the action string:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action("/bonjour-monde.${:ext}")
    	public void world() {
    	}
    }
~~~~~

In this action path value, extension `[ext]` will be replaced with
default *Madvoc* extension. The following replacements are available:

* `${:package}` - replaces default package name in package annotations;
* `${:class} `- replaces default class name in class annotations;
* `${:method}` - replaces default method name in method annotations;
* `${:ext}` - replaces default extension in `extension` and `value`
  elements of method annotations.
* `${:http-method}` - replaces default HTTP method in method annotatins;

## Action naming strategies

One way to control convention of building action paths is to use
action name strategy. Default naming strategy is already defined.
It uses action class and action method name to build action path.

You can use annotation's element `path` to define action naming
strategy class that gonna be used for building action path.
This is so cool, as you can easily make any convention you like!

For now, there is just one more naming strategy: `RestResourcePath`.
This one will be explained in more details on one of the following
pages dedicated to REST.

<js>docnav('madvoc')</js>