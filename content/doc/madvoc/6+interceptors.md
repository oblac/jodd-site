# Interceptors

**Action interceptor** executes some code _before_ and _after_ an action
method is invoked. Interceptors encapsulates common concerns of actions.
One action method may be intercepted by many interceptors. Some core
*Madvoc* functionality is implemented using interceptors.

Besides the fact that interceptors are easy to configure and are very
pluggable; they can be logically grouped in **interceptor stacks**, for
more convenient configuration. Interceptor stack is just an simple array
of interceptor references.

Interceptors have unique instances (singletons) within single *Madvoc*
web application. In the code, interceptors are referenced with their
class references.

## Intercepting an action

To define an action interceptor, action method must be marked with
`@InterceptedBy` annotation. This annotation has only one element: an
array of interceptor class references that are intercepting the action:

~~~~~ java
    @MadvocAction
    public class HelloAction {

    	@Action
    	@InterceptedBy(EchoInterceptor.class)
    	public String world() {
    		return "ok";
    	}
    }
~~~~~

This action is intercepted by single interceptor: `EchoInterceptor`.

It is also possible to put `@InterceptedBy` annotation on action class,
to set interceptors for all action methods that are not explicitly
intercepted, i.e. that have no interceptor annotation. The previous
example may be alternatively written in the following way:

~~~~~ java
    @MadvocAction
    @InterceptedBy(EchoInterceptor.class)
    public class HelloAction {

    	@Action
    	public String world() {
    		return "ok";
    	}
    }
~~~~~

This is convenient when there are more then one action method in action
class.

Action method interceptors override action class interceptors.
{: .attn}

## Interceptors stack

As said, `@InterceptedBy` annotation takes an array of interceptor class
references. For example, this action is intercepted by three
interceptors:

~~~~~ java
	@Action
	@InterceptedBy({Interceptor1.class, Interceptor2.class, Interceptor3.class})
	public void view() {
	}
~~~~~

Interceptors are executed in given order.
{: .attn}

Real-world application may have more than one interceptor, and
constantly repeating the interceptor class references for each action
class/method is not a good idea. *Madvoc* allows to group several
interceptors into interceptor stacks. Not only that this reduces the
amount of written code (and makes things more robust and more
error-prone), but it also gives a possibility to group logically
interceptors, depending on their functionality.

Interceptor stack is simply a sublass of `ActionInterceptorStack` (which
is in the end also `ActionInterceptor`) that defines an array of
interceptors that belongs to the stack:

~~~~~ java
    public class MyInterceptorStack extends ActionInterceptorStack {

    	public MyInterceptorStack() {
    		super(Interceptor1.class, Interceptor2.class, Interceptor3.class);
    	}
    }
~~~~~

Now the previous action may be written as:

~~~~~ java
	@Action
	@InterceptedBy(MyInterceptorStack.class)
	public void view() {
	}
~~~~~

Interceptor stack may refer other interceptor stacks.

### Configurable interceptor stack

Sometimes you need to be able to configure your interceptor stack from
the outside, i.e. from `madvoc.props` file. In this case, just extend
the `ActionInterceptorStack` using empty constructor, and list
interceptor classes in `madvoc.props`.

## Default interceptors stack

Usually, most actions in web application will be intercepted by same
interceptor stack. Therefore, *Madvoc* defines default interceptors
stack: all actions that are not explicitly intercepted (i.e. have no
`@InterceptedBy` neither on action method or action class) are
intercepted by the default interceptor stack. In other words: if action
method is not annotated with interceptor annotation, it is implicitly
intercepted by default interceptor stack.

Default interceptor stack is defined in the global *Madvoc*
configuration:

~~~~~ java
    public class MyMadvocConfig extends MadvocConfig {

    	public MyMadvocConfig() {
    		defaultInterceptors = new Class[] {EchoInterceptor.class, MyInterceptorStack.class};
    	}
    }
~~~~~

In this example, default interceptor stack consist of 4 interceptors:
`EchoInterceptor` and three from `MyInterceptorStack`.

It is also possible to reference default interceptor stack using
`DefaultWebAppInterceptors`. This is the dummy interceptor that simply
replaces the default interceptor stack. Now it is very easy to enhance
default interceptors without repeating the whole default stack:

~~~~~ java
	@Action
	@InterceptedBy(LogInterceptor.class, DefaultWebAppInterceptors.class)
	public void view() {
	}
~~~~~

This action is intercepted with 5 interceptors and `LogInterceptor` will
be invoked before all four from default stack.

## EchoInterceptor

Echo interceptor prints to system out some debugging information before
and after action execution: action path, result value and execution
time. It make sense to be the very first interceptor in the stack.

## ServletConfigInterceptor

This is the most important interceptor and contains part of the core
*Madvoc* functionality. It does the following:

1.  Sets character encoding for both request and response;
2.  Detects and prepares multi-part post requests;
3.  Performs the injection into the action object;
4.  Invokes the action method;
5.  Perform the outjection from the action object.

The most important thing here is injection/outjection.
`ServletConfigInterceptor` doesn't do much by itself. Instead, it
delegates injection/outjection to the **injectors** - independent
*Madvoc* parts. This makes possible for developers to have different
behavior of injection/outjection mechanisms, even to have their own.

This interceptor can be configured by modifying its properties of its
request scope injector:

* `injectParameters` - inject request parameters, by default it is
  `true`;
* `injectAttributes` - inject request attributes, by default it is
  `true`;
* `copyParamsToAttributes` - if `true`, all request parameters will be
  copied first to request attributes, so they becomes injected during
  attributes injection. If set to `true`, `injectParameters` may be set
  to `false`. By default it is `false`.
* `trimParams` - if `true`, all request parameters will be trimmed
  before further usage. By default it is `false`.
* `ignoreEmptyRequestParams` - if `true` (default value), empty
  parameters (with size 0) will be ignored as they do not exist.
  Checking if params are empty happens before optional trimming.

The easiest way to change the default behavior is to extend
`ServletConfigInterceptor` and override `init()` method.

## EchoInterceptor

Prints to system out stream action path, action class and method name,
result value, calculates execution time of action (and all inner
interceptors). Calculation time excludes result rendering, since result
is rendered after the interceptors execution.

## PrepareInterceptor

Prepares the action by invoking `prepare()` method before action method
execution. Action must implement `Preparable` interface to be prepared
by this interceptor. A typical use of this is to run some logic to load
an object from the database, so that when parameters are set they can be
set on this object.

## IdRequestInjectorInterceptor

Injects only request parameters and attributes that ends with \'.id\'.
It may be used before `PrepareInterceptor`, just to create objects and
populate id fields, so later in the `prepare()`this entity objects can
be fetched from the database (since id is known).

## AnnotatedFieldsInterceptor

Performs some operation on all fields annotated with provided
annotation. It is an abstract template, so it has to be customized for
specific usage.

## Custom interceptor

It is easy to create custom interceptor:

~~~~~ java
    public class CustomInterceptor extends ActionInterceptor {

    	@Override
    	public Object intercept(ActionRequest actionRequest) throws Exception {
    		return actionRequest.invoke();
    	}
    }
~~~~~

`ActionInterceptor` abstract class provides method: `init()` that will
be invoked once by *Madvoc* after interceptor initialization to perform
additional configuration.

Similarly, it is possible to create custom version of default
interceptors by extending them:

~~~~~ java
    public class AppServletConfigInterceptor extends ServletConfigInterceptor {

    	@Override
    	public void init() {
    		super.init();
    		requestInjector.setIgnoreEmptyRequestParams(false);
    	}
    }
~~~~~
