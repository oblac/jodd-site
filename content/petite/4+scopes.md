# Scopes

Each *Petite* bean has its **scope**. Within the bean scope there is one and only one instance associated with the bean name. Scopes are defined during the registration and container then maintains instances within the scopes. When bean is lookuped by its name, *Petite* will return instance that is unique for bean's scope.

*Petite* supports several scopes. It is possible and easy to create new, custom ones.

Two most common and used scopes are: `ProtoScope` and `SingletonScope`. The `SingletonScope` is the default scope, used when no scope is specified explicitly. Beans of this scope are unique for the whole *Petite* container and will be instantiated by container only once. On the other hand, beans of `ProtoScope` are instantiated every time when lookuped.

Scope is defined during bean registration:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    petite.registerBean(Foo.class, null, ProtoScope.class, null, false);
    petite.registerBean(Bar.class, null, null, null, false);
~~~~~

or, alternatively:

~~~~~ java
    registry.bean(Foo.class).scope(ProtoScope.class).register();
    registry.bean(Bar.class).register();
~~~~~

Now, each time when `foo` is retrieved from the container, a new
instance of `Foo` class will be created. And each time *Petite* will
inject the same instance of `Boo` class, since scope of `boo` bean is
(implicitly set as) `SingletonScope`.

## Available scopes

Here is the list of available *Petite* scopes:

+ `ProtoScope` - beans are created each time requested.
+ `SingletonScope` - beans are singletons for the container.
+ `SessionScope` - beans are singletons in current HTTP session. To have this feature, the `RequestContextListener` must be used.
+ `ThreadLocalScope` - beans are unique in the current thread.


## Using session scope

In order to use `SessionScope` (in a servlet container), the
following listeners has to be added to the `web.xml`:

~~~~~ xml
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app ...>
    	...
    	<listener>
    		<listener-class>
                jodd.servlet.RequestContextListener
            </listener-class>
    	</listener>
    	...
    </web-app>
~~~~~

## Using session scope outside of container

When container has session scope beans, it can't be used out of servlet container. This makes testing outside of container hard. However, *Petite* has one nice feature: it is possible to register scopes manually. In regular use case, it is not necessary to deal with scopes registration, since scopes will be resolved and instantiated on their first usage. Anyhow, it is possible to register specific scope instance for any scope that will be used instead of required one.

For example, it is possible to replace session scope with the singleton scope, what is usually enough for the tests:

~~~~~ java
    PetiteContainer petite = new PetiteContainer();
    petite.getManager().registerScope(SessionScope.class, new SingletonScope());
~~~~~

Now all session scope beans will be registered within singleton scope, assuming there is one and only one, big session.
