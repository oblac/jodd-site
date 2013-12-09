# More wiring

<div class="doc1"><js>doc1('petite',20)</js></div>
More wiring topics.

## Wiring external beans with container

All beans registered into the container will be wired. Wiring is lazy,
i.e. it happens when some bean is requested (by bean name) for the first
time in its scope. *Petite* then creates new bean instance and wires it.

All this happens for beans that are inside the container, i.e.
registered. However, it is possible to wire any external object with the
container context anytime during the runtime of the application.

~~~~~ java
    PetiteContainer pc = ....
    Foo foo = new Foo();
    pc.wireBean(foo);
~~~~~

*Petite* will wire the `Foo` instance, but only using property and
method injection (since bean is already created). Important is that
`Foo` class is still not registered into the container. The only thing
*Petite* stores is just some internal cache data, to speed up further
injections for the same class.

It is possible to invoke init methods after wiring by setting second
optional argument of `wireBean()` method to `true`.

## Creating beans with container

*Petite* allows something more: to create the bean by container. This
makes constructor injection possible, what was not available for simple
wiring.

~~~~~ java
    PetiteContainer pc = ....
    Foo foo = pc.createBean(Foo.class);
~~~~~

Created beans are wired and init methods are invoked. However, created
beans are **not** registered into the container.

## Mixing scopes

By default, *Petite* does not support *mixed scopes*. In other words,
you should only inject beans of \'longer\' scopes into beans of
\'shorter\' scopes. For example, you may inject singleton bean into
session or prototype bean.

Doing opposite, by default, does not give any usable result. For
example, if you inject session bean into the singleton target, only the
one session bean will be wired! Singleton is created once, and
therefore, it is wired once, and whatever session is available at that
moment will be used for providing the session bean that will be injected
into the target.

Fortunately, *Petite* provides scoped proxies that allows mixing scopes.
Simply by enabling this flag, *Petite* will detect injections of mixed
scopes and will inject a proxy instead. This scoped proxy lookup for the
real bean and delegates method calls to it. By doing so, user will
always access the correct bean.

Here is an example. First we need to enable mixed scopes:

~~~~~ java
    PetiteContainer petiteContainer = ...
    petiteContainer.getConfig().setDetectMixedScopes(true);
    petiteContainer.getConfig().setWireScopedProxy(true);
~~~~~

We could use just the second flag; however, by enabling the detection
there will be additional message in the log.

Here is the singleton bean:

~~~~~ java
    @PetiteBean
    public class ItemService {

    	@PetiteInject
    	ItemManager itemManager;

    	public ItemManager getItemManager() {
    		return itemManager;
    	}

    	public void setItemManager(ItemManager itemManager) {
    		this.itemManager = itemManager;
    	}
    }
~~~~~

And here is the session scoped manager bean:

~~~~~ java
    @PetiteBean(scope = SessionScope.class)
    public class ItemManager {
    	...
    }
~~~~~

If you lookup for the `ItemService`, you will always get the singleton
instance. However, calling `getItemManager()` will return scoped proxy
for `ItemManager`, that will delegate to the real bean instance stored
in current session.

Note that scoped bean proxy is created only when mixed scopes are
detected. In above example, if `ItemManager` is used injected into
\'shorter\' scoped bean, no scoped proxy is created.
