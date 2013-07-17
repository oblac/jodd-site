# AOP aware Madvoc action requests

This is a story from *Madvoc*-Spring-Hibernate real-world project. In
this project, on some *Madvoc* actions Spring applied one or more
aspects, using CGLIB. Therefore, when *Madvoc* creates `ActionRequest`,
it contains a proxy class of the real action.

Why this is a problem? Because of interceptors and parameter/attributes
injection. If you are using *Madvoc* in a proposed way, actions will
have just fields annotated with `@In` and `@Out` annotations, and not
getters and setters methods - just for the sake of simplicity and less
code. However, it is impossible to inject fields value in CGLIB proxy
simply because they are not there: CGLIB proxy offers interface methods
of adviced target. Note that this would not be a case if *Proxetta* is
used instead of CGLIB;)

Solution is not hard: when new `ActionRequest` is created, we will
detect if corresponding action object is a proxy or not. So here we have
two tasks; first to instantiate custom `ActionRequest` and then to
work-around CGLIB proxy.

## Custom action requests

This one is trivial: `MadvocController` has method
`createActionRequest()` that can be overridden:

~~~~~ java
    public class FooMadvocController extends MadvocController {

    	@Override
    	protected ActionRequest createActionRequest(
                ActionConfig actionConfig, Object action,
                HttpServletRequest servletRequest, HttpServletResponse servletResponse) {

    		return new FooActionRequest(actionConfig, action, servletRequest, servletResponse);
    	}
    }
~~~~~

Here we decide what `ActionRequest` instance is going to be created and
used.

## Handling CGLIB proxy

The second step is to detect if action is a proxy and to find a
reference to original action (proxy target). Here is one simple
solution:

~~~~~ java
    public class FooActionRequest extends ActionRequest {

    	Object proxy;
    	Object target;

    	/**
    	 * Detects CGLIB proxy created by Spring. Stores proxy instance and replace advised target
    	 * before interceptors are invoked.
    	 */
    	public PectopahActionRequest(ActionConfig config, Object action, HttpServletRequest serlvetRequest, HttpServletResponse servletResponse) {
    		super(config, action, serlvetRequest, servletResponse);
    		if (AopUtils.isCglibProxy(action)) {
    			proxy = action;
    			try {
    				this.target = this.action = ((Advised) action).getTargetSource().getTarget();
    			} catch (Exception ex) {
    				throw new PectopahException("Invalid proxy.");
    			}
    		}
    	}

    	/**
    	 * After interceptors are invoked, replace back proxy instance.
    	 */
    	@Override
    	protected Object invokeAction() throws Exception {
    		if (proxy != null) {
    			action = proxy;
    		}
    		Object result = super.invokeAction();
    		if (proxy != null) {
    			action = target;
    		}
    		return result;
    	}
    }
~~~~~

In constructor we check if action is a proxy, and if that is a case, we
get the reference to the target action (the \'real\' action, not the
CGLIB proxy). Then, we will store the proxy instance, and use the real
instance of the action. The consequence is that all interceptors will
not see the proxy, and therefore, they will be able to inject into
fields.

Later, while action method is about to be invoked (`#invokeAction`), we
simply do the switch and place the proxy as an action.
