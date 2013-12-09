# Tx over actions

<div class="doc1"><js>doc1('example',22)</js></div>
Up to now we have used something what is consider as \'default\' layout
for three-tier web application. Actions uses services, transaction is
started, services uses DAOs, result is returned.

If we say that unit-of-work is what happens on one (user) action, we
will come to following situation: all actions will more-less delegates
to service layer. Calling more than one service method from one action
method is not totally correct: on unit-of-work should be wrapped with
single transaction (unless done differently on purpose). Even if we are
just reading, this should be done in one transaction, as one
unit-of-work. There are two consequences from this approach: web actions
code is dull and often one service has to return more results at once.

Lets take different approach to make development more pragmatic. Since
*Madvoc* actions are POJOs, we can say that our service starts with
action\'s method invocation that stores results in the action object
instead of returning them. So, *Madvoc* itself will be a presentation
layer, not our actions. Our previous service layer now becomes a
fine-grained business layer with \'thinner\' functions that can be
combined together to make some real work done.

In practice this means that we have to enable transactions over action
invocation.

## Implementation

One idea would be to use some transactional interceptor over actions.
However, this would not work out from web container - in our new
approach, interceptors are part of the presentation layer. So we will do
the same what we did with the service layer: add `@Transaction`
annotation over action methods.

The first change is, obviously, on *Proxetta* aspect definition (in
`AppCore`): now we need to include action classes as well:

~~~~~ java
    ...
    ProxyAspect txServiceProxy = new ProxyAspect(AnnotationTxAdvice.class,
    	new MethodAnnotationPointcut(Transaction.class) {
    		@Override
    		public boolean apply(MethodInfo methodInfo) {
    			return
    					isPublic(methodInfo) &&
    					isTopLevelMethod(methodInfo) &&
    					(matchClassName(methodInfo, "*Service") ||
    					matchClassName(methodInfo, "*Action")) &&
    					super.apply(methodInfo);
    	}
    });
    ...
~~~~~

Now lets make *Madvoc* to apply proxy before some action class is
registered. Obviously, we will do that on action registration. Here we
have to be careful; we want to create only one action proxy class for
all defined action methods. So, when some action (method) is registered
we have to check if its class is already proxified. For that purpose we
will create `ProxettaAwareActionsManager` component, that might looks
like this:

~~~~~ java
    public class ProxettaAwareActionsManager extends ActionsManager {

    	protected final Proxetta proxetta;
    	protected final Map<Class, Class> proxyActionClasses;

    	public ProxettaAwareActionsManager() {
    		this(null);
    	}
    	public ProxettaAwareActionsManager(Proxetta proxetta) {
    		this.proxetta = proxetta;
    		this.proxyActionClasses = new HashMap<Class, Class>();
    	}

    	@Override
    	protected synchronized void registerAction(Class actionClass, Method actionMethod, String actionPath) {
    		if (proxetta != null) {
    			// create action path from existing class (if not already exist)
    			if (actionPath == null) {
    				ActionConfig cfg = actionMethodParser.parse(actionClass, actionMethod, actionPath);
    				actionPath = cfg.actionPath;
    			}
    			// create proxy for action class if not already created
    			Class existing = proxyActionClasses.get(actionClass);
    			if (existing == null) {
    				existing = proxetta.defineProxy(actionClass);
    				proxyActionClasses.put(actionClass, existing);
    			}
    			actionClass = existing;
    		}
    		super.registerAction(actionClass, actionMethod, actionPath);
    	}
    }
~~~~~

Before applying proxy we have to resolve the action path if not already
set. Action path is parsed from class, therefore this has to be done
before proxy is created. Further, proxy has to be applied only on
classes that are not already proxified, so we will save all proxies
classes and defined proxy only for new ones.

This new *Madvoc* component has to be registered in standard way in our
`AppWebApplication`\:

~~~~~ java
    public class AppWebApplication extends PetiteWebApplication {
    ...
    	@Override
    	public void registerMadvocComponents() {
    		super.registerMadvocComponents();
    		registerComponent(new ProxettaAwareActionsManager(appCore.proxetta));
    	}
    ...
    }
~~~~~

Since it is extending default actions manager, it will also
automatically replace the existing action manager component.

## Usage

Just add `@Transaction` annotation over Madvoc action method. Note that
we are still able to declare transactions over services.

## WebRunner

`LocalRunner` will not be able to run services that are not annotated
with transaction attribute. Moreover, we should be able to run our new
service layer without the container. Therefore, we will create
`WebRunner`, simple class that will now work with `AppWebApplication`
instead of `AppCore`. Here is how such `WebRunner` may looks like:

~~~~~ java
    public class WebRunner {

    	public static void main(String[] args) {
    		AppWebApplication app = new AppWebApplication();
    		IndexAction ia = app.createAction(IndexAction.class);
    		ia.view();
    	}
    }
~~~~~

Our web application `AppWebApplication` needs to be enhanced with
`createAction` method, so we can create *Madvoc* actions without the
container:

~~~~~ java

    public <E> E createAction(Class<E> action) {
    	if (appCore.proxetta != null) {
    		action = appCore.proxetta.defineProxy(action);
    	}
    	return appCore.petite.createBean(action);
    }
~~~~~

Voila!
