# Interceptors

**Action interceptor** executes some code _before_ and _after_ an action method is invoked. Interceptors encapsulates common concerns of actions. One action method may be intercepted by many interceptors. Some core *Madvoc* functionality is implemented using interceptors.

Besides the fact that interceptors are easy to configure and are very pluggable; they can be logically grouped in **interceptor stacks**, for more convenient configuration. Interceptor stack is just an simple array of interceptor references.

## Intercepting an action

To define an action interceptor, action method must be marked with `@InterceptedBy` annotation. This annotation has only one element: an array of interceptor class references that are intercepting the action:

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

It is also possible to put `@InterceptedBy` annotation on action class, to set interceptors for all action methods that are not explicitly intercepted, i.e. that have no interceptor annotation. The previous example may be alternatively written in the following way:

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

Real-world application may have more than one interceptor, and constantly repeating the interceptor class references for each action class/method is not a good idea. *Madvoc* allows to group interceptors into interceptor stacks.

Interceptor stack is simply a sublass of `ActionInterceptorStack` that defines an array of interceptors that belongs to the stack:

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

## ServletConfigInterceptor

This is the most important interceptor and contains part of the core *Madvoc* functionality. It does the following:

1.  Sets character encoding for both request and response;
2.  Detects and prepares multi-part post requests;
3.  Performs the injection into the action object;
4.  Invokes the action method;
5.  Perform the outjection from the action object.

The most important thing here is injection/outjection. `ServletConfigInterceptor` doesn't do much by itself. Instead, it delegates injection/outjection to the **injectors** - independent *Madvoc* parts. This makes possible for developers to have different behavior of injection/outjection mechanisms, even to have their own.


## EchoInterceptor

Prints to system out stream action path, action class and method name,
result value, calculates execution time of action (and all inner
interceptors). Calculation time excludes result rendering, since result
is rendered after the interceptors execution.

## AnnotatedPropertyInterceptor

Performs some operation on all properties annotated with provided
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

`ActionInterceptor` abstract class provides method: `init()` that will be invoked once by *Madvoc* after interceptor initialization to perform additional configuration.

Similarly, it is possible to create custom version of default interceptors by extending them:

~~~~~ java
    public class AppServletConfigInterceptor extends ServletConfigInterceptor {

    	@Override
    	public void init() {
    		super.init();
    		requestInjector.setIgnoreEmptyRequestParams(false);
    	}
    }
~~~~~
